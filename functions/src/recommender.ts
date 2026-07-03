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
  // Anahtar kelimeler TR + EN birlikte tutulur; reason metinleri EN'dir
  // (uygulamanın varsayılan dili İngilizce, form ipuçları da İngilizce).

  // Uyku problemleri
  if (
    anyMatch(["uyku", "insomnia", "uyuyamıyor", "sleep"], complaints) ||
    anyMatch(["uyku", "dinlenme", "sleep", "rest"], goals) ||
    (a.sleepHoursAvg < 6 && a.sleepQuality === "poor")
  ) {
    add("iv_destress", "Sleep and relaxation support", 3);
    add("iv_mood_sleep", "Special formula for sleep quality", 3);
    add("test_sleep", "Sleep Test to screen underlying causes", 2);
    add("panel_hormone_balance", "Hormone balance affecting sleep patterns", 1);
  }

  // Yorgunluk / enerji
  if (
    anyMatch(
      ["yorgunluk", "halsiz", "enerji", "bitkin", "fatigue", "tired", "energy", "exhaust"],
      complaints
    ) ||
    anyMatch(["enerji", "canlılık", "energy", "vitality"], goals)
  ) {
    add("iv_reform", "Amino acids + B complex for energy and recovery", 3);
    add("iv_myers", "Classic energy IV blend", 2);
    add("iv_longevity", "Long-term energy and cellular support", 2);
    add("panel_micronutrient", "Screening for micronutrient deficiencies", 2);
    add("test_vo2max", "Aerobic capacity measurement with VO2 Max", 1);
  }

  // Stres / anksiyete
  if (
    a.perceivedStress >= 7 ||
    anyMatch(["stres", "kaygı", "anksiyete", "stress", "anxiety"], complaints) ||
    anyMatch(["stres", "sakinleşme", "denge", "stress", "calm", "balance"], goals)
  ) {
    add("iv_destress", "Magnesium + B6 + GABA for high stress", 3);
    add("iv_mood_sleep", "Mood and calmness support", 2);
    add("panel_hormone_aging_axis", "Cortisol and aging-axis review", 2);
  }

  // Anti-aging / longevity odağı
  if (
    anyMatch(
      ["anti", "gençleş", "longevity", "yaşlanma", "cilt", "aging", "skin", "rejuvenat"],
      goals
    )
  ) {
    add("iv_longevity", "Q10 + ALA + antioxidant blend for longevity", 3);
    add("iv_nad", "Cellular energy and DNA repair", 3);
    add("iv_antiaging_repair", "Anti-aging IV complex", 3);
    add("test_epigenetic", "Epigenetic age test", 2);
    add("test_dna", "Personal risk analysis with DNA", 2);
    add("panel_neuro_alzheimer", "Neurocognitive age screening", 1);
  }

  // Cilt / güzellik
  if (
    anyMatch(["cilt", "güzellik", "parlaklık", "kolajen", "skin", "beauty", "glow", "collagen"], goals) ||
    anyMatch(["cilt problemi", "sivilce", "kırışıklık", "skin", "acne", "wrinkle"], complaints)
  ) {
    add("iv_collagen", "IV Collagen support", 3);
    add("iv_beauty", "Beauty cocktail", 3);
    add("iv_glutathione", "Skin brightening", 2);
    add("aesth_skin_booster", "Skin booster mesotherapy", 2);
    add("aesth_mesotherapy", "Mesotherapy", 1);
  }

  // Kilo yönetimi / metabolizma
  if (
    anyMatch(["kilo", "metabolizma", "form", "weight", "metabolism", "fit"], goals) ||
    anyMatch(["kilo", "şişmanlık", "obezite", "weight", "obesity"], complaints)
  ) {
    add("panel_advanced_cardio", "Advanced cardiometabolic markers", 2);
    add("panel_liver_metabolic", "Liver and metabolic load", 2);
    add("iv_power_fitness", "Exercise + amino acid support", 1);
  }

  // Sindirim / bağırsak
  if (
    anyMatch(
      ["sindirim", "şişkinlik", "bağırsak", "kabız", "ishal", "reflü",
        "digest", "bloat", "gut", "constipat", "diarrhea", "reflux", "stomach"],
      complaints
    )
  ) {
    add("test_microbiota", "Gut microbiota test", 3);
    add("test_sibo", "SIBO test", 3);
    add("test_food_intolerance", "Food intolerance test", 2);
    add("test_candida", "Candida test", 2);
    add("test_parasite", "Parasite analysis", 1);
  }

  // Detoks / toksik yük
  if (
    anyMatch(["detoks", "arınma", "toksin", "detox", "cleanse", "toxin"], goals) ||
    anyMatch(["ağır metaller", "heavy metal"], complaints)
  ) {
    add("iv_detox", "Detox IV blend", 3);
    add("iv_glutathione", "Glutathione detox support", 2);
    add("panel_toxin_screening", "Toxin screening", 2);
  }

  // İnflamasyon
  if (
    anyMatch(["ağrı", "eklem", "iltihap", "enflamasyon", "pain", "joint", "inflammation"], complaints) ||
    familyHx.length > 0
  ) {
    add("panel_advanced_inflammation", "Advanced inflammation markers", 2);
    add("test_inflammation_markers", "Inflammation markers", 2);
    add("iv_ozone", "Ozone therapy", 1);
  }

  // Bağışıklık
  if (
    anyMatch(["bağışık", "sık hasta", "grip", "immun", "immune", "flu", "sick often"], complaints) ||
    anyMatch(["bağışık", "immünite", "immun", "immune"], goals)
  ) {
    add("iv_immune_plus", "Immune support IV", 3);
    add("iv_vitamin_c", "IV Vitamin C", 2);
    add("panel_infection_viral", "Infection + viral immunity panel", 2);
  }

  // -------------------- YAŞAM TARZI FAKTÖRLERİ --------------------

  if (a.smokes) {
    add("iv_glutathione", "For the antioxidant load of smoking", 2);
    add("panel_liver_function", "Liver screening", 1);
    add("test_pft", "Pulmonary function test (PFT)", 1);
  }

  if (a.alcoholFrequency === "daily" || a.alcoholFrequency === "weekly") {
    add("panel_liver_function", "Liver screening based on alcohol intake", 2);
    add("iv_detox", "Liver-supporting detox", 1);
  }

  if (a.exerciseDaysPerWeek === 0) {
    add("test_cardio_screening", "Cardiovascular screening", 1);
    add("test_vo2max", "VO2 Max before starting exercise", 1);
  } else if (a.exerciseDaysPerWeek >= 5) {
    add("iv_power_fitness", "Amino acid support for performance/recovery", 2);
    add("iv_reform", "Reform IV — athlete energy", 1);
  }

  // -------------------- GENEL SAĞLIK ÖYKÜSÜ --------------------

  if (conditions.length > 0) {
    add("panel_standard", "Standard Panel for chronic condition follow-up", 2);
    add("panel_cbc_inflammation", "Complete blood + inflammation panel", 1);
  }

  if (familyHx.length > 0) {
    add("test_dna", "DNA test for familial risk", 1);
    add("panel_neuro_alzheimer", "Neurocognitive age / Alzheimer risk", 1);
  }

  // Boş çıktı ise minimal bir 'başlangıç paketi' öner
  if (scores.size === 0) {
    add("panel_standard", "Standard Panel for general health screening", 1);
    add("panel_micronutrient", "Micronutrient status", 1);
    add("iv_myers", "General energy support", 1);
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
