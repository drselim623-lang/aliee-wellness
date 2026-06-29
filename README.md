# Aliee Wellness (Spektrum Longevity)

Spektrum Evde Sağlık'ın Aliee otelindeki longevity hizmeti için mobil uygulama. Otel
misafirlerine longevity/medikal/estetik hizmetleri tanıtır, anamnez alıp kişiye özel
program önerir, kayıtlı doktorlara soru sorma imkânı verir ve gelecek konaklama için
başvuru toplar.

> **Önemli:** Bu uygulamada hizmet **satın alma** veya **randevu onaylama YOKTUR**.
> Gerçek işlemler otelin wellness katında yüz yüze yapılır.

## Roller
1. **Misafir / Hasta** — pasaport son 6 hane + oda numarası ile giriş (Apple/Google YOK).
2. **Doktor** — kendi hesabıyla giriş, gelen soruları yanıtlar.
3. **Admin (Spektrum ekibi)** — check-in'de misafiri yetkilendirir.

## Faz 1 (bu sürümde olacaklar)
- 3 rollü giriş sistemi, ikon bazlı ayrım (admin diskret).
- Sunucu tarafı yetki, pasaport **hash**, oda bazlı **deneme limiti**, **1 yıl** erişim.
- Sağlığını Keşfet: anamnez + lab yükleme + kişiye özel program önerisi.
- Hizmet vitrini (4 kategori, sadece tanıtım — randevu/satın alma yok).
- Doktoruma Sor (yazılı mesaj + dosya).
- Konaklama / Wellness Planlama — sadece başvuru formu.
- Dijital onam — pluggable arayüz, sağlayıcı sonra takılacak.

## Faz 2 (sonra)
- Otel rezervasyon sistemi entegrasyonu.
- Wellness rezervasyon entegrasyonu.
- Doktor görüşmesinde görüntülü/sesli görüşme.
- Longevity / biyolojik yaş skoru hesaplama.

## Klasör yapısı

```
lib/
  main.dart
  core/
    api/         # Cloud Functions / Firestore servisleri
    l10n/        # ARB dosyaları (TR + EN) ve generated localizations
    models/      # Veri modelleri
    routing/     # go_router config
    theme/       # Cream / sage paleti
    widgets/     # Paylaşılan widget'lar
  features/
    auth/        # Rol seçimi + 3 rol login
    guest/       # Misafir/hasta ekranları
    doctor/      # Doktor ekranları
    admin/       # Spektrum ekibi yetkilendirme
docs/
  OPEN_QUESTIONS.md   # Karar bekleyen konular
```

## Tech stack
- **Flutter** (3.32+) — iOS + Android tek kod tabanı.
- **Firebase** — Auth, Firestore, Storage, Cloud Functions (region: europe-west).
- **Riverpod** — state management.
- **go_router** — routing.

## Kurulum

```bash
flutter pub get
flutter gen-l10n
flutter run
```

Firebase yapılandırması için (sonradan yapılacak):

```bash
dart pub global activate flutterfire_cli
flutterfire configure --project aliee-wellness
```

## Güvenlik kuralları (zorunlu — brief §2.4)
- Tüm yetki kararları **sunucu tarafında**. App "yetkili mi" kararı vermez.
- Pasaport veritabanında **hash**'lenerek saklanır (KVKK).
- Oda bazlı **deneme limiti** (brute-force koruması).
- API anahtarları (onam, otel rezervasyon vb.) **asla app içinde** saklanmaz, backend'de durur.
- Sağlık verisi (anamnez, lab, mesajlaşma) şifrelenir, RBAC ile erişim sınırlanır.

## Açık konular
[docs/OPEN_QUESTIONS.md](docs/OPEN_QUESTIONS.md) — kod yazmaya başlamadan netleşmesi gereken kararlar.
