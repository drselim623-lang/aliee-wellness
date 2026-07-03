import { onCall, HttpsError, CallableRequest } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import { auditLog } from "./shared";
import {
  recommendProgram,
  AnamnesisAnswers,
  RecommendedService,
} from "./recommender";

// -----------------------------------------------------------------------------
// submitAnamnesis — misafir anamnezi kaydeder, program önerisi üretilir
// -----------------------------------------------------------------------------
export const submitAnamnesis = onCall(
  { region: "europe-west1" },
  async (req: CallableRequest) => {
    const role = req.auth?.token?.role as string | undefined;
    if (!req.auth || role !== "guest") {
      throw new HttpsError("permission-denied", "Guest sign-in required.");
    }
    const uid = req.auth.uid;

    const raw = req.data as Partial<AnamnesisAnswers>;
    // Basit input normalizasyonu — client zaten form validation yapıyor
    const answers: AnamnesisAnswers = {
      chronicConditions: cleanList(raw.chronicConditions),
      currentMedications: cleanList(raw.currentMedications),
      allergies: cleanList(raw.allergies),
      familyHistory: cleanList(raw.familyHistory),
      surgeries: cleanList(raw.surgeries),
      sleepHoursAvg: clampInt(raw.sleepHoursAvg, 0, 24, 7),
      sleepQuality: cleanStr(raw.sleepQuality, "fair"),
      dietType: cleanStr(raw.dietType, "omnivore"),
      exerciseDaysPerWeek: clampInt(raw.exerciseDaysPerWeek, 0, 7, 2),
      smokes: raw.smokes === true,
      alcoholFrequency: cleanStr(raw.alcoholFrequency, "rarely"),
      perceivedStress: clampInt(raw.perceivedStress, 1, 10, 5),
      currentComplaints: cleanList(raw.currentComplaints),
      healthGoals: cleanList(raw.healthGoals),
      freeText: raw.freeText ? String(raw.freeText).slice(0, 4000) : undefined,
    };

    const recommendations: RecommendedService[] = recommendProgram(answers);

    const db = admin.firestore();
    const now = admin.firestore.FieldValue.serverTimestamp();

    // "latest" tek doküman, history'de tüm gönderim sürümleri tutulur
    const guestRef = db.collection("guests").doc(uid);
    const anamnesisLatestRef = guestRef.collection("anamnesis").doc("latest");
    const historyRef = guestRef.collection("anamnesisHistory").doc();
    const recommendationRef =
      guestRef.collection("programRecommendation").doc("latest");

    const batch = db.batch();
    batch.set(anamnesisLatestRef, {
      ...answers,
      submittedAt: now,
    });
    batch.set(historyRef, {
      ...answers,
      submittedAt: now,
    });
    batch.set(recommendationRef, {
      recommendations,
      generatedAt: now,
      sourceHistoryId: historyRef.id,
    });
    await batch.commit();

    await auditLog({
      action: "anamnesis_submitted",
      actorUid: uid,
      actorRole: "guest",
      targetType: "guest",
      targetId: uid,
      metadata: { recCount: recommendations.length },
    });

    return {
      recommendationCount: recommendations.length,
      recommendations,
    };
  }
);

// -----------------------------------------------------------------------------
// saveLabMetadata — misafir bir lab dosyası yükledikten sonra metadata kaydeder
// -----------------------------------------------------------------------------
export const saveLabMetadata = onCall(
  { region: "europe-west1" },
  async (req: CallableRequest) => {
    const role = req.auth?.token?.role as string | undefined;
    if (!req.auth || role !== "guest") {
      throw new HttpsError("permission-denied", "Guest sign-in required.");
    }
    const uid = req.auth.uid;

    const data = req.data as {
      storagePath?: unknown;
      downloadUrl?: unknown;
      fileName?: unknown;
      contentType?: unknown;
      sizeBytes?: unknown;
      notes?: unknown;
    };

    const storagePath = String(data.storagePath ?? "").trim();
    const downloadUrl = String(data.downloadUrl ?? "").trim();
    const fileName = String(data.fileName ?? "").trim();
    const contentType = String(data.contentType ?? "").trim();
    const sizeBytes = Number(data.sizeBytes ?? 0);
    const notes = data.notes ? String(data.notes).slice(0, 1000) : null;

    if (!storagePath || !fileName) {
      throw new HttpsError(
        "invalid-argument",
        "storagePath ve fileName zorunlu."
      );
    }
    // Güvenlik: path sadece kendi klasörüne yazılmalı
    if (!storagePath.startsWith(`guests/${uid}/labs/`)) {
      throw new HttpsError(
        "permission-denied",
        "You can only upload files to your own folder."
      );
    }

    const now = admin.firestore.FieldValue.serverTimestamp();
    const ref = admin
      .firestore()
      .collection("guests")
      .doc(uid)
      .collection("labs")
      .doc();
    await ref.set({
      storagePath,
      downloadUrl,
      fileName,
      contentType,
      sizeBytes,
      notes,
      uploadedAt: now,
    });

    await auditLog({
      action: "lab_uploaded",
      actorUid: uid,
      actorRole: "guest",
      targetType: "lab",
      targetId: ref.id,
      metadata: { fileName, sizeBytes, contentType },
    });

    return { labId: ref.id };
  }
);

// -----------------------------------------------------------------------------
// helpers
// -----------------------------------------------------------------------------

function cleanList(v: unknown): string[] {
  if (!Array.isArray(v)) return [];
  return v
    .map((x) => String(x ?? "").trim())
    .filter((s) => s.length > 0)
    .slice(0, 40);
}

function cleanStr(v: unknown, fallback: string): string {
  if (typeof v !== "string") return fallback;
  const s = v.trim().toLowerCase();
  return s.length > 0 ? s : fallback;
}

function clampInt(
  v: unknown,
  min: number,
  max: number,
  fallback: number
): number {
  const n = typeof v === "number" ? v : parseInt(String(v ?? ""), 10);
  if (Number.isNaN(n)) return fallback;
  return Math.min(max, Math.max(min, Math.floor(n)));
}
