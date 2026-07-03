import { onCall, HttpsError, CallableRequest } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import { auditLog } from "./shared";

/**
 * bootstrapFirstAdmin — TEK SEFERLİK.
 *
 * Sistemde henüz hiç admin yoksa, verilen email ile bir admin hesabı oluşturur
 * (veya varsa email'e admin role verir). Bir tane admin oluştuktan sonra
 * bir daha çalışmaz — her çağrı `already-exists` döner.
 *
 * Kullanım (bir kere):
 *  firebase functions:shell → bootstrapFirstAdmin({email:"...", password:"..."})
 *  veya app'ten çağrılabilir (auth gerektirmez).
 *
 * Admin oluşunca bu fonksiyon codebase'den silinmeli.
 */
export const bootstrapFirstAdmin = onCall(
  { region: "europe-west1" },
  async (req: CallableRequest) => {
    // Sistemde en az bir admin dokümanı var mı diye kontrol et
    const bootstrapFlag = admin
      .firestore()
      .collection("systemConfig")
      .doc("bootstrapAdmin");

    const flagSnap = await bootstrapFlag.get();
    if (flagSnap.exists && flagSnap.data()?.done === true) {
      throw new HttpsError(
        "already-exists",
        "Bootstrap admin already created. This function is disabled."
      );
    }

    const data = req.data as {
      email?: unknown;
      password?: unknown;
      displayName?: unknown;
    };
    const email = typeof data.email === "string" ? data.email.trim() : "";
    const password = typeof data.password === "string" ? data.password : "";
    const displayName =
      typeof data.displayName === "string"
        ? data.displayName.trim()
        : "Aliee Admin";

    if (!email || password.length < 8) {
      throw new HttpsError(
        "invalid-argument",
        "Email and password (min 8 characters) are required."
      );
    }

    // Kullanıcı var mı? yoksa oluştur.
    let userRecord: admin.auth.UserRecord;
    try {
      userRecord = await admin.auth().getUserByEmail(email);
    } catch {
      userRecord = await admin.auth().createUser({
        email,
        password,
        displayName,
        emailVerified: true,
      });
    }

    // Admin custom claim
    await admin
      .auth()
      .setCustomUserClaims(userRecord.uid, { role: "admin" });

    // Firestore'a admin kullanıcı dokümanı (yönetim listesi için)
    await admin.firestore().collection("admins").doc(userRecord.uid).set({
      email,
      displayName,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      bootstrapAdmin: true,
    });

    // Bootstrap flag'i işaretle — bir daha çalışmasın
    await bootstrapFlag.set({
      done: true,
      firstAdminUid: userRecord.uid,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    await auditLog({
      action: "bootstrap_admin_created",
      actorUid: userRecord.uid,
      actorRole: "admin",
      targetType: "admin",
      targetId: userRecord.uid,
      metadata: { email },
    });

    return {
      uid: userRecord.uid,
      email,
      message: "First admin created. You can now sign in with email + password.",
    };
  }
);
