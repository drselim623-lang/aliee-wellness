// Anamnez veri modeli.
//
// Karar (default — açık konular #2): Hibrit yaklaşım — genel sağlık öyküsü +
// yaşam tarzı + şikayet/hedef birlikte sorulur. Doktor onaylar/değiştirir.

enum AnamnesisSection {
  generalHistory,   // Genel sağlık öyküsü: hastalıklar, ilaçlar, alerjiler, aile öyküsü
  lifestyle,        // Yaşam tarzı: uyku, beslenme, egzersiz, sigara/alkol, stres
  complaintGoal,    // Mevcut şikayet + hedef (ne için longevity programı istiyor)
}

class AnamnesisAnswers {
  // GENEL ÖYKÜ
  final List<String> chronicConditions;       // hipertansiyon, diyabet, vb.
  final List<String> currentMedications;      // ilaç listesi
  final List<String> allergies;
  final List<String> familyHistory;           // anne/baba/kardeş kalp, kanser, vb.
  final List<String> surgeries;

  // YAŞAM TARZI
  final int sleepHoursAvg;                    // ortalama uyku saati
  final String sleepQuality;                  // poor/fair/good
  final String dietType;                      // omnivore/vegetarian/vegan/keto/other
  final int exerciseDaysPerWeek;              // 0-7
  final bool smokes;
  final String alcoholFrequency;              // none/rarely/weekly/daily
  final int perceivedStress;                  // 1-10

  // ŞİKAYET / HEDEF
  final List<String> currentComplaints;       // serbest etiket: yorgunluk, eklem ağrısı...
  final List<String> healthGoals;             // enerji, kilo, anti-aging, biliş, uyku...
  final String? freeText;

  // META
  final DateTime submittedAt;

  const AnamnesisAnswers({
    this.chronicConditions = const [],
    this.currentMedications = const [],
    this.allergies = const [],
    this.familyHistory = const [],
    this.surgeries = const [],
    this.sleepHoursAvg = 7,
    this.sleepQuality = 'fair',
    this.dietType = 'omnivore',
    this.exerciseDaysPerWeek = 2,
    this.smokes = false,
    this.alcoholFrequency = 'rarely',
    this.perceivedStress = 5,
    this.currentComplaints = const [],
    this.healthGoals = const [],
    this.freeText,
    required this.submittedAt,
  });

  Map<String, dynamic> toMap() => {
        'chronicConditions': chronicConditions,
        'currentMedications': currentMedications,
        'allergies': allergies,
        'familyHistory': familyHistory,
        'surgeries': surgeries,
        'sleepHoursAvg': sleepHoursAvg,
        'sleepQuality': sleepQuality,
        'dietType': dietType,
        'exerciseDaysPerWeek': exerciseDaysPerWeek,
        'smokes': smokes,
        'alcoholFrequency': alcoholFrequency,
        'perceivedStress': perceivedStress,
        'currentComplaints': currentComplaints,
        'healthGoals': healthGoals,
        if (freeText != null) 'freeText': freeText,
        'submittedAt': submittedAt.toIso8601String(),
      };
}
