import { onCall, HttpsError, CallableRequest } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import { auditLog } from "./shared";

// -----------------------------------------------------------------------------
// adminCreateDoctor — admin yeni doktor hesabı oluşturur
// -----------------------------------------------------------------------------
export const adminCreateDoctor = onCall(
  { region: "europe-west1" },
  async (req: CallableRequest) => {
    const authRole = req.auth?.token?.role;
    if (!req.auth || authRole !== "admin") {
      throw new HttpsError(
        "permission-denied",
        "Admin privileges required for this action."
      );
    }

    const data = req.data as {
      email?: unknown;
      password?: unknown;
      firstName?: unknown;
      lastName?: unknown;
      specialty?: unknown;
      title?: unknown;
    };
    const email = typeof data.email === "string" ? data.email.trim() : "";
    const password = typeof data.password === "string" ? data.password : "";
    const firstName =
      typeof data.firstName === "string" ? data.firstName.trim() : "";
    const lastName =
      typeof data.lastName === "string" ? data.lastName.trim() : "";
    const specialty =
      typeof data.specialty === "string" ? data.specialty.trim() : "";
    const title = typeof data.title === "string" ? data.title.trim() : "Dr.";

    if (!email || password.length < 6) {
      throw new HttpsError(
        "invalid-argument",
        "Email and password (min 6 characters) are required."
      );
    }
    if (!firstName || !lastName) {
      throw new HttpsError("invalid-argument", "Ad ve soyad zorunlu.");
    }

    // Aynı email zaten kullanılıyorsa kayıt açma
    try {
      await admin.auth().getUserByEmail(email);
      throw new HttpsError(
        "already-exists",
        "This email is already registered."
      );
    } catch (e) {
      if (
        e instanceof HttpsError ||
        (e as { code?: string }).code !== "auth/user-not-found"
      ) {
        if (e instanceof HttpsError) throw e;
        // getUserByEmail dışı hatalar için genel hata
        throw new HttpsError("internal", "User lookup failed.");
      }
    }

    const user = await admin.auth().createUser({
      email,
      password,
      displayName: `${title} ${firstName} ${lastName}`,
      emailVerified: true,
    });
    await admin.auth().setCustomUserClaims(user.uid, { role: "doctor" });

    await admin.firestore().collection("doctors").doc(user.uid).set({
      email,
      firstName,
      lastName,
      specialty,
      title,
      active: true,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      createdBy: req.auth.uid,
    });

    await auditLog({
      action: "doctor_created",
      actorUid: req.auth.uid,
      actorRole: "admin",
      targetType: "doctor",
      targetId: user.uid,
      metadata: { email, specialty },
    });

    return { doctorId: user.uid, email };
  }
);

// -----------------------------------------------------------------------------
// adminDeactivateDoctor
// -----------------------------------------------------------------------------
export const adminDeactivateDoctor = onCall(
  { region: "europe-west1" },
  async (req: CallableRequest) => {
    const authRole = req.auth?.token?.role;
    if (!req.auth || authRole !== "admin") {
      throw new HttpsError(
        "permission-denied",
        "Admin privileges required for this action."
      );
    }
    const data = req.data as { doctorId?: unknown };
    const doctorId =
      typeof data.doctorId === "string" ? data.doctorId.trim() : "";
    if (!doctorId) {
      throw new HttpsError("invalid-argument", "doctorId zorunlu.");
    }
    await admin.firestore().collection("doctors").doc(doctorId).update({
      active: false,
      deactivatedAt: admin.firestore.FieldValue.serverTimestamp(),
      deactivatedBy: req.auth.uid,
    });
    await admin.auth().updateUser(doctorId, { disabled: true });
    await auditLog({
      action: "doctor_deactivated",
      actorUid: req.auth.uid,
      actorRole: "admin",
      targetType: "doctor",
      targetId: doctorId,
    });
    return { ok: true };
  }
);
