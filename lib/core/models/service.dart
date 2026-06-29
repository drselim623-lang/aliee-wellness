enum ServiceCategory {
  tests('tests', 'Testler & Görüntüleme', 'Tests & Imaging'),
  panels('panels', 'OM AGE Panelleri', 'OM AGE Panels'),
  iv('iv', 'IV & Longevity', 'IV & Longevity'),
  aesthetics('aesthetics', 'Medikal Estetik', 'Medical Aesthetics');

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

  const WellnessService({
    required this.id,
    required this.category,
    required this.nameTr,
    required this.nameEn,
    this.descriptionTr,
    this.descriptionEn,
    this.tags = const [],
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
    );
  }

  Map<String, dynamic> toMap() => {
        'category': category.id,
        'nameTr': nameTr,
        'nameEn': nameEn,
        if (descriptionTr != null) 'descriptionTr': descriptionTr,
        if (descriptionEn != null) 'descriptionEn': descriptionEn,
        'tags': tags,
      };
}
