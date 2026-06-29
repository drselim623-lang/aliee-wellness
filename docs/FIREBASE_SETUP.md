# Firebase Setup — Aliee Wellness

> MedPoint Firebase projesinden **bağımsız** yeni bir Firebase project oluşturulacak.
> Mevcut Google hesabınla yeni proje açılacak; MedPoint Firestore/Auth'una dokunulmaz.

## 1. Firebase project oluştur

1. https://console.firebase.google.com → "Add project"
2. **Project name:** `Aliee Wellness`
3. **Project ID (önerilen):** `aliee-wellness` (`.firebaserc` bu ID'yi bekliyor)
4. Google Analytics: opsiyonel (KVKK için kapatmak da seçenek)
5. **Default region:** `europe-west1` (KVKK için EU içi, MedPoint ile aynı pattern)

## 2. CLI'dan bağla

```powershell
# CLI giriş (zaten varsa atla)
firebase login

# Proje seçimi (zaten .firebaserc'de aliee-wellness yazılı)
firebase use aliee-wellness

# Flutter app'leri Firebase'e bağla
dart pub global activate flutterfire_cli
flutterfire configure --project=aliee-wellness
# → Android (com.spektrum.aliee_wellness) + iOS bundle'ı işaretle
# → lib/firebase_options.dart üretilecek
```

## 3. main.dart'a initializeApp ekle

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: AlieeWellnessApp()));
}
```

## 4. Servisleri etkinleştir (Firebase Console)
- **Authentication** → email/password (doktor + admin için). Misafir için custom token kullanılacak (Cloud Function).
- **Firestore Database** → Native mode, region `europe-west1`.
- **Storage** → region `europe-west1`.
- **Cloud Functions** → Blaze plan gerekli (faturalama açılacak — Spark plan functions'ı desteklemiyor).

## 5. Security rules ve functions deploy

```powershell
firebase deploy --only firestore:rules
firebase deploy --only storage:rules
cd functions
npm install
npm run build
cd ..
firebase deploy --only functions
```

## 6. Vitrin verisi seed

```powershell
# Vitrin servislerini Firestore'a yükle
node scripts/seed_services.js   # (sonra yazılacak; data: lib/core/data/services_seed.json)
```

## Custom claims (rol atama)
Doktor ve admin hesapları manuel olarak custom claim'le işaretlenir:

```javascript
// Firebase Functions shell veya admin script:
await admin.auth().setCustomUserClaims(uid, { role: 'doctor' });
await admin.auth().setCustomUserClaims(uid, { role: 'admin' });
// Misafir custom claim 'guest' otomatik atanır (guestSignIn function tarafından).
```
