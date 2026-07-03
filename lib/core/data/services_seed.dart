import '../models/service.dart';

/// Vitrin verisi — brief §3.3 + Popüler Longevity Protokolleri (Spektrum v2).
const kServicesSeed = <WellnessService>[
  // A) TESTLER & GÖRÜNTÜLEME
  WellnessService(id: 'test_epigenetic', category: ServiceCategory.tests, nameTr: 'Epigenetik Test', nameEn: 'Epigenetic Test'),
  WellnessService(id: 'test_microbiota', category: ServiceCategory.tests, nameTr: 'Mikrobiyota (Bağırsak Flora) Testi', nameEn: 'Gut Microbiota Test'),
  WellnessService(id: 'test_sibo', category: ServiceCategory.tests, nameTr: 'SIBO Testi', nameEn: 'SIBO Test'),
  WellnessService(id: 'test_food_intolerance', category: ServiceCategory.tests, nameTr: 'Gıda İntolerans Testi', nameEn: 'Food Intolerance Test'),
  WellnessService(id: 'test_inflammation_markers', category: ServiceCategory.tests, nameTr: 'İnflamasyon Markerları', nameEn: 'Inflammation Markers'),
  WellnessService(id: 'test_parasite', category: ServiceCategory.tests, nameTr: 'Parazit Analizi', nameEn: 'Parasite Analysis'),
  WellnessService(id: 'test_candida', category: ServiceCategory.tests, nameTr: 'Candida Testi', nameEn: 'Candida Test'),
  WellnessService(id: 'test_dna', category: ServiceCategory.tests, nameTr: 'DNA Testi', nameEn: 'DNA Test'),
  WellnessService(id: 'test_ultrasound', category: ServiceCategory.tests, nameTr: 'Ultrason', nameEn: 'Ultrasound'),
  WellnessService(id: 'test_ekg', category: ServiceCategory.tests, nameTr: 'EKG', nameEn: 'ECG'),
  WellnessService(id: 'test_vo2max', category: ServiceCategory.tests, nameTr: 'MAX VO2', nameEn: 'VO2 Max'),
  WellnessService(id: 'test_thermography', category: ServiceCategory.tests, nameTr: 'Termal Görüntüleme', nameEn: 'Thermography'),
  WellnessService(id: 'test_sleep', category: ServiceCategory.tests, nameTr: 'Uyku Testi', nameEn: 'Sleep Test'),
  WellnessService(id: 'test_mri', category: ServiceCategory.tests, nameTr: 'MR', nameEn: 'MRI'),
  WellnessService(id: 'test_xray', category: ServiceCategory.tests, nameTr: 'Lokal Grafi (X-ray)', nameEn: 'X-ray'),
  WellnessService(id: 'test_pft', category: ServiceCategory.tests, nameTr: 'Pulmoner Fonksiyon Testleri (PFT)', nameEn: 'Pulmonary Function Tests (PFT)'),
  WellnessService(id: 'test_cardio_screening', category: ServiceCategory.tests, nameTr: 'Kardiyovasküler Tarama', nameEn: 'Cardiovascular Screening', descriptionTr: 'Yürüyüş / koşu testi', descriptionEn: 'Walking / running test'),

  // B) OM AGE PANELLERİ
  WellnessService(id: 'panel_standard', category: ServiceCategory.panels, nameTr: 'OM AGE Standart / Kardiyometabolik Panel', nameEn: 'OM AGE Standard / Cardiometabolic Panel'),
  WellnessService(id: 'panel_cbc_inflammation', category: ServiceCategory.panels, nameTr: 'Tam Kan ve İnflamasyon', nameEn: 'Complete Blood & Inflammation'),
  WellnessService(id: 'panel_advanced_cardio', category: ServiceCategory.panels, nameTr: 'Gelişmiş Kardiyometabolik Belirteçler', nameEn: 'Advanced Cardiometabolic Markers'),
  WellnessService(id: 'panel_infection_viral', category: ServiceCategory.panels, nameTr: 'Enfeksiyon ve Viral Bağışıklık', nameEn: 'Infection & Viral Immunity'),
  WellnessService(id: 'panel_liver_function', category: ServiceCategory.panels, nameTr: 'Karaciğer İşlevleri', nameEn: 'Liver Function'),
  WellnessService(id: 'panel_micronutrient', category: ServiceCategory.panels, nameTr: 'Mikrobesin Durumu', nameEn: 'Micronutrient Status'),
  WellnessService(id: 'panel_hormone_aging_axis', category: ServiceCategory.panels, nameTr: 'Hormon ve Yaşlanma Ekseni', nameEn: 'Hormone & Aging Axis'),
  WellnessService(id: 'panel_kidney_electrolyte', category: ServiceCategory.panels, nameTr: 'Böbrek ve Elektrolit Dengesi', nameEn: 'Kidney & Electrolyte Balance'),
  WellnessService(id: 'panel_hormone_balance', category: ServiceCategory.panels, nameTr: 'Hormon Dengesi', nameEn: 'Hormone Balance'),
  WellnessService(id: 'panel_neuro_alzheimer', category: ServiceCategory.panels, nameTr: 'Nörobilişsel Yaş ve Alzheimer Riski', nameEn: 'Neurocognitive Age & Alzheimer Risk'),
  WellnessService(id: 'panel_liver_metabolic', category: ServiceCategory.panels, nameTr: 'Karaciğer ve Metabolik Yük', nameEn: 'Liver & Metabolic Load'),
  WellnessService(id: 'panel_toxin_screening', category: ServiceCategory.panels, nameTr: 'Toksin Taraması', nameEn: 'Toxin Screening'),
  WellnessService(id: 'panel_advanced_inflammation', category: ServiceCategory.panels, nameTr: 'Gelişmiş İnflamasyon Belirteçleri', nameEn: 'Advanced Inflammation Markers'),

  // C) IV & LONGEVITY (protokoller "Popüler Longevity Protokolleri" v2 kaynaklı)
  WellnessService(
    id: 'iv_citicoline',
    category: ServiceCategory.iv,
    nameTr: 'IV Sitikolin',
    nameEn: 'IV Citicoline',
    protocolTr: '''İçerik: Sitikolin 1000 mg.

Uygulama: Terapötik endikasyonları dışında haftada 1 kez 1000 mg sitikolin, minimum 250 cc serum fizyolojik içinde 45–50 dakika yavaş infüzyon şeklinde uygulanır. En az 6 hafta kullanımı önerilir. Tolere edilebilir maksimum doz günde 2000 mg'dır.

Terapötik endikasyonlar:
• İskemik inmenin akut dönemi
• İskemik ve hemorajik inmenin iyileşme dönemleri
• Travmatik beyin hasarının akut ve iyileşme dönemlerinde esas tedavilere ek olarak

Kullanılabilecek diğer durumlar:
• Dikkat ve konsantrasyon eksikliği
• Hafıza bozukluğu
• Odaklanma eksikliği, öğrenme performansında düşüş
• İşlem yapma performansında düşüş
• İş ve okul hayatında başarısızlık
• Depresyon
• Parkinson hastalığında ek tedavi
• Alzheimer ilk evresinde
• Glokom, beyin sisi, homosistein yüksekliği

Bilgilendirme amaçlıdır. Kaynak: Popüler Longevity Protokolleri — Spektrum v2.''',
    protocolEn: '''Content: Citicoline 1000 mg.

Administration: Outside of therapeutic indications, 1000 mg citicoline is administered once a week as a slow infusion over 45–50 minutes in a minimum of 250 cc normal saline. Use for at least 6 weeks is recommended. The maximum tolerable dose is 2000 mg per day.

Therapeutic indications:
• Acute phase of ischemic stroke
• Recovery phases of ischemic and hemorrhagic stroke
• As an adjunct to primary treatments in the acute and recovery phases of traumatic brain injury

Other conditions it may be used for:
• Attention and concentration deficit
• Memory impairment
• Lack of focus, decline in learning performance
• Decline in processing performance
• Underperformance at work and school
• Depression
• Adjunct therapy in Parkinson's disease
• Early-stage Alzheimer's disease
• Glaucoma, brain fog, elevated homocysteine

For informational purposes only. Source: Popular Longevity Protocols — Spektrum v2.''',
  ),
  WellnessService(
    id: 'iv_glutathione',
    category: ServiceCategory.iv,
    nameTr: 'IV Glutatyon',
    nameEn: 'IV Glutathione',
    protocolTr: '''İçerik: Glutathione 600 mg.

Uygulama: 3–7 günlük aralıklarla 5–10 seans önerilir. Ayda 1 defa hatırlatma dozu olarak tekrar edilebilir.

Olası faydalar:
• Serbest radikal nötralizasyonu, detoksifikasyon, sisteinin taşınması ve depolanması, hücresel redoks, askorbik asit ve E vitamini rejenerasyonunda yer alır.
• Demir metabolizmasında, kan–beyin bariyerinin bütünlüğünün korunmasında rol oynar.
• T-lenfosit proliferasyonu, nötrofil fagositik aktivitesi ve antijen sunumu dahil doğal ve adaptif bağışıklık sistemlerini destekler.
• Toplum temelli yaşlı hasta çalışmalarında artan glutatyon düzeyleri; daha yüksek kişisel sağlık, daha az hastalık, düşük kolesterol, düşük vücut kitle indeksi ve düşük kan basıncı ile ilişkilendirilmiştir.
• Koroner arter hastalığı çalışmasında oral N-asetilsisteine kıyasla oksidatif strese karşı daha fazla koruma sağlamıştır.

Bilgilendirme amaçlıdır. Kaynak: Popüler Longevity Protokolleri — Spektrum v2.''',
    protocolEn: '''Content: Glutathione 600 mg.

Administration: 5–10 sessions at 3–7 day intervals are recommended. May be repeated once a month as a booster dose.

Possible benefits:
• Involved in free radical neutralization, detoxification, cysteine transport and storage, cellular redox, and the regeneration of ascorbic acid and vitamin E.
• Plays a role in iron metabolism and in preserving the integrity of the blood–brain barrier.
• Supports the innate and adaptive immune systems, including T-lymphocyte proliferation, neutrophil phagocytic activity, and antigen presentation.
• In community-based studies of elderly patients, higher glutathione levels have been associated with better overall health, less illness, lower cholesterol, lower body mass index, and lower blood pressure.
• In a coronary artery disease study, it provided greater protection against oxidative stress compared with oral N-acetylcysteine.

For informational purposes only. Source: Popular Longevity Protocols — Spektrum v2.''',
  ),
  WellnessService(
    id: 'iv_nad',
    category: ServiceCategory.iv,
    nameTr: 'IV NAD (300mg)',
    nameEn: 'IV NAD (300mg)',
    protocolTr: '''İçerik: NAD⁺ (Nikotinamid Adenin Dinükleotid) 50 mg / 300 mg (multi dose).

Uygulama: 7 gün aralıklarla 4–5 seans önerilir.

Olası faydalar:
• Hücre içi mitokondriyal anti-aging (yaşlanma karşıtı) etki
• Oksidasyon-indirgenme olaylarında koenzim görevi
• ATP-Riboz parçalarının proteinlere naklinde substrat
• Nörolojik hastalıkların tedavisine destek
• Hücre yenilenmesi, enerji artışı
• Bilişsel fonksiyonların onarımı ve gelişimi
• Odaklanma, mental düşüklük, depresyon başlangıcı ve bağımlılık tedavilerinde destek
• Koenzim Q1 olarak da görev alır; Q10'dan 10 kat daha etkili olabilir.

Bilgilendirme amaçlıdır. Kaynak: Popüler Longevity Protokolleri — Spektrum v2.''',
    protocolEn: '''Content: NAD⁺ (Nicotinamide Adenine Dinucleotide) 50 mg / 300 mg (multi dose).

Administration: 4–5 sessions at 7-day intervals are recommended.

Possible benefits:
• Intracellular mitochondrial anti-aging effect
• Acts as a coenzyme in oxidation-reduction reactions
• Substrate in the transfer of ATP-ribose units to proteins
• Support in the treatment of neurological diseases
• Cell renewal, increased energy
• Repair and improvement of cognitive functions
• Support in treating focus problems, mental fatigue, early depression, and addiction
• Also functions as Coenzyme Q1; may be 10 times more effective than Q10.

For informational purposes only. Source: Popular Longevity Protocols — Spektrum v2.''',
  ),
  WellnessService(
    id: 'iv_myers',
    category: ServiceCategory.iv,
    nameTr: 'IV Myers',
    nameEn: 'IV Myers',
    protocolTr: '''İçerik: Sodium Ascorbate 7500 mg, Magnezyum Klorid 380 mg, Nikotinamid 100 mg, Dexpanthenol 100 mg, Piridoksin 100 mg, Tiamin 100 mg, Riboflavin 10 mg, Metilkobalamin 1 mg.

Uygulama: 7–10 günlük aralıklarla 3–6 seans önerilir.

Olası faydalar:
• Vitamin ve mineral desteği ile vücuda enerji verir.
• Kronik yorgunluk, genel isteksizlik ve koordinasyon kusurlarının onarımında etkili.
• Akut ve kronik stresin vücutta yarattığı olumsuz etkileri giderir.
• Migren ve vücut ağrılarının giderilmesini destekler.
• Anksiyete, depresyon gibi ruhsal hastalıkların oluşturduğu dejenerasyonu giderir.
• Alkolizm ve bağımlılık tedavisinde NAD⁺ ile birlikte etkin rol oynar.

Bilgilendirme amaçlıdır. Kaynak: Popüler Longevity Protokolleri — Spektrum v2.''',
    protocolEn: '''Content: Sodium Ascorbate 7500 mg, Magnesium Chloride 380 mg, Nicotinamide 100 mg, Dexpanthenol 100 mg, Pyridoxine 100 mg, Thiamine 100 mg, Riboflavin 10 mg, Methylcobalamin 1 mg.

Administration: 3–6 sessions at 7–10 day intervals are recommended.

Possible benefits:
• Energizes the body with vitamin and mineral support.
• Effective in relieving chronic fatigue, general listlessness, and coordination problems.
• Counteracts the negative effects of acute and chronic stress on the body.
• Helps relieve migraines and body aches.
• Helps reverse the deterioration caused by mental health conditions such as anxiety and depression.
• Plays an active role, together with NAD⁺, in the treatment of alcoholism and addiction.

For informational purposes only. Source: Popular Longevity Protocols — Spektrum v2.''',
  ),
  WellnessService(
    id: 'iv_vitamin_c',
    category: ServiceCategory.iv,
    nameTr: 'IV C Vitamini',
    nameEn: 'IV Vitamin C',
    protocolTr: '''İçerik: Sodium Ascorbate 7.500 mg / 25.000 mg (multi dose).

Uygulama: 3–7 günlük aralıklarla 4–6 seans önerilir.

Olası faydalar:
• Damar yolundan yüksek doz uygulanan C vitamini tümör dokusunda birikip oksidan özellik gösterebilir; tümör hücrelerinin ölümüne neden olabilir. Bu etki için kandaki C vitamini seviyesinin belirli bir düzeye çıkması gerekir.
• Yüksek doz C vitamini kemoterapi ve radyoterapiyle birlikte uygulandığında hem yan etkileri azaltabilir hem de tedavi etkinliğini artırabilir.
• Yara iyileşmesi ve kolajen yapımına yardımcı.
• Bağışıklık sistemini güçlendirir.
• Kronik yorgunluğun giderilmesine katkı sağlar.

Bilgilendirme amaçlıdır. Kaynak: Popüler Longevity Protokolleri — Spektrum v2.''',
    protocolEn: '''Content: Sodium Ascorbate 7,500 mg / 25,000 mg (multi dose).

Administration: 4–6 sessions at 3–7 day intervals are recommended.

Possible benefits:
• High-dose intravenous vitamin C can accumulate in tumor tissue and act as an oxidant, potentially causing tumor cell death. For this effect, blood vitamin C levels must reach a certain threshold.
• When administered alongside chemotherapy and radiotherapy, high-dose vitamin C may both reduce side effects and enhance treatment efficacy.
• Supports wound healing and collagen production.
• Strengthens the immune system.
• Helps relieve chronic fatigue.

For informational purposes only. Source: Popular Longevity Protocols — Spektrum v2.''',
  ),
  WellnessService(id: 'iv_collagen', category: ServiceCategory.iv, nameTr: 'IV Kolajen', nameEn: 'IV Collagen'),
  WellnessService(
    id: 'iv_reform',
    category: ServiceCategory.iv,
    nameTr: 'IV Reform',
    nameEn: 'IV Reform',
    descriptionTr: 'Arjinin · Karnitin · Taurin · B Complex · C Vitamini · Magnezyum',
    descriptionEn: 'Arginine · Carnitine · Taurine · B Complex · Vitamin C · Magnesium',
  ),
  WellnessService(
    id: 'iv_longevity',
    category: ServiceCategory.iv,
    nameTr: 'IV Longevity',
    nameEn: 'IV Longevity',
    descriptionTr: 'Koenzim Q10 · Alfa Lipoik Asit · B Complex · C Vitamini · Antioksidan Karışım · Actovegin',
    descriptionEn: 'CoQ10 · Alpha Lipoic Acid · B Complex · Vitamin C · Antioxidant Mix · Actovegin',
    protocolTr: '''İçerik: Alfa Lipoik Asit 600 mg + Koenzim Q10 + B Complex + C Vitamini + antioksidan karışım + Actovegin.

Uygulama: 5–7 günlük aralıklarla 4–6 seans önerilir.

Olası faydalar:
• Güçlü bir antioksidan; C, E vitamini ve glutatyon gibi diğer antioksidanları geri dönüştürebilir.
• Antiinflamatuar özelliklere sahiptir; TNF ile uyarılan hücrelerde in vitro NF-KB aktivitesini doza bağımlı azaltır.
• Nöropatik ağrı, parestezi, uyuşukluk, duyu kusurları ve kas gücünü iyileştirir.
• Ziegler ve arkadaşlarının meta analizinde 3 hafta 600 mg/gün IV alfa lipoik asit ile tedavi diyabetik polinöropati hastalarında güvenli ve etkili bulunmuştur.
• Randomize plasebo kontrollü pilot çalışmada omega 3 + Lipoik asit kombinasyonu, hafif–orta Alzheimer hastalarında 12 ay boyunca bilişsel ve işlevsel düşüşü yavaşlatmıştır.

Bilgilendirme amaçlıdır. Kaynak: Popüler Longevity Protokolleri — Spektrum v2.''',
    protocolEn: '''Content: Alpha Lipoic Acid 600 mg + Coenzyme Q10 + B Complex + Vitamin C + antioxidant mix + Actovegin.

Administration: 4–6 sessions at 5–7 day intervals are recommended.

Possible benefits:
• A powerful antioxidant; can recycle other antioxidants such as vitamins C and E and glutathione.
• Has anti-inflammatory properties; dose-dependently reduces NF-KB activity in vitro in TNF-stimulated cells.
• Improves neuropathic pain, paresthesia, numbness, sensory deficits, and muscle strength.
• In the meta-analysis by Ziegler et al., treatment with 600 mg/day IV alpha lipoic acid for 3 weeks was found safe and effective in patients with diabetic polyneuropathy.
• In a randomized placebo-controlled pilot study, the combination of omega-3 + lipoic acid slowed cognitive and functional decline over 12 months in patients with mild-to-moderate Alzheimer's disease.

For informational purposes only. Source: Popular Longevity Protocols — Spektrum v2.''',
  ),
  WellnessService(
    id: 'iv_destress',
    category: ServiceCategory.iv,
    nameTr: 'IV Destress',
    nameEn: 'IV Destress',
    descriptionTr: 'Magnezyum · B6 · C Vitamini · L Teanin / GABA',
    descriptionEn: 'Magnesium · B6 · Vitamin C · L-Theanine / GABA',
  ),
  WellnessService(
    id: 'iv_antiaging_repair',
    category: ServiceCategory.iv,
    nameTr: 'IV Anti Aging Repair Cocktail',
    nameEn: 'IV Anti-Aging Repair Cocktail',
    protocolTr: '''İçerik: L-Lizin 300 mg · N-Asetil Sistein 300 mg · Tiamin HCl 100 mg · L-Prolin 500 mg · Magnezyum Klorid 400 mg · Piridoksin HCl 100 mg · L-Arjinin 500 mg · Selenyum 50 µg · Niasinamid 100 mg · Karnosin 200 mg · C Vitamini 1000 mg · Dexpanthenol 100 mg.

Uygulama: 7–10 gün aralıklarla 3–6 seans, kişinin ihtiyacına göre düzenlenir.

Olası faydalar:
• İçeriğindeki aminoasit, mineral ve vitaminler ile cilt ve saç görünümünün iyileşmesine yardımcı olur.
• İyi bir ruh hali, arınma ve kişinin kendisini iyi hissetmesini destekler.
• Kolajen üretimi farklı mekanizma ve yollarla desteklenir.
• Vücut detoksifikasyonu ve karaciğerin yenilenmesine yardımcı.
• Karnosin ile anti-aging mekanizmalarını etkiler.
• Vücudun ihtiyaç duyduğu vitamin ve mineralleri sağlar.

Bilgilendirme amaçlıdır. Kaynak: Popüler Longevity Protokolleri — Spektrum v2.''',
    protocolEn: '''Content: L-Lysine 300 mg · N-Acetyl Cysteine 300 mg · Thiamine HCl 100 mg · L-Proline 500 mg · Magnesium Chloride 400 mg · Pyridoxine HCl 100 mg · L-Arginine 500 mg · Selenium 50 µg · Niacinamide 100 mg · Carnosine 200 mg · Vitamin C 1000 mg · Dexpanthenol 100 mg.

Administration: 3–6 sessions at 7–10 day intervals, tailored to individual needs.

Possible benefits:
• Helps improve the appearance of skin and hair through its amino acids, minerals, and vitamins.
• Supports a good mood, cleansing, and an overall sense of well-being.
• Collagen production is supported through various mechanisms and pathways.
• Aids body detoxification and liver regeneration.
• Influences anti-aging mechanisms through carnosine.
• Provides the vitamins and minerals the body needs.

For informational purposes only. Source: Popular Longevity Protocols — Spektrum v2.''',
  ),
  WellnessService(
    id: 'iv_beauty',
    category: ServiceCategory.iv,
    nameTr: 'IV Beauty Cocktail',
    nameEn: 'IV Beauty Cocktail',
    protocolTr: '''İçerik: Metiyonin 750 mg · Taurin 1000 mg · Prolin 3000 mg · Lizin 1000 mg · Arjinin 2000 mg · Glisin 1000 mg · Biotin 5 mg.

Uygulama: 7–10 günlük aralıklarla 3–6 seans önerilir.

Olası faydalar:
• Ciltte sıkılık ve pürüzsüzlüğü destekler.
• Cildin nem kapasitesini artırır.
• Yüz mezoterapisinin etkinliğini kandaki aminoasit seviyesini yükselterek arttırır.
• Yüz mezoterapisi seanslarının öncesi veya sonrasında kullanımı tedavinin etkinliğini artırır.
• Zararlı güneş ışınlarının ve sigaranın ciltte oluşturduğu olumsuz etkileri azaltır.
• İçeriğindeki aminoasitler sayesinde kolajen oluşumunu destekler.
• Cilt elastikiyetini artırır.
• Cildin serbest radikallere karşı savunma mekanizmasını harekete geçirir.

Bilgilendirme amaçlıdır. Kaynak: Popüler Longevity Protokolleri — Spektrum v2.''',
    protocolEn: '''Content: Methionine 750 mg · Taurine 1000 mg · Proline 3000 mg · Lysine 1000 mg · Arginine 2000 mg · Glycine 1000 mg · Biotin 5 mg.

Administration: 3–6 sessions at 7–10 day intervals are recommended.

Possible benefits:
• Supports skin firmness and smoothness.
• Increases the skin's moisture capacity.
• Enhances the effectiveness of facial mesotherapy by raising blood amino acid levels.
• Use before or after facial mesotherapy sessions increases treatment effectiveness.
• Reduces the harmful effects of sun exposure and smoking on the skin.
• Supports collagen formation through its amino acid content.
• Increases skin elasticity.
• Activates the skin's defense mechanism against free radicals.

For informational purposes only. Source: Popular Longevity Protocols — Spektrum v2.''',
  ),
  WellnessService(
    id: 'iv_detox',
    category: ServiceCategory.iv,
    nameTr: 'IV Detox',
    nameEn: 'IV Detox',
    descriptionTr: 'ALA · Sitikolin · Myers',
    descriptionEn: 'ALA · Citicoline · Myers',
  ),
  WellnessService(
    id: 'iv_immune_plus',
    category: ServiceCategory.iv,
    nameTr: 'IV Immune Plus Cocktail',
    nameEn: 'IV Immune Plus Cocktail',
    protocolTr: '''İçerik: C Vitamini 5000 mg · Çinko 30 mg · Magnezyum 400 mg.

Uygulama: 3–7 gün aralıklarla 4–6 seans önerilir.

Olası faydalar:
• Enerji metabolizmasında önemli rol oynar.
• Bağışıklık sisteminin desteklenmesini sağlar.
• Kemik mineral yoğunluğunun artışı ve antioksidan kapasiteyi artırmada önemli rol oynar.
• Enzimlerin çalışmasında aktif rol alır.

Bilgilendirme amaçlıdır. Kaynak: Popüler Longevity Protokolleri — Spektrum v2.''',
    protocolEn: '''Content: Vitamin C 5000 mg · Zinc 30 mg · Magnesium 400 mg.

Administration: 4–6 sessions at 3–7 day intervals are recommended.

Possible benefits:
• Plays an important role in energy metabolism.
• Supports the immune system.
• Plays an important role in increasing bone mineral density and antioxidant capacity.
• Takes an active role in enzyme function.

For informational purposes only. Source: Popular Longevity Protocols — Spektrum v2.''',
  ),
  WellnessService(
    id: 'iv_revive',
    category: ServiceCategory.iv,
    nameTr: 'IV Revive (To Infinity Cocktail)',
    nameEn: 'IV Revive (To Infinity Cocktail)',
    descriptionTr: 'Infinity · Myers',
    descriptionEn: 'Infinity · Myers',
    protocolTr: '''İçerik (To Infinity): NAD⁺ 50 mg · Karnosin 100 mg · Sodium Ascorbate 1000 mg · Riboflavin-5-Fosfat 10 mg.

Uygulama: 7–10 gün aralıklarla 4–6 seans önerilir.

Olası faydalar:
• Hücre içi mitokondriyal yenilenme, hücre yenilenmesi, yükseltgenme–indirgenme reaksiyonlarında etkili.
• Bilişsel fonksiyonların onarımı ve gelişiminde etkili.
• Odaklanma problemleri, mental düşüklük, kronik yorgunluk, hafif ve akut depresyon ve bağımlılık tedavilerinde önemli destek.
• Karnosin, kültürlenmiş insan fibroblastlarında yaşlanmayı geciktirebilir; kas ve beyinle ilişkili dipeptit olarak tampon görevi görür.
• Metilglioksal gibi toksik glikolizasyon ajanlarının olumsuz etkilerini ortadan kaldırma, reaktif oksijen türevlerinin süpürülmesi ve oksidatif hasarın azaltılmasına yardımcı.

Bilgilendirme amaçlıdır. Kaynak: Popüler Longevity Protokolleri — Spektrum v2.''',
    protocolEn: '''Content (To Infinity): NAD⁺ 50 mg · Carnosine 100 mg · Sodium Ascorbate 1000 mg · Riboflavin-5-Phosphate 10 mg.

Administration: 4–6 sessions at 7–10 day intervals are recommended.

Possible benefits:
• Effective in intracellular mitochondrial renewal, cell regeneration, and oxidation-reduction reactions.
• Effective in the repair and improvement of cognitive functions.
• Significant support in treating focus problems, mental fatigue, chronic fatigue, mild and acute depression, and addiction.
• Carnosine may delay aging in cultured human fibroblasts; as a muscle- and brain-related dipeptide, it acts as a buffer.
• Helps eliminate the harmful effects of toxic glycation agents such as methylglyoxal, scavenge reactive oxygen species, and reduce oxidative damage.

For informational purposes only. Source: Popular Longevity Protocols — Spektrum v2.''',
  ),
  WellnessService(
    id: 'iv_mood_sleep',
    category: ServiceCategory.iv,
    nameTr: 'IV Mood & Sleep',
    nameEn: 'IV Mood & Sleep',
    protocolTr: '''İçerik: L-Triptofan 250 mg · Glisin 500 mg · Magnezyum Klorid 400 mg · Piridoksin 100 mg · Çinko 30 mg.

Uygulama: 3–7 gün aralıklarla 4–6 seans önerilir.

Olası faydalar:
• Triptofan; protein, enzim ve kas dokusu üretiminde kritik rol oynar. Serotonin (5-HT) ve melatoninin öncüsüdür. Anksiyete ve depresyonu azaltabilir; migren baş ağrılarının yoğunluğunu azalttığı çalışmalarda gösterilmiştir.
• Glisin; kardiyovasküler hastalıklar, enflamatuar hastalıklar, obezite ve diyabet metabolik bozukluklarında etkili. Uyku kalitesini ve nörolojik fonksiyonları iyileştirir.
• Çinko enerji metabolizmasında önemli rol oynar.
• Magnezyum; glikoliz, oksidatif fosforilasyon, osteogenez, DNA ve RNA sentezinde önemli. Hücre içi/dışı Na+/K+ ATPaz düzenlenmesinde bütünleyici.
• Piridoksin (B6); aminoasitler, nörotransmitter (serotonin, norepinefrin), sfingolipitler ve aminolevulinik asit sentezi için önemli koenzim; GABA sentezine katılır.

Bilgilendirme amaçlıdır. Kaynak: Popüler Longevity Protokolleri — Spektrum v2.''',
    protocolEn: '''Content: L-Tryptophan 250 mg · Glycine 500 mg · Magnesium Chloride 400 mg · Pyridoxine 100 mg · Zinc 30 mg.

Administration: 4–6 sessions at 3–7 day intervals are recommended.

Possible benefits:
• Tryptophan plays a critical role in the production of proteins, enzymes, and muscle tissue. It is the precursor of serotonin (5-HT) and melatonin. It may reduce anxiety and depression; studies have shown it reduces the intensity of migraine headaches.
• Glycine is effective in cardiovascular diseases, inflammatory diseases, obesity, and diabetic metabolic disorders. It improves sleep quality and neurological functions.
• Zinc plays an important role in energy metabolism.
• Magnesium is important in glycolysis, oxidative phosphorylation, osteogenesis, and DNA and RNA synthesis. It is integral to the regulation of intracellular/extracellular Na+/K+ ATPase.
• Pyridoxine (B6) is an important coenzyme for the synthesis of amino acids, neurotransmitters (serotonin, norepinephrine), sphingolipids, and aminolevulinic acid; it participates in GABA synthesis.

For informational purposes only. Source: Popular Longevity Protocols — Spektrum v2.''',
  ),
  WellnessService(
    id: 'iv_power_fitness',
    category: ServiceCategory.iv,
    nameTr: 'IV Power Fitness Sport Amino Asit',
    nameEn: 'IV Power Fitness Sport Amino Acid',
    protocolTr: '''İçerik: Glutamin 1000 mg · Arjinin 1000 mg · Ornitin 1000 mg · Metiyonin 500 mg · Glisin 1000 mg.

Uygulama: 7 günlük aralıklarla 4–6 seans önerilir.

Olası faydalar:
• Süper aminoasit kokteyli olarak da adlandırılır.
• Kadın ve erkeklerde seksüel bozuklukların tedavisinde destekleyici.
• Kas büyüme hızını artırır, kas ağrılarını giderir.
• Vücutta nitrik oksit seviyesini artırır.
• Daha güçlü kas hücrelerinin oluşumunu destekler.
• Kolay yorulma ve güçsüzlük tedavisinde B-Complex ile birlikte etkilidir.

Bilgilendirme amaçlıdır. Kaynak: Popüler Longevity Protokolleri — Spektrum v2.''',
    protocolEn: '''Content: Glutamine 1000 mg · Arginine 1000 mg · Ornithine 1000 mg · Methionine 500 mg · Glycine 1000 mg.

Administration: 4–6 sessions at 7-day intervals are recommended.

Possible benefits:
• Also known as the super amino acid cocktail.
• Supportive in the treatment of sexual dysfunction in women and men.
• Increases the rate of muscle growth and relieves muscle pain.
• Increases nitric oxide levels in the body.
• Supports the formation of stronger muscle cells.
• Effective together with B-Complex in treating easy fatigue and weakness.

For informational purposes only. Source: Popular Longevity Protocols — Spektrum v2.''',
  ),
  WellnessService(
    id: 'iv_resveratrol',
    category: ServiceCategory.iv,
    nameTr: 'IV Resveratrol',
    nameEn: 'IV Resveratrol',
    protocolTr: '''İçerik: Resveratrol 100 mg / 250 mg.

Uygulama: 7–10 gün aralıklarla 1–2 seans önerilir.

Olası faydalar:
• Antienflamatuar, antitümör, antiviral, antidiyabet, ateroprotektif, kardiyoprotektif, göz hastalıklarına karşı koruyucu, fitoöstrojen ve yaşam uzatıcı etkileri nedeniyle önemli fitokimyasallardan biridir.
• Doza bağımlı olarak serum trigliserit, VLDL, LDL ve kolesterol seviyelerini baskıladığı gözlenmiştir.
• Hücre döngüsünü durdurup apoptozu indükleyerek karsinogenezisin başlangıç, çoğalma ve metastaz basamaklarında etkili. In vitro kolon, prostat, meme, lenfoma ve lösemi kanser hücrelerinde büyümeyi inhibe ettiği gösterilmiştir.
• Gözün mikrosirkülasyonunda etkili olabilir; yaşa bağlı makula dejenerasyonu, diyabetik retinopati ve glokom önlemesine yardımcı olabilir.
• Diyabetik yara iyileşmesinde anjiyogenez yoluyla destek sağlayabilir; kolajen birikimi, enflamasyon baskılama, skar önleme ve endotelyal koruyucu etki gösterilmiştir.

Bilgilendirme amaçlıdır. Kaynak: Popüler Longevity Protokolleri — Spektrum v2.''',
    protocolEn: '''Content: Resveratrol 100 mg / 250 mg.

Administration: 1–2 sessions at 7–10 day intervals are recommended.

Possible benefits:
• One of the most important phytochemicals due to its anti-inflammatory, anti-tumor, antiviral, anti-diabetic, atheroprotective, cardioprotective, eye-protective, phytoestrogenic, and life-extending effects.
• Has been observed to suppress serum triglyceride, VLDL, LDL, and cholesterol levels in a dose-dependent manner.
• Effective at the initiation, proliferation, and metastasis stages of carcinogenesis by arresting the cell cycle and inducing apoptosis. Shown to inhibit growth in vitro in colon, prostate, breast, lymphoma, and leukemia cancer cells.
• May be effective in ocular microcirculation; may help prevent age-related macular degeneration, diabetic retinopathy, and glaucoma.
• May support diabetic wound healing through angiogenesis; collagen deposition, inflammation suppression, scar prevention, and endothelial protective effects have been demonstrated.

For informational purposes only. Source: Popular Longevity Protocols — Spektrum v2.''',
  ),
  WellnessService(id: 'iv_ozone', category: ServiceCategory.iv, nameTr: 'IV Ozon Terapi', nameEn: 'IV Ozone Therapy'),
  WellnessService(id: 'iv_rectal_ozone', category: ServiceCategory.iv, nameTr: 'Rektal Ozon', nameEn: 'Rectal Ozone'),
  WellnessService(id: 'iv_mesotherapy', category: ServiceCategory.iv, nameTr: 'Mezoterapi', nameEn: 'Mesotherapy'),

  // Yeni protokoller (PDF v2'den)
  WellnessService(
    id: 'iv_hair_nail',
    category: ServiceCategory.iv,
    nameTr: 'IV Hair & Nail Cocktail',
    nameEn: 'IV Hair & Nail Cocktail',
    protocolTr: '''İçerik: Dexpanthenol 100 mg · Piridoksin 100 mg · Çinko 70 mg · Biotin 5 mg.

Uygulama: 7 günlük aralıklarla 4–6 seans önerilir.

Olası faydalar:
• Saç ve tırnakları güçlendirir.
• Yağ asitlerinin sentezinde önemli; propionat oksidasyonunda etkin.
• Saç dökülmesini engelleyerek uzamasını destekler.
• Saç ve tırnak kalitesini artırır.
• Sedef ve egzama tedavilerinde etkin rol oynar.
• Saç ekim tedavilerinde uygulama sonrası saç köklerini besler; şok dökülmelerin önüne geçer.

Bilgilendirme amaçlıdır. Kaynak: Popüler Longevity Protokolleri — Spektrum v2.''',
    protocolEn: '''Content: Dexpanthenol 100 mg · Pyridoxine 100 mg · Zinc 70 mg · Biotin 5 mg.

Administration: 4–6 sessions at 7-day intervals are recommended.

Possible benefits:
• Strengthens hair and nails.
• Important in fatty acid synthesis; active in propionate oxidation.
• Prevents hair loss and supports hair growth.
• Improves hair and nail quality.
• Plays an active role in psoriasis and eczema treatments.
• Nourishes hair follicles after hair transplant procedures; prevents shock loss.

For informational purposes only. Source: Popular Longevity Protocols — Spektrum v2.''',
  ),
  WellnessService(
    id: 'iv_fat_burning_slim',
    category: ServiceCategory.iv,
    nameTr: 'IV Fat Burning Slim Boost',
    nameEn: 'IV Fat Burning Slim Boost',
    protocolTr: '''İçerik: L-Karnitin 1000 mg · Çinko 30 mg.

Uygulama: 3–7 günlük aralıklarla 4–6 seans önerilir.

Olası faydalar:
• Kilo kaybını destekler; metabolizmayı hızlandırarak yağ yakımını artırır.
• İştahı dengeler.
• L-Karnitin, uzun ve orta zincirli yağ asitlerini parçalayarak mitokondrinin içerisine girmesini sağlar; böylece yağ yakımı desteklenir.
• Kan şekeri ve kolesterol seviyelerini düzenlemeye yardımcı.
• Organların temizlenmesinde etkin rol oynar.

Bilgilendirme amaçlıdır. Kaynak: Popüler Longevity Protokolleri — Spektrum v2.''',
    protocolEn: '''Content: L-Carnitine 1000 mg · Zinc 30 mg.

Administration: 4–6 sessions at 3–7 day intervals are recommended.

Possible benefits:
• Supports weight loss; increases fat burning by accelerating metabolism.
• Balances appetite.
• L-Carnitine breaks down long- and medium-chain fatty acids and enables them to enter the mitochondria, thereby supporting fat burning.
• Helps regulate blood sugar and cholesterol levels.
• Plays an active role in cleansing the organs.

For informational purposes only. Source: Popular Longevity Protocols — Spektrum v2.''',
  ),
  WellnessService(
    id: 'iv_b_complex',
    category: ServiceCategory.iv,
    nameTr: 'IV B Complex Vitamin',
    nameEn: 'IV B Complex Vitamin',
    protocolTr: '''İçerik: Tiamin 100 mg · Riboflavin 25 mg · Nikotinamid 200 mg · Piridoksin 50 mg.

Uygulama: 7 günlük aralıklarla 4–6 seans önerilir.

Olası faydalar:
• Vücutta enzimatik reaksiyonların ve metabolik süreçlerin çoğunda koenzim.
• Kemik gelişimi ve kan oluşumuna katkı sağlar.
• Güçsüzlük, kas krampları ve uyku bozukluğu tedavilerinde etkili.
• Beyin ve sinir hücrelerinin sağlığını korur.
• Yorgunluk ve bitkinliğin azalmasına katkıda bulunur.

Bilgilendirme amaçlıdır. Kaynak: Popüler Longevity Protokolleri — Spektrum v2.''',
    protocolEn: '''Content: Thiamine 100 mg · Riboflavin 25 mg · Nicotinamide 200 mg · Pyridoxine 50 mg.

Administration: 4–6 sessions at 7-day intervals are recommended.

Possible benefits:
• Acts as a coenzyme in most enzymatic reactions and metabolic processes in the body.
• Contributes to bone development and blood formation.
• Effective in treating weakness, muscle cramps, and sleep disorders.
• Protects the health of brain and nerve cells.
• Helps reduce fatigue and exhaustion.

For informational purposes only. Source: Popular Longevity Protocols — Spektrum v2.''',
  ),
  WellnessService(
    id: 'iv_biotin',
    category: ServiceCategory.iv,
    nameTr: 'IV Biotin',
    nameEn: 'IV Biotin',
    protocolTr: '''İçerik: Biotin 10 mg.

Uygulama: 3–7 günlük aralıklarla 4–6 seans önerilir.

Olası faydalar:
• Kan hücreleri ve sinir dokusunun bakımını sağlar.
• HDL kolesterolü artırarak kalp hastalıklarına karşı koruyucu etki gösterir.
• Saç, cilt ve tırnak oluşumu için temel protein olan keratin üretiminde görev alır.
• Biotin eksikliği saç dökülmesi ve kas ağrısıyla kendini gösterir.

Bilgilendirme amaçlıdır. Kaynak: Popüler Longevity Protokolleri — Spektrum v2.''',
    protocolEn: '''Content: Biotin 10 mg.

Administration: 4–6 sessions at 3–7 day intervals are recommended.

Possible benefits:
• Maintains blood cells and nerve tissue.
• Shows a protective effect against heart disease by raising HDL cholesterol.
• Involved in the production of keratin, the essential protein for hair, skin, and nail formation.
• Biotin deficiency manifests as hair loss and muscle pain.

For informational purposes only. Source: Popular Longevity Protocols — Spektrum v2.''',
  ),
  WellnessService(
    id: 'iv_zinc',
    category: ServiceCategory.iv,
    nameTr: 'IV Çinko (Zinc)',
    nameEn: 'IV Zinc',
    protocolTr: '''İçerik: Zinc 30 mg / 150 mg (multi dose).

Uygulama: 3–7 günlük aralıklarla 4–6 seans önerilir.

Olası faydalar:
• Kanserle mücadelede destekleyici rol.
• Enerji metabolizmasında önemli.
• Bağışıklık sisteminin güçlendirilmesi; saç, tırnak ve cilt sağlığının korunmasına destek.
• Kemik mineral yoğunluğunun artışı ve antioksidan kapasiteyi artırmada önemli.
• Vücutta 300 farklı enzimin çalışmasında aktif rol oynar.

Bilgilendirme amaçlıdır. Kaynak: Popüler Longevity Protokolleri — Spektrum v2.''',
    protocolEn: '''Content: Zinc 30 mg / 150 mg (multi dose).

Administration: 4–6 sessions at 3–7 day intervals are recommended.

Possible benefits:
• Supportive role in the fight against cancer.
• Important in energy metabolism.
• Strengthens the immune system; supports the health of hair, nails, and skin.
• Important in increasing bone mineral density and antioxidant capacity.
• Plays an active role in the function of 300 different enzymes in the body.

For informational purposes only. Source: Popular Longevity Protocols — Spektrum v2.''',
  ),
  WellnessService(
    id: 'iv_selenium',
    category: ServiceCategory.iv,
    nameTr: 'IV Selenyum',
    nameEn: 'IV Selenium',
    protocolTr: '''İçerik: Selenyum 50 µg / 250 µg (multi dose).

Uygulama: 3–7 günlük aralıklarla 4–6 seans önerilir.

Olası faydalar:
• DNA fonksiyonlarının ve tiroid bezinin sağlıklı işlemesi için önemli mineral.
• Selenyum eksikliği bağışıklık sistemini zayıflatarak kronik hastalıkların gelişimine yol açabilir.
• Yaşlanma süreci, serbest radikal hasarı ve tiroid hastalıklarında kullanılır.
• Oksidatif stresle mücadele eder.

Bilgilendirme amaçlıdır. Kaynak: Popüler Longevity Protokolleri — Spektrum v2.''',
    protocolEn: '''Content: Selenium 50 µg / 250 µg (multi dose).

Administration: 4–6 sessions at 3–7 day intervals are recommended.

Possible benefits:
• An important mineral for healthy DNA function and thyroid gland activity.
• Selenium deficiency can weaken the immune system and contribute to the development of chronic diseases.
• Used in relation to the aging process, free radical damage, and thyroid disorders.
• Fights oxidative stress.

For informational purposes only. Source: Popular Longevity Protocols — Spektrum v2.''',
  ),
  WellnessService(
    id: 'iv_methyl_plus',
    category: ServiceCategory.iv,
    nameTr: 'IV Methyl Plus',
    nameEn: 'IV Methyl Plus',
    protocolTr: '''İçerik: Folik Asit 5 mg · Metilkobalamin 10 mg.

Uygulama: 5–7 günlük aralıklarla 4–6 seans önerilir.

Olası faydalar:
• Folik asit ve B12 vitaminleri eksikliğinin önlenmesi, komplikasyon tedavisi ve profilaksisinde.
• Folik asit, B12 eksikliğine bağlı pernisiyöz aneminin hematolojik belirtilerini düzeltirken nörolojik komplikasyonlarını gizleyebilir; bu nedenle yüksek doz metilkobalamin ile kombine edilmiştir.
• Yeterli folik asit alımı gebelikten önce başlar ve gebelik boyunca sürerse konjenital nöral tüp defekti riskini önemli ölçüde azaltabilir.
• Folik asidin B12'yi kofaktör kullanarak homosisteinden metiyonin oluşumunda önemli rolü vardır.
• Yüksek homosistein düzeylerini normalleştirebilir.
• Metilkobalamin, kan-beyin bariyerini biyotransformasyon olmadan geçebilen B12'nin aktif formudur.
• B12; hematopoez, nöral metabolizma, büyüme, hücre çoğalması, DNA/RNA üretimi, nükleoprotein, miyelin sentezi, karbonhidrat, yağ ve protein metabolizması için gereklidir.

Bilgilendirme amaçlıdır. Kaynak: Popüler Longevity Protokolleri — Spektrum v2.''',
    protocolEn: '''Content: Folic Acid 5 mg · Methylcobalamin 10 mg.

Administration: 4–6 sessions at 5–7 day intervals are recommended.

Possible benefits:
• For the prevention of folic acid and vitamin B12 deficiencies, and for the treatment and prophylaxis of their complications.
• Folic acid can correct the hematological signs of pernicious anemia caused by B12 deficiency while masking its neurological complications; for this reason it is combined with high-dose methylcobalamin.
• Adequate folic acid intake, starting before pregnancy and continuing throughout, can significantly reduce the risk of congenital neural tube defects.
• Folic acid plays an important role in the formation of methionine from homocysteine, using B12 as a cofactor.
• May normalize elevated homocysteine levels.
• Methylcobalamin is the active form of B12 that can cross the blood-brain barrier without biotransformation.
• B12 is essential for hematopoiesis, neural metabolism, growth, cell proliferation, DNA/RNA production, nucleoprotein and myelin synthesis, and carbohydrate, fat, and protein metabolism.

For informational purposes only. Source: Popular Longevity Protocols — Spektrum v2.''',
  ),
  WellnessService(
    id: 'iv_curcumin',
    category: ServiceCategory.iv,
    nameTr: 'IV Curcumin',
    nameEn: 'IV Curcumin',
    protocolTr: '''İçerik: Curcumin 50 mg / 300 mg.

Uygulama: İlk gün 1–10 mg/kg IV test dozu. Haftada iki–üç kez tolere edilirse sonraki dozlar 40 mg/kg'a çıkabilir. İlerlemiş kanser için çok daha yüksek dozlar gerekir. Primer tedavi olarak tümör yanıtı varsa 5–10 mg/kg test edilir; sonrasında artırılabilir (üst dozlar 30–40 mg/kg).

Olası faydalar:
• Çeşitli etki mekanizmaları; enzim, reseptör ve transkripsiyon faktörü aktivitesini değiştirerek anti-enflamatuar, antioksidan, anti-diyabetik ve anti-kanser özellik gösterebilir.
• T2DM (tip 2 diyabet) hastalarında TNF-α ve IL-6'da anlamlı azalma çalışmalarda gösterilmiştir.
• Proteinüri, sistolik kan basıncı ve hematürinin azaldığı bildirilmiştir.
• Tetrahidrocurcumin; HMG CoA redüktaz aktivitesini azaltır; serum ve karaciğer kolesterolü, trigliserit, serbest yağ asitleri, VLDL ve LDL'yi düşürür.
• Histon asetiltransferazı inhibe edebilir; Alzheimer gibi nörodejeneratif hastalıklarda amiloid oluşturan peptit agregasyonunu sınırlayabilir.
• Anti-oksidatif kapasite gösterir.

Bilgilendirme amaçlıdır. Kaynak: Popüler Longevity Protokolleri — Spektrum v2.''',
    protocolEn: '''Content: Curcumin 50 mg / 300 mg.

Administration: On the first day, an IV test dose of 1–10 mg/kg. If tolerated two to three times a week, subsequent doses may increase to 40 mg/kg. Much higher doses are required for advanced cancer. As a primary treatment, if there is a tumor response, 5–10 mg/kg is tested and may then be increased (upper doses 30–40 mg/kg).

Possible benefits:
• Various mechanisms of action; may exhibit anti-inflammatory, antioxidant, anti-diabetic, and anti-cancer properties by altering the activity of enzymes, receptors, and transcription factors.
• Significant reductions in TNF-α and IL-6 have been demonstrated in studies of T2DM (type 2 diabetes) patients.
• Reductions in proteinuria, systolic blood pressure, and hematuria have been reported.
• Tetrahydrocurcumin reduces HMG CoA reductase activity; lowers serum and liver cholesterol, triglycerides, free fatty acids, VLDL, and LDL.
• May inhibit histone acetyltransferase; may limit the aggregation of amyloid-forming peptides in neurodegenerative diseases such as Alzheimer's.
• Exhibits anti-oxidative capacity.

For informational purposes only. Source: Popular Longevity Protocols — Spektrum v2.''',
  ),
  WellnessService(
    id: 'iv_methylcobalamin',
    category: ServiceCategory.iv,
    nameTr: 'IV Metilkobalamin (B12)',
    nameEn: 'IV Methylcobalamin (B12)',
    protocolTr: '''İçerik: Metilkobalamin 5 mg.

Uygulama: 7 günlük aralıklarla 4–6 seans önerilir.

Olası faydalar:
• Biyotransformasyona uğramadan kan-beyin bariyerini geçebilen aktif B12 formu.
• B12 emilim yetersizliği ve eksikliğinde ortaya çıkan kansızlık durumlarının tedavisinde ve profilaksisinde.
• Hematopoez, nöral metabolizma, DNA ve RNA üretimi, karbonhidrat/yağ/protein metabolizması için gereklidir.
• Demir fonksiyonlarını iyileştirir, folik asit sentezine yardımcı.
• Büyüme, hücre çoğalması, nükleoprotein ve miyelin sentezi için gerekli.
• Hızlı bölünen hücreler (epitel hücreleri, kemik iliği, miyeloid hücreler) için gereklidir.
• Büyüme faktörünü düzenler, makrofajların ve pıhtılaşma sisteminin normal işlevine yardımcı olabilir.

Bilgilendirme amaçlıdır. Kaynak: Popüler Longevity Protokolleri — Spektrum v2.''',
    protocolEn: '''Content: Methylcobalamin 5 mg.

Administration: 4–6 sessions at 7-day intervals are recommended.

Possible benefits:
• The active form of B12 that can cross the blood-brain barrier without biotransformation.
• For the treatment and prophylaxis of anemia caused by B12 malabsorption and deficiency.
• Essential for hematopoiesis, neural metabolism, DNA and RNA production, and carbohydrate/fat/protein metabolism.
• Improves iron function and aids folic acid synthesis.
• Necessary for growth, cell proliferation, and nucleoprotein and myelin synthesis.
• Essential for rapidly dividing cells (epithelial cells, bone marrow, myeloid cells).
• Regulates growth factor and may support the normal function of macrophages and the coagulation system.

For informational purposes only. Source: Popular Longevity Protocols — Spektrum v2.''',
  ),

  // D) MEDİKAL ESTETİK — Botoks
  WellnessService(id: 'aesth_botox_3zone', category: ServiceCategory.aesthetics, nameTr: '3 Bölge Botoks', nameEn: '3-Zone Botox', descriptionTr: 'Kaz ayağı · Glabella · Alın', descriptionEn: 'Crow\'s feet · Glabella · Forehead', tags: ['botoks']),
  WellnessService(id: 'aesth_botox_masseter', category: ServiceCategory.aesthetics, nameTr: 'Masseter Botoksu', nameEn: 'Masseter Botox', tags: ['botoks']),
  WellnessService(id: 'aesth_botox_migraine', category: ServiceCategory.aesthetics, nameTr: 'Migren Botoksu', nameEn: 'Migraine Botox', tags: ['botoks']),
  WellnessService(id: 'aesth_botox_hyperhidrosis', category: ServiceCategory.aesthetics, nameTr: 'Terleme Botoksu', nameEn: 'Hyperhidrosis Botox', tags: ['botoks']),

  // D) MEDİKAL ESTETİK — Dolgu
  WellnessService(id: 'aesth_filler_lip', category: ServiceCategory.aesthetics, nameTr: 'Dudak Dolgusu', nameEn: 'Lip Filler', tags: ['dolgu']),
  WellnessService(id: 'aesth_filler_malar', category: ServiceCategory.aesthetics, nameTr: 'Malar Dolgu', nameEn: 'Malar Filler', tags: ['dolgu']),
  WellnessService(id: 'aesth_filler_zygoma', category: ServiceCategory.aesthetics, nameTr: 'Zygoma Dolgusu', nameEn: 'Zygoma Filler', tags: ['dolgu']),
  WellnessService(id: 'aesth_filler_nasolabial', category: ServiceCategory.aesthetics, nameTr: 'Nasolabial Dolgu', nameEn: 'Nasolabial Filler', tags: ['dolgu']),
  WellnessService(id: 'aesth_filler_chin', category: ServiceCategory.aesthetics, nameTr: 'Çene Dolgusu', nameEn: 'Chin Filler', tags: ['dolgu']),
  WellnessService(id: 'aesth_filler_temporal', category: ServiceCategory.aesthetics, nameTr: 'Temporal Dolgu', nameEn: 'Temporal Filler', tags: ['dolgu']),
  WellnessService(id: 'aesth_filler_jawline', category: ServiceCategory.aesthetics, nameTr: 'Jawline Dolgusu', nameEn: 'Jawline Filler', tags: ['dolgu']),
  WellnessService(id: 'aesth_filler_browlift', category: ServiceCategory.aesthetics, nameTr: 'Kaş Kaldırma Dolgusu', nameEn: 'Brow Lift Filler', tags: ['dolgu']),

  // D) MEDİKAL ESTETİK — Diğer
  WellnessService(id: 'aesth_skin_booster', category: ServiceCategory.aesthetics, nameTr: 'Skin Booster', nameEn: 'Skin Booster'),
  WellnessService(id: 'aesth_mesotherapy', category: ServiceCategory.aesthetics, nameTr: 'Mezoterapi', nameEn: 'Mesotherapy'),
  WellnessService(id: 'aesth_liquid_facelift', category: ServiceCategory.aesthetics, nameTr: 'Sıvı Yüz Germe', nameEn: 'Liquid Facelift'),
  WellnessService(id: 'aesth_collagen_stimulator', category: ServiceCategory.aesthetics, nameTr: 'Kollajen Stimülatörü', nameEn: 'Collagen Stimulator'),
  WellnessService(id: 'aesth_exosome', category: ServiceCategory.aesthetics, nameTr: 'Exosome Tedavileri', nameEn: 'Exosome Treatments'),
  WellnessService(id: 'aesth_hair_treatment', category: ServiceCategory.aesthetics, nameTr: 'Saç Tedavileri', nameEn: 'Hair Treatments'),
];
