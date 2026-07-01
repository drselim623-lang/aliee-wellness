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
          message: 'Giriş yapılamadı, tekrar deneyin.',
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
        message: e.message ?? 'Kimlik doğrulama hatası.',
      );
    }
  }

  /// Doktor/Admin email + password login. Custom claim'i (`role`) token içinden okunur.
  Future<User> emailSignIn({
    required String email,
    required String password,
    required String expectedRole,
  }) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = cred.user!;
      final tokenResult = await user.getIdTokenResult(true);
      final role = tokenResult.claims?['role'] as String?;
      if (role != expectedRole) {
        await _auth.signOut();
        throw AuthException(
          code: 'wrong-role',
          message: 'Bu ekran için yetkiniz yok.',
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

  String _mapFunctionsError(FirebaseFunctionsException e) {
    switch (e.code) {
      case 'not-found':
        return 'Pasaport veya oda numarası doğrulanamadı.';
      case 'resource-exhausted':
        return e.message ?? 'Çok fazla hatalı deneme. Lütfen bekleyin.';
      case 'invalid-argument':
        return 'Girilen bilgiler eksik veya hatalı.';
      case 'permission-denied':
        return 'Bu işlem için yetkiniz yok.';
      default:
        return e.message ?? 'Beklenmeyen bir hata oluştu.';
    }
  }

  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'E-posta veya şifre hatalı.';
      case 'too-many-requests':
        return 'Çok fazla deneme yaptınız. Lütfen bekleyin.';
      case 'user-disabled':
        return 'Hesabınız devre dışı bırakılmış.';
      default:
        return e.message ?? 'Giriş yapılamadı.';
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
