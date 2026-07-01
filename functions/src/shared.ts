import * as admin from "firebase-admin";

// Yalnızca alfa-numerik karakterleri koru, uppercase yap.
// Pasaport ve oda no için ortak normalizasyon (brief §2.4 — "sunucuda normalize edilmeli").
export function normalizeAlphaNum(input: unknown): string {
  if (typeof input !== "string") return "";
  return input.trim().toUpperCase().replace(/[^A-Z0-9]/g, "");
}

// Oda numarası: sadece rakamları al, baştaki sıfırları koruma (misafirin "07" ile "7" girmesi
// aynı odaya denk gelsin). Fakat kayıt sırasında da aynı normalizasyon uygulanır.
export function normalizeRoomNumber(input: unknown): string {
  if (typeof input !== "string" && typeof input !== "number") return "";
  const s = String(input).trim().replace(/[^0-9]/g, "");
  // Baştaki sıfırları at, ama boş string olmasın diye "0" saklıyoruz
  const stripped = s.replace(/^0+/, "");
  return stripped.length > 0 ? stripped : (s.length > 0 ? "0" : "");
}

// Tam pasaporttan son 6 haneyi çıkar (harf+rakam karışık son 6).
export function extractPassportLast6(fullPassport: string): string {
  const clean = normalizeAlphaNum(fullPassport);
  return clean.slice(-6);
}

// Firestore audit log — admin işlemleri + auth denemeleri buraya yazılır.
// Rules: sadece admin okur, sadece function yazar.
export async function auditLog(entry: {
  action: string;
  actorUid?: string | null;
  actorRole?: string | null;
  targetType?: string;
  targetId?: string;
  ip?: string | null;
  metadata?: Record<string, unknown>;
}): Promise<void> {
  try {
    await admin.firestore().collection("auditLog").add({
      ...entry,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });
  } catch (e) {
    console.error("auditLog write failed", e);
    // Audit log hatası fonksiyonu bloklamaz.
  }
}
