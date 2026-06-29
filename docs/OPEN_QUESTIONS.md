# Açık / Netleşmemiş Konular

Geliştirmenin ilerleyebilmesi için karara bağlanması gereken konular. Her madde
karara bağlandığında bu dosyayı güncelle ve ilgili kodu/dokümanı buna göre uyarla.

## 1. Longevity / sağlık skoru
**Soru:** Anamnez sonunda misafire bir "longevity skoru" / "biyolojik yaş" gösterilecek mi?
Gösterilecekse formül / algoritma ne olacak?

**Şu anki durum:** Faz 1'de opsiyonel tutulması önerildi (brief §3.2). Faz 2 kapsamında
detaylandırılacak (brief §8).

**Karar:** —

## 2. Anamnez kapsamı
**Soru:** Anamnez ağırlıklı olarak neyi sorgulayacak? Üç yaklaşım var:
- Genel sağlık öyküsü (hastalıklar, ilaçlar, aile öyküsü)
- Yaşam tarzı (uyku, beslenme, egzersiz, stres)
- Şikayet-hedef odaklı (mevcut yakınma + ulaşmak istediği sonuç)

**Karar:** —

## 3. Dijital onam sağlayıcısı
**Soru:** Profesyonel dijital onam çözümü hangi şirketten alınacak? (brief §6)
Entegrasyon API mı, yönlendirme mi? Callback formatı ne?

**Karar:** —
**Plan:** Sağlayıcı netleşene kadar `core/api/consent_adapter.dart` arayüzü olarak
tasarlanacak (pluggable).

## 4. Otel rezervasyon API'si (Faz 2)
**Soru:** Otelin kullandığı PMS (property management system) hangisi? API spesifikasyonu?
API anahtarını otel mi sağlayacak?

**Karar:** —
**Plan:** Faz 2'de ele alınacak. Faz 1'de sadece başvuru formu var.

## 5. TC kimlik no desteği (yerli misafirler)
**Soru:** Yerli misafirler pasaport yerine TC kimlik no ile girebilmeli mi?
Faz 1'de mi, Faz 2'de mi?

**Karar:** —
**Plan:** Faz 1'de pasaport esas alınıyor (brief §7).

## 6. Bundle ID / store bilgileri
**Soru:** Bundle ID'yi `com.spektrum.aliee_wellness` olarak yapılandırdık. Onaylanıyor mu?
Uygulama adı App Store / Play Store'da "Aliee Wellness" mi olacak?

**Karar:** —

## 7. Firebase proje organizasyonu
**Soru:** MedPoint Firebase projesi ayrı kalacak. Aliee için yeni Firebase project
oluşturulacak (`aliee-wellness`). Region: `europe-west` (KVKK için EU içinde).

**Karar:** Plan onaylandı, yeni Firebase project açılması bekleniyor.
