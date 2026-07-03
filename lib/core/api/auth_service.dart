import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Aliee Wellness — auth servisi.
/// Cloud Functions (europe-west1) çağrılarını sarmalar.
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFunctions _functions =
      FirebaseFunctions.instanceFor(region: 'europe-west1');

  User? get currentUser => _auth.currentUser;
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  /// Misafir girişi — pasaport son 6 + oda no ile Cloud Function'a gider.
  /// Başarılıysa Firebase custom token dönüşü ile signInWithCustomToken çalışır.
  Future<User> guestSignIn({
    required String passportLast6,
    required String roomNumber,
  }) async {
    try {
      final result = await _functions.httpsCallable('guestSignIn').call({
        'passportLast6': passportLast6,
        'roomNumber': roomNumber,
      });
      final token = (result.data as Map)['token'] as String;
      final cred = await _auth.signInWithCustomToken(token);
      final user = cred.user;
      if (user == null) {
        throw AuthException(
          code: 'unknown',
          message: 'Sign-in failed, please retry.',
        );
      }
      return user;
    } on FirebaseFunctionsException catch (e) {
      throw AuthException(
        code: e.code,
        message: _mapFunctionsError(e),
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(
        code: e.code,
        message: e.message ?? 'Authentication error.',
      );
    }
  }

  /// Doktor/Admin email + password login. Custom claim'i (`role`) token içinden okunur.
  /// Kullanıcı sadece "admin" veya "doktor" yazarsa otomatik olarak @aliee.local eklenir.
  Future<User> emailSignIn({
    required String email,
    required String password,
    required String expectedRole,
  }) async {
    final normalizedEmail = _normalizeEmail(email);
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: normalizedEmail,
        password: password,
      );
      final user = cred.user!;
      final tokenResult = await user.getIdTokenResult(true);
      final role = tokenResult.claims?['role'] as String?;
      if (role != expectedRole) {
        await _auth.signOut();
        throw AuthException(
          code: 'wrong-role',
          message: 'Not authorized for this screen.',
        );
      }
      return user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(
        code: e.code,
        message: _mapAuthError(e),
      );
    }
  }

  Future<void> signOut() => _auth.signOut();

  /// Basit kullanıcı adı → e-posta dönüşümü. "admin" → "admin@aliee.local".
  /// İçinde @ varsa dokunmaz.
  String _normalizeEmail(String input) {
    final trimmed = input.trim().toLowerCase();
    if (trimmed.contains('@')) return trimmed;
    if (trimmed.isEmpty) return trimmed;
    return '$trimmed@aliee.local';
  }

  // Mesajlar log/fallback içindir; UI, AuthException.code'u
  // auth_error_l10n.dart üzerinden kullanıcının diline çevirir.
  String _mapFunctionsError(FirebaseFunctionsException e) {
    switch (e.code) {
      case 'not-found':
        return 'Passport or room number could not be verified.';
      case 'resource-exhausted':
        return e.message ?? 'Too many failed attempts. Please wait.';
      case 'invalid-argument':
        return 'The information entered is missing or incorrect.';
      case 'permission-denied':
        return 'Not authorized for this action.';
      default:
        return e.message ?? 'An unexpected error occurred.';
    }
  }

  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect e-mail or password.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait.';
      case 'user-disabled':
        return 'Account disabled.';
      default:
        return e.message ?? 'Sign-in failed.';
    }
  }
}

class AuthException implements Exception {
  final String code;
  final String message;
  AuthException({required this.code, required this.message});

  @override
  String toString() => 'AuthException($code): $message';
}
