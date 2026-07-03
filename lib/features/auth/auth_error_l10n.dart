import '../../core/api/auth_service.dart';
import '../../core/l10n/app_localizations.dart';

/// AuthException.code → kullanıcının dilinde hata mesajı.
/// Servis katmanındaki mesajlar sadece log içindir; UI bunu kullanır.
String localizedAuthError(AppL10n l, AuthException e) {
  switch (e.code) {
    case 'not-found':
      return l.authErrorGuestNotFound;
    case 'resource-exhausted':
    case 'too-many-requests':
      return l.authErrorTooManyAttempts;
    case 'invalid-argument':
      return l.authErrorInvalidInput;
    case 'permission-denied':
      return l.authErrorNoPermission;
    case 'wrong-role':
      return l.authErrorWrongRole;
    case 'user-not-found':
    case 'wrong-password':
    case 'invalid-credential':
      return l.authErrorWrongCredentials;
    case 'user-disabled':
      return l.authErrorUserDisabled;
    case 'unknown':
      return l.authErrorSignInFailed;
    default:
      return l.authErrorUnexpected;
  }
}
