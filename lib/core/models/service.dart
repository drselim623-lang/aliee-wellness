enum ServiceCategory {
  // Sıralama tab sırasını belirler — IV & Longevity ilk, Medikal Estetik ikinci.
  iv('iv', 'IV & Longevity', 'IV & Longevity'),
  aesthetics('aesthetics', 'Medikal Estetik', 'Medical Aesthetics'),
  tests('tests', 'Testler & Görüntüleme', 'Tests & Imaging'),
  panels('panels', 'OM AGE Panelleri', 'OM AGE Panels');

  final String id;
  final String trLabel;
  final String enLabel;
  const ServiceCategory(this.id, this.trLabel, this.enLabel);

  static ServiceCategory fromId(String id) =>
      ServiceCategory.values.firstWhere((c) => c.id == id);
}

class WellnessService {
  final String id;
  final ServiceCategory category;
  final String nameTr;
  final String nameEn;
  final String? descriptionTr;
  final String? descriptionEn;
  final List<String> tags;

  /// Uzun protokol açıklaması (Popüler Longevity Protokolleri kaynaklı).
  /// Detay ekranında gösterilir. Bilgilendirme amaçlıdır.
  final String? protocolTr;
  final String? protocolEn;

  const WellnessService({
    required this.id,
    required this.category,
    required this.nameTr,
    required this.nameEn,
    this.descriptionTr,
    this.descriptionEn,
    this.tags = const [],
    this.protocolTr,
    this.protocolEn,
  });

  factory WellnessService.fromMap(String id, Map<String, dynamic> m) {
    return WellnessService(
      id: id,
      category: ServiceCategory.fromId(m['category'] as String),
      nameTr: m['nameTr'] as String,
      nameEn: m['nameEn'] as String,
      descriptionTr: m['descriptionTr'] as String?,
      descriptionEn: m['descriptionEn'] as String?,
      tags: (m['tags'] as List?)?.cast<String>() ?? const [],
      protocolTr: m['protocolTr'] as String?,
      protocolEn: m['protocolEn'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'category': category.id,
        'nameTr': nameTr,
        'nameEn': nameEn,
        if (descriptionTr != null) 'descriptionTr': descriptionTr,
        if (descriptionEn != null) 'descriptionEn': descriptionEn,
        'tags': tags,
        if (protocolTr != null) 'protocolTr': protocolTr,
        if (protocolEn != null) 'protocolEn': protocolEn,
      };
}
