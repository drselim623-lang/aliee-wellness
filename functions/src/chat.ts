import { onCall, HttpsError, CallableRequest } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import { auditLog } from "./shared";

/**
 * Chat mimarisi:
 *
 *   questions/{questionId}:
 *     guestId, doctorId, guestName, doctorName,
 *     lastMessageAt, lastMessagePreview,
 *     unreadForDoctor, unreadForGuest,
 *     status ("open"), createdAt
 *
 *   questions/{questionId}/messages/{messageId}:
 *     senderId, senderRole, text, attachmentUrl, attachmentType, createdAt
 *
 * Fonksiyonlar:
 *   startQuestion({doctorId, text?})    — misafir yeni konuşma açar
 *   sendMessage({questionId, text?, attachmentUrl?, attachmentType?})
 *   markQuestionRead({questionId})       — okundu işaretle (rolüne göre sıfırlar)
 */

const MAX_TEXT_LEN = 4000;

function requireRole(
  req: CallableRequest,
  ...allowed: string[]
): { uid: string; role: string } {
  const role = req.auth?.token?.role as string | undefined;
  if (!req.auth || !role || !allowed.includes(role)) {
    throw new HttpsError("permission-denied", "Yetkisiz.");
  }
  return { uid: req.auth.uid, role };
}

async function getGuestName(uid: string): Promise<string> {
  const doc = await admin.firestore().collection("guests").doc(uid).get();
  if (!doc.exists) return "";
  const d = doc.data() as { firstName?: string; lastName?: string };
  return `${d.firstName ?? ""} ${d.lastName ?? ""}`.trim();
}

async function getDoctorSummary(uid: string): Promise<{
  displayName: string;
  active: boolean;
}> {
  const doc = await admin.firestore().collection("doctors").doc(uid).get();
  if (!doc.exists) return { displayName: "", active: false };
  const d = doc.data() as {
    firstName?: string;
    lastName?: string;
    title?: string;
    active?: boolean;
  };
  const displayName =
    `${d.title ?? "Dr."} ${d.firstName ?? ""} ${d.lastName ?? ""}`.trim();
  return { displayName, active: d.active !== false };
}

// -----------------------------------------------------------------------------
// startQuestion
// -----------------------------------------------------------------------------
export const startQuestion = onCall(
  { region: "europe-west1" },
  async (req: CallableRequest) => {
    const { uid } = requireRole(req, "guest");
    const data = req.data as {
      doctorId?: unknown;
      text?: unknown;
      attachmentUrl?: unknown;
      attachmentType?: unknown;
    };
    const doctorId =
      typeof data.doctorId === "string" ? data.doctorId.trim() : "";
    const text = typeof data.text === "string" ? data.text.trim() : "";
    const attachmentUrl =
      typeof data.attachmentUrl === "string" ? data.attachmentUrl.trim() : "";
    const attachmentType =
      typeof data.attachmentType === "string"
        ? data.attachmentType.trim()
        : "";

    if (!doctorId) {
      throw new HttpsError("invalid-argument", "doctorId zorunlu.");
    }
    if (!text && !attachmentUrl) {
      throw new HttpsError(
        "invalid-argument",
        "The first message must contain text or a file."
      );
    }
    if (text.length > MAX_TEXT_LEN) {
      throw new HttpsError("invalid-argument", "Message too long.");
    }

    const doctor = await getDoctorSummary(doctorId);
    if (!doctor.active) {
      throw new HttpsError("not-found", "Doctor not found or not active.");
    }
    const guestName = await getGuestName(uid);

    const db = admin.firestore();
    const qRef = db.collection("questions").doc();
    const mRef = qRef.collection("messages").doc();
    const now = admin.firestore.FieldValue.serverTimestamp();
    const preview = text.length > 0
      ? text.slice(0, 100)
      : "📎 File shared";

    const batch = db.batch();
    batch.set(qRef, {
      guestId: uid,
      doctorId,
      guestName,
      doctorName: doctor.displayName,
      status: "open",
      lastMessageAt: now,
      lastMessagePreview: preview,
      unreadForDoctor: 1,
      unreadForGuest: 0,
      createdAt: now,
    });
    batch.set(mRef, {
      senderId: uid,
      senderRole: "guest",
      text: text || null,
      attachmentUrl: attachmentUrl || null,
      attachmentType: attachmentType || null,
      createdAt: now,
    });
    await batch.commit();

    await auditLog({
      action: "question_started",
      actorUid: uid,
      actorRole: "guest",
      targetType: "question",
      targetId: qRef.id,
      metadata: { doctorId },
    });

    return { questionId: qRef.id };
  }
);

// -----------------------------------------------------------------------------
// sendMessage
// -----------------------------------------------------------------------------
export const sendMessage = onCall(
  { region: "europe-west1" },
  async (req: CallableRequest) => {
    const { uid, role } = requireRole(req, "guest", "doctor");
    const data = req.data as {
      questionId?: unknown;
      text?: unknown;
      attachmentUrl?: unknown;
      attachmentType?: unknown;
    };
    const questionId =
      typeof data.questionId === "string" ? data.questionId.trim() : "";
    const text = typeof data.text === "string" ? data.text.trim() : "";
    const attachmentUrl =
      typeof data.attachmentUrl === "string" ? data.attachmentUrl.trim() : "";
    const attachmentType =
      typeof data.attachmentType === "string"
        ? data.attachmentType.trim()
        : "";

    if (!questionId) {
      throw new HttpsError("invalid-argument", "questionId zorunlu.");
    }
    if (!text && !attachmentUrl) {
      throw new HttpsError("invalid-argument", "Text or file required.");
    }
    if (text.length > MAX_TEXT_LEN) {
      throw new HttpsError("invalid-argument", "Message too long.");
    }

    const db = admin.firestore();
    const qRef = db.collection("questions").doc(questionId);
    const qSnap = await qRef.get();
    if (!qSnap.exists) {
      throw new HttpsError("not-found", "Conversation not found.");
    }
    const q = qSnap.data() as {
      guestId?: string;
      doctorId?: string;
    };
    // Yetki: sadece konuşmanın tarafları mesaj gönderebilir
    if (role === "guest" && q.guestId !== uid) {
      throw new HttpsError("permission-denied", "You are not a participant in this conversation.");
    }
    if (role === "doctor" && q.doctorId !== uid) {
      throw new HttpsError("permission-denied", "You are not a participant in this conversation.");
    }

    const preview = text.length > 0
      ? text.slice(0, 100)
      : "📎 File shared";
    const unreadField =
      role === "guest" ? "unreadForDoctor" : "unreadForGuest";
    const otherUnreadField =
      role === "guest" ? "unreadForGuest" : "unreadForDoctor";

    const mRef = qRef.collection("messages").doc();
    const now = admin.firestore.FieldValue.serverTimestamp();
    const batch = db.batch();
    batch.set(mRef, {
      senderId: uid,
      senderRole: role,
      text: text || null,
      attachmentUrl: attachmentUrl || null,
      attachmentType: attachmentType || null,
      createdAt: now,
    });
    batch.update(qRef, {
      lastMessageAt: now,
      lastMessagePreview: preview,
      [unreadField]: admin.firestore.FieldValue.increment(1),
      // Gönderen kendi tarafını sıfırlar (kendi mesajını okumuş sayılır)
      [otherUnreadField]: 0,
    });
    await batch.commit();

    return { messageId: mRef.id };
  }
);

// -----------------------------------------------------------------------------
// markQuestionRead
// -----------------------------------------------------------------------------
export const markQuestionRead = onCall(
  { region: "europe-west1" },
  async (req: CallableRequest) => {
    const { uid, role } = requireRole(req, "guest", "doctor");
    const data = req.data as { questionId?: unknown };
    const questionId =
      typeof data.questionId === "string" ? data.questionId.trim() : "";
    if (!questionId) {
      throw new HttpsError("invalid-argument", "questionId zorunlu.");
    }
    const db = admin.firestore();
    const qRef = db.collection("questions").doc(questionId);
    const qSnap = await qRef.get();
    if (!qSnap.exists) {
      throw new HttpsError("not-found", "Conversation not found.");
    }
    const q = qSnap.data() as { guestId?: string; doctorId?: string };
    if (role === "guest" && q.guestId !== uid) {
      throw new HttpsError("permission-denied", "Yetkisiz.");
    }
    if (role === "doctor" && q.doctorId !== uid) {
      throw new HttpsError("permission-denied", "Yetkisiz.");
    }
    await qRef.update({
      [role === "guest" ? "unreadForGuest" : "unreadForDoctor"]: 0,
    });
    return { ok: true };
  }
);
