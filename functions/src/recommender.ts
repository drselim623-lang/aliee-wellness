/**
 * Kural bazlı program önerici — misafirin anamnez cevaplarına göre `services_seed`
 * kataloğundan hizmet önerileri seçer.
 *
 * NOT: `services/services_seed.dart` client tarafında da var. Backend tarafında
 * sadece SERVICE ID'lerini bilmemiz yeterli — client detayı zaten görüyor.
 *
 * Öneri felsefesi:
 *  - Şikayet/hedef → doğrudan ilgili hizmetler
 *  - Yaşam tarzı bulguları → destekleyici IV ve testler
 *  - Genel öykü bulguları → tarama testleri
 *  - Öneri tekilleştirilir; her hizmet için 'reason' listesi tutulur.
 */

export interface AnamnesisAnswers {
  chronicConditions: string[];
  currentMedications: string[];
  allergies: string[];
  familyHistory: string[];
  surgeries: string[];
  sleepHoursAvg: number;
  sleepQuality: string; // poor / fair / good
  dietType: string;
  exerciseDaysPerWeek: number;
  smokes: boolean;
  alcoholFrequency: string; // none / rarely / weekly / daily
  perceivedStress: number; // 1-10
  currentComplaints: string[];
  healthGoals: string[];
  freeText?: string;
}

export interface RecommendedService {
  serviceId: string;
  reasons: string[]; // birden fazla nedenle önerildiyse hepsi
  score: number; // sıralamak için
}

// Anahtar kelimeleri normalize et (Türkçe küçük harf + trim)
function norm(s: string): string {
  // Türkçe küçük harf normalizasyonu, i̇ karakterini basit i'ye çevir
  return s.toLowerCase().trim().split("i̇").join("i");
}

function anyMatch(needles: string[], hay: string[]): boolean {
  const nh = hay.map(norm);
  return needles.some((n) => nh.some((h) => h.includes(norm(n))));
}

export function recommendProgram(
  a: AnamnesisAnswers
): RecommendedService[] {
  const scores = new Map<string, { reasons: string[]; score: number }>();

  const add = (serviceId: string, reason: string, weight = 1) => {
    const existing = scores.get(serviceId);
    if (existing) {
      if (!existing.reasons.includes(reason)) existing.reasons.push(reason);
      existing.score += weight;
    } else {
      scores.set(serviceId, { reasons: [reason], score: weight });
    }
  };

  const complaints = a.currentComplaints ?? [];
  const goals = a.healthGoals ?? [];
  const conditions = a.chronicConditions ?? [];
  const familyHx = a.familyHistory ?? [];

  // -------------------- ŞİKAYET / HEDEF EŞLEŞTİRMELERİ --------------------

  // Uyku problemleri
  if (
    anyMatch(["uyku", "insomnia", "uyuyamıyor"], complaints) ||
    anyMatch(["uyku", "dinlenme"], goals) ||
    (a.sleepHoursAvg < 6 && a.sleepQuality === "poor")
  ) {
    add("iv_destress", "Uyku ve gevşeme desteği", 3);
    add("iv_mood_sleep", "Uyku kalitesi için özel formül", 3);
    add("test_sleep", "Uyku Testi ile altta yatan nedenlerin taranması", 2);
    add("panel_hormone_balance", "Uyku düzenini etkileyen hormon dengesi", 1);
  }

  // Yorgunluk / enerji
  if (
    anyMatch(
      ["yorgunluk", "halsiz", "enerji", "bitkin"],
      complaints
    ) ||
    anyMatch(["enerji", "canlılık"], goals)
  ) {
    add("iv_reform", "Enerji ve toparlanma için amino asit + B kompleks", 3);
    add("iv_myers", "Klasik enerji IV karışımı", 2);
    add("iv_longevity", "Uzun vadeli enerji ve hücresel destek", 2);
    add("panel_micronutrient", "Mikrobesin eksiklikleri taraması", 2);
    add("test_vo2max", "MAX VO2 ile aerobik kapasite ölçümü", 1);
  }

  // Stres / anksiyete
  if (
    a.perceivedStress >= 7 ||
    anyMatch(["stres", "kaygı", "anksiyete"], complaints) ||
    anyMatch(["stres", "sakinleşme", "denge"], goals)
  ) {
    add("iv_destress", "Yüksek stres için magnezyum + B6 + GABA", 3);
    add("iv_mood_sleep", "Ruh hali ve sakinlik desteği", 2);
    add("panel_hormone_aging_axis", "Kortizol ve yaşlanma aksı incelemesi", 2);
  }

  // Anti-aging / longevity odağı
  if (
    anyMatch(
      ["anti", "gençleş", "longevity", "yaşlanma", "cilt"],
      goals
    )
  ) {
    add("iv_longevity", "Longevity için Q10 + ALA + antioksidan karışım", 3);
    add("iv_nad", "Hücresel enerji ve DNA onarımı", 3);
    add("iv_antiaging_repair", "Anti-aging IV kompleksi", 3);
    add("test_epigenetic", "Epigenetik yaş testi", 2);
    add("test_dna", "DNA ile kişisel risk analizi", 2);
    add("panel_neuro_alzheimer", "Nörobilişsel yaşın taranması", 1);
  }

  // Cilt / güzellik
  if (
    anyMatch(["cilt", "güzellik", "parlaklık", "kolajen"], goals) ||
    anyMatch(["cilt problemi", "sivilce", "kırışıklık"], complaints)
  ) {
    add("iv_collagen", "IV Kolajen desteği", 3);
    add("iv_beauty", "Beauty cocktail", 3);
    add("iv_glutathione", "Cilt aydınlatma", 2);
    add("aesth_skin_booster", "Skin booster mezoterapi", 2);
    add("aesth_mesotherapy", "Mezoterapi", 1);
  }

  // Kilo yönetimi / metabolizma
  if (
    anyMatch(["kilo", "metabolizma", "form"], goals) ||
    anyMatch(["kilo", "şişmanlık", "obezite"], complaints)
  ) {
    add("panel_advanced_cardio", "Kardiyometabolik ileri belirteçler", 2);
    add("panel_liver_metabolic", "Karaciğer ve metabolik yük", 2);
    add("iv_power_fitness", "Egzersiz + amino asit desteği", 1);
  }

  // Sindirim / bağırsak
  if (
    anyMatch(
      ["sindirim", "şişkinlik", "bağırsak", "kabız", "ishal", "reflü"],
      complaints
    )
  ) {
    add("test_microbiota", "Bağırsak flora testi", 3);
    add("test_sibo", "SIBO testi", 3);
    add("test_food_intolerance", "Gıda intolerans testi", 2);
    add("test_candida", "Candida testi", 2);
    add("test_parasite", "Parazit analizi", 1);
  }

  // Detoks / toksik yük
  if (
    anyMatch(["detoks", "arınma", "toksin"], goals) ||
    anyMatch(["ağır metaller"], complaints)
  ) {
    add("iv_detox", "Detoks IV karışımı", 3);
    add("iv_glutathione", "Glutatyon detoks desteği", 2);
    add("panel_toxin_screening", "Toksin taraması", 2);
  }

  // İnflamasyon
  if (
    anyMatch(["ağrı", "eklem", "iltihap", "enflamasyon"], complaints) ||
    familyHx.length > 0
  ) {
    add("panel_advanced_inflammation", "Gelişmiş inflamasyon belirteçleri", 2);
    add("test_inflammation_markers", "İnflamasyon markerları", 2);
    add("iv_ozone", "Ozon terapi", 1);
  }

  // Bağışıklık
  if (
    anyMatch(["bağışık", "sık hasta", "grip"], complaints) ||
    anyMatch(["bağışık", "immünite"], goals)
  ) {
    add("iv_immune_plus", "Bağışıklık destek IV", 3);
    add("iv_vitamin_c", "IV Vitamin C", 2);
    add("panel_infection_viral", "Enfeksiyon + viral bağışıklık paneli", 2);
  }

  // -------------------- YAŞAM TARZI FAKTÖRLERİ --------------------

  if (a.smokes) {
    add("iv_glutathione", "Sigara antioksidan yükü için", 2);
    add("panel_liver_function", "Karaciğer taraması", 1);
    add("test_pft", "Solunum fonksiyon testi (PFT)", 1);
  }

  if (a.alcoholFrequency === "daily" || a.alcoholFrequency === "weekly") {
    add("panel_liver_function", "Alkol tüketimine göre karaciğer taraması", 2);
    add("iv_detox", "Karaciğer destekleyici detoks", 1);
  }

  if (a.exerciseDaysPerWeek === 0) {
    add("test_cardio_screening", "Kardiyovasküler tarama", 1);
    add("test_vo2max", "Egzersize başlamadan önce MAX VO2", 1);
  } else if (a.exerciseDaysPerWeek >= 5) {
    add("iv_power_fitness", "Performans/toparlanma amino asit desteği", 2);
    add("iv_reform", "Reform IV — sporcu enerjisi", 1);
  }

  // -------------------- GENEL SAĞLIK ÖYKÜSÜ --------------------

  if (conditions.length > 0) {
    add("panel_standard", "Kronik durum takibi için Standart Panel", 2);
    add("panel_cbc_inflammation", "Tam kan + inflamasyon paneli", 1);
  }

  if (familyHx.length > 0) {
    add("test_dna", "Ailesel risk için DNA testi", 1);
    add("panel_neuro_alzheimer", "Nörobilişsel yaş / Alzheimer riski", 1);
  }

  // Boş çıktı ise minimal bir 'başlangıç paketi' öner
  if (scores.size === 0) {
    add("panel_standard", "Genel sağlık taraması için Standart Panel", 1);
    add("panel_micronutrient", "Mikrobesin durumu", 1);
    add("iv_myers", "Genel enerji desteği", 1);
  }

  // Sonucu score'a göre sırala (yüksekten düşüğe), maksimum 12 öneri
  return Array.from(scores.entries())
    .map(([serviceId, v]) => ({
      serviceId,
      reasons: v.reasons,
      score: v.score,
    }))
    .sort((a, b) => b.score - a.score)
    .slice(0, 12);
}
