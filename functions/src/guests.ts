import { onCall, HttpsError, CallableRequest } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import * as bcrypt from "bcryptjs";

import {
  normalizeAlphaNum,
  normalizeRoomNumber,
  extractPassportLast6,
  auditLog,
} from "./shared";

// Rate limit parametreleri — brief §2.4 "oda bazlı deneme limiti"
const MAX_FAILED_ATTEMPTS = 5;
const ATTEMPT_WINDOW_MS = 15 * 60 * 1000; // 15 dakika
const LOCK_DURATION_MS = 30 * 60 * 1000; // 30 dakika kilit
const BCRYPT_COST = 10;
const ACCESS_DURATION_MS = 365 * 24 * 60 * 60 * 1000; // 1 yıl

// -----------------------------------------------------------------------------
// guestSignIn — misafirin app'ten çağırdığı, pasaport son 6 + oda no doğrular
// -----------------------------------------------------------------------------
export const guestSignIn = onCall(
  { region: "europe-west1", enforceAppCheck: false },
  async (req: CallableRequest) => {
    const data = req.data as { passportLast6?: unknown; roomNumber?: unknown };
    const passportLast6 = normalizeAlphaNum(data.passportLast6).slice(0, 6);
    const roomNumber = normalizeRoomNumber(data.roomNumber);
    const ip = req.rawRequest?.ip ?? null;

    if (passportLast6.length !== 6) {
      throw new HttpsError("invalid-argument", "Pasaport son 6 hanesi eksik.");
    }
    if (!roomNumber) {
      throw new HttpsError("invalid-argument", "Room number is missing.");
    }

    const db = admin.firestore();
    const rlRef = db.collection("rateLimit").doc(roomNumber);

    // 1) Rate limit — kilit varsa reddet, penceresi bitmişse sayacı sıfırla
    const rlSnap = await rlRef.get();
    const now = Date.now();
    if (rlSnap.exists) {
      const rl = rlSnap.data() as {
        lockedUntil?: FirebaseFirestore.Timestamp;
      };
      if (rl.lockedUntil && rl.lockedUntil.toMillis() > now) {
        const remainingMin = Math.ceil(
          (rl.lockedUntil.toMillis() - now) / 60000
        );
        await auditLog({
          action: "guest_signin_locked",
          targetType: "room",
          targetId: roomNumber,
          ip,
          metadata: { remainingMin },
        });
        throw new HttpsError(
          "resource-exhausted",
          `Çok fazla hatalı deneme. Lütfen ${remainingMin} dakika sonra tekrar deneyin.`
        );
      }
    }

    // 2) Adayları bul — oda no eşleşen, aktif, süresi geçmemiş misafirler
    const candidatesSnap = await db
      .collection("guests")
      .where("roomNumber", "==", roomNumber)
      .where("active", "==", true)
      .get();

    let matchedGuestId: string | null = null;
    for (const doc of candidatesSnap.docs) {
      const g = doc.data() as {
        passportHashLast6?: string;
        expiresAt?: FirebaseFirestore.Timestamp;
      };
      if (!g.passportHashLast6) continue;
      if (g.expiresAt && g.expiresAt.toMillis() < now) continue;
      // eslint-disable-next-line no-await-in-loop
      const match = await bcrypt.compare(passportLast6, g.passportHashLast6);
      if (match) {
        matchedGuestId = doc.id;
        break;
      }
    }

    // 3) Başarısız → rate limit sayacını artır, kilit gerekiyorsa kilitle
    if (!matchedGuestId) {
      await handleFailedAttempt(rlRef, now);
      await auditLog({
        action: "guest_signin_failed",
        targetType: "room",
        targetId: roomNumber,
        ip,
      });
      throw new HttpsError(
        "not-found",
        "Passport or room number could not be verified."
      );
    }

    // 4) Başarılı → rate limit sıfırla, custom claim'li token dön
    await rlRef.set(
      {
        failedAttempts: 0,
        firstFailedAt: admin.firestore.FieldValue.delete(),
        lockedUntil: admin.firestore.FieldValue.delete(),
      },
      { merge: true }
    );

    // guestId = Firebase Auth uid. Custom token'a role claim ekliyoruz.
    const customToken = await admin.auth().createCustomToken(matchedGuestId, {
      role: "guest",
    });

    await db.collection("guests").doc(matchedGuestId).set(
      {
        lastLoginAt: admin.firestore.FieldValue.serverTimestamp(),
      },
      { merge: true }
    );

    await auditLog({
      action: "guest_signin_success",
      actorUid: matchedGuestId,
      actorRole: "guest",
      targetType: "guest",
      targetId: matchedGuestId,
      ip,
    });

    return { token: customToken };
  }
);

async function handleFailedAttempt(
  rlRef: FirebaseFirestore.DocumentReference,
  now: number
): Promise<void> {
  await admin.firestore().runTransaction(async (tx) => {
    const snap = await tx.get(rlRef);
    if (!snap.exists) {
      tx.set(rlRef, {
        failedAttempts: 1,
        firstFailedAt: admin.firestore.Timestamp.fromMillis(now),
      });
      return;
    }
    const rl = snap.data() as {
      failedAttempts?: number;
      firstFailedAt?: FirebaseFirestore.Timestamp;
    };
    const firstAtMs = rl.firstFailedAt?.toMillis() ?? now;
    const windowExpired = now - firstAtMs > ATTEMPT_WINDOW_MS;
    const attempts = windowExpired ? 1 : (rl.failedAttempts ?? 0) + 1;
    const update: FirebaseFirestore.UpdateData<Record<string, unknown>> = {
      failedAttempts: attempts,
      firstFailedAt: windowExpired
        ? admin.firestore.Timestamp.fromMillis(now)
        : rl.firstFailedAt,
    };
    if (attempts >= MAX_FAILED_ATTEMPTS) {
      update.lockedUntil = admin.firestore.Timestamp.fromMillis(
        now + LOCK_DURATION_MS
      );
      update.failedAttempts = 0; // kilit sonrası sayacı temizle
      update.firstFailedAt = admin.firestore.FieldValue.delete();
    }
    tx.update(rlRef, update);
  });
}

// -----------------------------------------------------------------------------
// adminAuthorizeGuest — Spektrum ekibi check-in'de misafiri sisteme ekler
// -----------------------------------------------------------------------------
export const adminAuthorizeGuest = onCall(
  { region: "europe-west1", enforceAppCheck: false },
  async (req: CallableRequest) => {
    // Yetki kontrolü — sadece admin çağırabilir
    const authRole = req.auth?.token?.role;
    if (!req.auth || authRole !== "admin") {
      throw new HttpsError(
        "permission-denied",
        "Admin privileges required for this action."
      );
    }

    const data = req.data as {
      fullPassport?: unknown;
      roomNumber?: unknown;
      firstName?: unknown;
      lastName?: unknown;
      nationality?: unknown;
      email?: unknown;
      phone?: unknown;
    };

    const fullPassportNorm = normalizeAlphaNum(data.fullPassport);
    const last6 = extractPassportLast6(fullPassportNorm);
    const roomNumber = normalizeRoomNumber(data.roomNumber);
    const firstName =
      typeof data.firstName === "string" ? data.firstName.trim() : "";
    const lastName =
      typeof data.lastName === "string" ? data.lastName.trim() : "";
    const nationality =
      typeof data.nationality === "string" ? data.nationality.trim() : null;
    const email = typeof data.email === "string" ? data.email.trim() : null;
    const phone = typeof data.phone === "string" ? data.phone.trim() : null;

    if (fullPassportNorm.length < 6) {
      throw new HttpsError(
        "invalid-argument",
        "Passport number must be at least 6 characters."
      );
    }
    if (!roomNumber) {
      throw new HttpsError("invalid-argument", "Room number is missing.");
    }
    if (!firstName || !lastName) {
      throw new HttpsError("invalid-argument", "Ad ve soyad zorunlu.");
    }

    const db = admin.firestore();

    // Aynı oda + aynı pasaport hash zaten aktifse tekrar açma — güncelle
    const existingSnap = await db
      .collection("guests")
      .where("roomNumber", "==", roomNumber)
      .where("active", "==", true)
      .get();

    for (const doc of existingSnap.docs) {
      const g = doc.data() as { passportHashLast6?: string };
      if (!g.passportHashLast6) continue;
      // eslint-disable-next-line no-await-in-loop
      const alreadyExists = await bcrypt.compare(last6, g.passportHashLast6);
      if (alreadyExists) {
        // Var olan misafirin süresini uzat + bilgilerini güncelle
        const now = Date.now();
        const expiresAt = admin.firestore.Timestamp.fromMillis(
          now + ACCESS_DURATION_MS
        );
        // eslint-disable-next-line no-await-in-loop
        await doc.ref.update({
          firstName,
          lastName,
          nationality,
          email,
          phone,
          authorizedAt: admin.firestore.FieldValue.serverTimestamp(),
          expiresAt,
          authorizedBy: req.auth.uid,
        });
        await auditLog({
          action: "guest_reauthorized",
          actorUid: req.auth.uid,
          actorRole: "admin",
          targetType: "guest",
          targetId: doc.id,
        });
        return { guestId: doc.id, updated: true };
      }
    }

    // Yeni misafir — hash'le ve kaydet
    const passportHashLast6 = await bcrypt.hash(last6, BCRYPT_COST);
    const passportHashFull = await bcrypt.hash(fullPassportNorm, BCRYPT_COST);

    // Auth user oluştur (uid = ileride custom token için)
    const authUser = await admin.auth().createUser({
      displayName: `${firstName} ${lastName}`,
      disabled: false,
    });
    await admin
      .auth()
      .setCustomUserClaims(authUser.uid, { role: "guest" });

    const now = Date.now();
    const expiresAt = admin.firestore.Timestamp.fromMillis(
      now + ACCESS_DURATION_MS
    );

    await db.collection("guests").doc(authUser.uid).set({
      roomNumber,
      passportHashLast6,
      passportHashFull,
      firstName,
      lastName,
      nationality,
      email,
      phone,
      active: true,
      authorizedAt: admin.firestore.FieldValue.serverTimestamp(),
      expiresAt,
      authorizedBy: req.auth.uid,
    });

    await auditLog({
      action: "guest_authorized",
      actorUid: req.auth.uid,
      actorRole: "admin",
      targetType: "guest",
      targetId: authUser.uid,
    });

    return { guestId: authUser.uid, updated: false };
  }
);

// -----------------------------------------------------------------------------
// adminDeactivateGuest — misafir erişimini manuel kapatma
// -----------------------------------------------------------------------------
export const adminDeactivateGuest = onCall(
  { region: "europe-west1", enforceAppCheck: false },
  async (req: CallableRequest) => {
    const authRole = req.auth?.token?.role;
    if (!req.auth || authRole !== "admin") {
      throw new HttpsError(
        "permission-denied",
        "Admin privileges required for this action."
      );
    }
    const data = req.data as { guestId?: unknown };
    const guestId =
      typeof data.guestId === "string" ? data.guestId.trim() : "";
    if (!guestId) {
      throw new HttpsError("invalid-argument", "guestId zorunlu.");
    }
    await admin.firestore().collection("guests").doc(guestId).update({
      active: false,
      deactivatedAt: admin.firestore.FieldValue.serverTimestamp(),
      deactivatedBy: req.auth.uid,
    });
    await admin.auth().updateUser(guestId, { disabled: true });
    await auditLog({
      action: "guest_deactivated",
      actorUid: req.auth.uid,
      actorRole: "admin",
      targetType: "guest",
      targetId: guestId,
    });
    return { ok: true };
  }
);
