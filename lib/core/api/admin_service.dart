import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

/// Aliee Wellness — admin işlemleri.
/// Firestore + Cloud Functions (europe-west1) sarmalar.
class AdminService {
  AdminService._();
  static final AdminService instance = AdminService._();

  final FirebaseFunctions _functions =
      FirebaseFunctions.instanceFor(region: 'europe-west1');
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Yeni misafir yetkilendir. Sonuç: `{guestId, updated}`.
  Future<Map<String, dynamic>> authorizeGuest({
    required String fullPassport,
    required String roomNumber,
    required String firstName,
    required String lastName,
    String? nationality,
    String? email,
    String? phone,
  }) async {
    try {
      final result =
          await _functions.httpsCallable('adminAuthorizeGuest').call({
        'fullPassport': fullPassport,
        'roomNumber': roomNumber,
        'firstName': firstName,
        'lastName': lastName,
        if (nationality != null && nationality.isNotEmpty)
          'nationality': nationality,
        if (email != null && email.isNotEmpty) 'email': email,
        if (phone != null && phone.isNotEmpty) 'phone': phone,
      });
      return Map<String, dynamic>.from(result.data as Map);
    } on FirebaseFunctionsException catch (e) {
      throw AdminException(code: e.code, message: e.message ?? 'Hata');
    }
  }

  Future<void> deactivateGuest(String guestId) async {
    try {
      await _functions.httpsCallable('adminDeactivateGuest').call({
        'guestId': guestId,
      });
    } on FirebaseFunctionsException catch (e) {
      throw AdminException(code: e.code, message: e.message ?? 'Hata');
    }
  }

  /// Aktif misafirleri en son yetkilendirilenden başlayarak akıt.
  Stream<List<GuestSummary>> activeGuestsStream() {
    return _db
        .collection('guests')
        .where('active', isEqualTo: true)
        .orderBy('authorizedAt', descending: true)
        .limit(100)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => GuestSummary.fromDoc(d.id, d.data())).toList());
  }

  Future<Map<String, dynamic>> createDoctor({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String specialty,
    String title = 'Dr.',
  }) async {
    try {
      final result = await _functions.httpsCallable('adminCreateDoctor').call({
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'specialty': specialty,
        'title': title,
      });
      return Map<String, dynamic>.from(result.data as Map);
    } on FirebaseFunctionsException catch (e) {
      throw AdminException(code: e.code, message: e.message ?? 'Hata');
    }
  }

  Stream<List<DoctorSummary>> doctorsStream() {
    return _db
        .collection('doctors')
        .orderBy('createdAt', descending: true)
        .limit(100)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => DoctorSummary.fromDoc(d.id, d.data())).toList());
  }

  Future<void> deactivateDoctor(String doctorId) async {
    try {
      await _functions.httpsCallable('adminDeactivateDoctor').call({
        'doctorId': doctorId,
      });
    } on FirebaseFunctionsException catch (e) {
      throw AdminException(code: e.code, message: e.message ?? 'Hata');
    }
  }
}

class DoctorSummary {
  final String doctorId;
  final String title;
  final String firstName;
  final String lastName;
  final String specialty;
  final String email;
  final bool active;

  DoctorSummary({
    required this.doctorId,
    required this.title,
    required this.firstName,
    required this.lastName,
    required this.specialty,
    required this.email,
    required this.active,
  });

  String get displayName => '$title $firstName $lastName'.trim();

  factory DoctorSummary.fromDoc(String id, Map<String, dynamic> data) {
    return DoctorSummary(
      doctorId: id,
      title: (data['title'] as String?) ?? 'Dr.',
      firstName: (data['firstName'] as String?) ?? '',
      lastName: (data['lastName'] as String?) ?? '',
      specialty: (data['specialty'] as String?) ?? '',
      email: (data['email'] as String?) ?? '',
      active: (data['active'] as bool?) ?? true,
    );
  }
}

class GuestSummary {
  final String guestId;
  final String firstName;
  final String lastName;
  final String roomNumber;
  final DateTime? authorizedAt;
  final DateTime? expiresAt;

  GuestSummary({
    required this.guestId,
    required this.firstName,
    required this.lastName,
    required this.roomNumber,
    this.authorizedAt,
    this.expiresAt,
  });

  factory GuestSummary.fromDoc(String id, Map<String, dynamic> data) {
    return GuestSummary(
      guestId: id,
      firstName: (data['firstName'] as String?) ?? '',
      lastName: (data['lastName'] as String?) ?? '',
      roomNumber: (data['roomNumber'] as String?) ?? '',
      authorizedAt: (data['authorizedAt'] as Timestamp?)?.toDate(),
      expiresAt: (data['expiresAt'] as Timestamp?)?.toDate(),
    );
  }

  String get fullName => '$firstName $lastName'.trim();
}

class AdminException implements Exception {
  final String code;
  final String message;
  AdminException({required this.code, required this.message});
  @override
  String toString() => 'AdminException($code): $message';
}
