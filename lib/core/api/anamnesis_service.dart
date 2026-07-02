import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/anamnesis.dart';

/// Sunucudan dönen bir öneri (service id + neden + skor).
class RecommendedService {
  final String serviceId;
  final List<String> reasons;
  final int score;

  const RecommendedService({
    required this.serviceId,
    required this.reasons,
    required this.score,
  });

  factory RecommendedService.fromMap(Map<String, dynamic> m) {
    return RecommendedService(
      serviceId: (m['serviceId'] as String?) ?? '',
      reasons: (m['reasons'] as List?)?.cast<String>() ?? const [],
      score: (m['score'] as num?)?.toInt() ?? 0,
    );
  }
}

class AnamnesisResult {
  final int recommendationCount;
  final List<RecommendedService> recommendations;

  const AnamnesisResult({
    required this.recommendationCount,
    required this.recommendations,
  });
}

class LabRecord {
  final String id;
  final String fileName;
  final String downloadUrl;
  final String storagePath;
  final String? contentType;
  final int sizeBytes;
  final DateTime? uploadedAt;

  LabRecord({
    required this.id,
    required this.fileName,
    required this.downloadUrl,
    required this.storagePath,
    required this.contentType,
    required this.sizeBytes,
    required this.uploadedAt,
  });

  factory LabRecord.fromDoc(String id, Map<String, dynamic> d) {
    return LabRecord(
      id: id,
      fileName: (d['fileName'] as String?) ?? '',
      downloadUrl: (d['downloadUrl'] as String?) ?? '',
      storagePath: (d['storagePath'] as String?) ?? '',
      contentType: d['contentType'] as String?,
      sizeBytes: (d['sizeBytes'] as num?)?.toInt() ?? 0,
      uploadedAt: (d['uploadedAt'] as Timestamp?)?.toDate(),
    );
  }

  bool get isImage => (contentType ?? '').startsWith('image/');
}

class AnamnesisService {
  AnamnesisService._();
  static final AnamnesisService instance = AnamnesisService._();

  final FirebaseFunctions _functions =
      FirebaseFunctions.instanceFor(region: 'europe-west1');
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String get _uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  /// Anamnez cevaplarını backend'e gönder, dönüşte program önerisini al.
  Future<AnamnesisResult> submit(AnamnesisAnswers a) async {
    final result = await _functions.httpsCallable('submitAnamnesis').call({
      'chronicConditions': a.chronicConditions,
      'currentMedications': a.currentMedications,
      'allergies': a.allergies,
      'familyHistory': a.familyHistory,
      'surgeries': a.surgeries,
      'sleepHoursAvg': a.sleepHoursAvg,
      'sleepQuality': a.sleepQuality,
      'dietType': a.dietType,
      'exerciseDaysPerWeek': a.exerciseDaysPerWeek,
      'smokes': a.smokes,
      'alcoholFrequency': a.alcoholFrequency,
      'perceivedStress': a.perceivedStress,
      'currentComplaints': a.currentComplaints,
      'healthGoals': a.healthGoals,
      if (a.freeText != null) 'freeText': a.freeText,
    });
    final data = Map<String, dynamic>.from(result.data as Map);
    final recs = (data['recommendations'] as List?) ?? const [];
    return AnamnesisResult(
      recommendationCount: (data['recommendationCount'] as num?)?.toInt() ?? 0,
      recommendations: recs
          .map((e) => RecommendedService.fromMap(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }

  /// Misafirin kendi mevcut önerisini akıt (varsa).
  Stream<AnamnesisResult?> myRecommendationStream() {
    if (_uid.isEmpty) return const Stream.empty();
    return _db
        .collection('guests')
        .doc(_uid)
        .collection('programRecommendation')
        .doc('latest')
        .snapshots()
        .map((snap) {
      if (!snap.exists) return null;
      final data = snap.data()!;
      final recs = (data['recommendations'] as List?) ?? const [];
      return AnamnesisResult(
        recommendationCount: recs.length,
        recommendations: recs
            .map((e) =>
                RecommendedService.fromMap(Map<String, dynamic>.from(e as Map)))
            .toList(),
      );
    });
  }

  /// Misafirin en son anamnez cevaplarını akıt (varsa).
  Stream<Map<String, dynamic>?> myAnamnesisStream() {
    if (_uid.isEmpty) return const Stream.empty();
    return _db
        .collection('guests')
        .doc(_uid)
        .collection('anamnesis')
        .doc('latest')
        .snapshots()
        .map((s) => s.data());
  }

  // ---- Lab dosyaları --------------------------------------------------------

  Future<LabRecord> uploadLab({
    required Uint8List bytes,
    required String fileName,
    required String contentType,
    String? notes,
  }) async {
    final uid = _uid;
    if (uid.isEmpty) throw StateError('not-signed-in');
    final ts = DateTime.now().millisecondsSinceEpoch;
    final path = 'guests/$uid/labs/${ts}_$fileName';
    final ref = _storage.ref(path);
    await ref.putData(bytes, SettableMetadata(contentType: contentType));
    final url = await ref.getDownloadURL();
    // Sunucu tarafına metadata yaz
    final result = await _functions.httpsCallable('saveLabMetadata').call({
      'storagePath': path,
      'downloadUrl': url,
      'fileName': fileName,
      'contentType': contentType,
      'sizeBytes': bytes.length,
      if (notes != null && notes.isNotEmpty) 'notes': notes,
    });
    final labId = (result.data as Map)['labId'] as String;
    return LabRecord(
      id: labId,
      fileName: fileName,
      downloadUrl: url,
      storagePath: path,
      contentType: contentType,
      sizeBytes: bytes.length,
      uploadedAt: DateTime.now(),
    );
  }

  Stream<List<LabRecord>> myLabsStream() {
    if (_uid.isEmpty) return const Stream.empty();
    return _db
        .collection('guests')
        .doc(_uid)
        .collection('labs')
        .orderBy('uploadedAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => LabRecord.fromDoc(d.id, d.data())).toList());
  }
}
