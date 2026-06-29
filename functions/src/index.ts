/**
 * Aliee Wellness — Cloud Functions (region: europe-west1)
 *
 * Tüm yetki/kimlik kararları burada verilir. App'e güvenilmez.
 *
 * Fonksiyonlar (iskelet):
 *  - guestSignIn:        pasaport son 6 + oda no → hash karşılaştır → custom token döndür
 *                        (rate-limit: oda bazlı deneme sayacı)
 *  - adminAuthorizeGuest: tam pasaport + oda no + kimlik alanları → hash'le kaydet,
 *                        1 yıl erişim süresi belirle
 *  - adminDeactivateGuest: misafir erişimini manuel kapat
 *  - submitAnamnesis:    anamnez cevaplarını kaydet, program önerisi tetikle
 *  - askDoctor:          hasta → doktor sorusu oluştur
 *  - answerQuestion:     doktor → cevap (doktor yetkisi doğrula)
 *  - submitStayApplication: konaklama başvurusu kaydet ve Spektrum ekibine iletim
 */

import { onCall, HttpsError } from "firebase-functions/v2/https";
import { setGlobalOptions } from "firebase-functions/v2";
import * as admin from "firebase-admin";

admin.initializeApp();
setGlobalOptions({ region: "europe-west1", maxInstances: 10 });

// Placeholder — gerçek implementasyon Firebase project oluşturulduktan sonra yazılacak.
export const ping = onCall(async (req) => {
  if (!req.auth) {
    throw new HttpsError("unauthenticated", "Sign in required");
  }
  return { ok: true, ts: Date.now() };
});
