import { onCall, HttpsError, CallableRequest } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import { auditLog } from "./shared";

/**
 * devResetTestCredentials — TEK SEFERLİK dev yardımcısı.
 *
 * admin@aliee.local ve doktor@aliee.local için şifreyi "123456" yapar,
 * doktor kullanıcısı yoksa oluşturur.
 *
 * Bir kez çalıştırıldıktan sonra Firestore'daki systemConfig/devResetDone
 * flag'i işaretlenir; tekrar çağrılamaz. Bu function testten sonra
 * codebase'den silinmeli.
 */
export const devResetTestCredentials = onCall(
  { region: "europe-west1" },
  async (_req: CallableRequest) => {
    const db = admin.firestore();
    const flagRef = db.collection("systemConfig").doc("devResetDone");
    const flagSnap = await flagRef.get();
    if (flagSnap.exists && flagSnap.data()?.done === true) {
      throw new HttpsError(
        "already-exists",
        "devResetTestCredentials zaten çalıştırılmış."
      );
    }

    // 1) Admin şifresini sıfırla
    let adminUid: string;
    try {
      const u = await admin.auth().getUserByEmail("admin@aliee.local");
      adminUid = u.uid;
      await admin.auth().updateUser(adminUid, { password: "123456" });
    } catch {
      const u = await admin.auth().createUser({
        email: "admin@aliee.local",
        password: "123456",
        displayName: "Aliee Admin",
        emailVerified: true,
      });
      adminUid = u.uid;
    }
    await admin.auth().setCustomUserClaims(adminUid, { role: "admin" });
    await db.collection("admins").doc(adminUid).set(
      {
        email: "admin@aliee.local",
        displayName: "Aliee Admin",
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      },
      { merge: true }
    );

    // 2) Doktor hesabı (varsa güncelle, yoksa oluştur)
    let doctorUid: string;
    try {
      const u = await admin.auth().getUserByEmail("doktor@aliee.local");
      doctorUid = u.uid;
      await admin.auth().updateUser(doctorUid, {
        password: "123456",
        disabled: false,
        displayName: "Dr. Aliee",
      });
    } catch {
      const u = await admin.auth().createUser({
        email: "doktor@aliee.local",
        password: "123456",
        displayName: "Dr. Aliee",
        emailVerified: true,
      });
      doctorUid = u.uid;
    }
    await admin.auth().setCustomUserClaims(doctorUid, { role: "doctor" });
    await db.collection("doctors").doc(doctorUid).set(
      {
        email: "doktor@aliee.local",
        firstName: "Aliee",
        lastName: "Test",
        title: "Dr.",
        specialty: "Longevity",
        active: true,
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      },
      { merge: true }
    );

    await flagRef.set({
      done: true,
      at: admin.firestore.FieldValue.serverTimestamp(),
    });

    await auditLog({
      action: "dev_reset_credentials",
      metadata: { adminUid, doctorUid },
    });

    return {
      admin: { uid: adminUid, email: "admin@aliee.local", password: "123456" },
      doctor: {
        uid: doctorUid,
        email: "doktor@aliee.local",
        password: "123456",
      },
    };
  }
);
