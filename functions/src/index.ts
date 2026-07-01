/**
 * Aliee Wellness — Cloud Functions (region: europe-west1)
 *
 * Tüm yetki/kimlik kararları burada verilir. App'e güvenilmez.
 *
 * Aktif fonksiyonlar:
 *  - guestSignIn:            pasaport son 6 + oda no → hash karşılaştır → custom token
 *                            (rate-limit: oda bazlı 5 hatalı deneme = 30 dk kilit)
 *  - adminAuthorizeGuest:    tam pasaport + oda no + isim → hash'le, 1 yıl erişim
 *  - adminDeactivateGuest:   misafir erişimini manuel kapat
 *
 * TODO (sonraki iş):
 *  - submitAnamnesis
 *  - askDoctor / answerQuestion
 *  - submitStayApplication
 */

import { setGlobalOptions } from "firebase-functions/v2";
import * as admin from "firebase-admin";

admin.initializeApp();
setGlobalOptions({ region: "europe-west1", maxInstances: 10 });

export { guestSignIn, adminAuthorizeGuest, adminDeactivateGuest } from "./guests";
export { adminCreateDoctor, adminDeactivateDoctor } from "./doctors";
export { startQuestion, sendMessage, markQuestionRead } from "./chat";
export { bootstrapFirstAdmin } from "./bootstrap";
export { devResetTestCredentials } from "./devTools";
