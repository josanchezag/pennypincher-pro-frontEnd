import 'package:pennypincher_pro/core/l10n/l10n.dart';

/// Error codes produced on the client. Backend codes (for example
/// `GOOGLE_AUTH_FAILED` or `UNAUTHORIZED`) are passed through unchanged.
abstract final class ErrorCodes {
  static const String networkError = 'NETWORK_ERROR';
  static const String invalidResponse = 'INVALID_RESPONSE';
  static const String unknown = 'UNKNOWN_ERROR';

  /// Backend: another tab rotated the refresh cookie first. The browser
  /// already holds the newer cookie, so the refresh is simply retried.
  static const String refreshSuperseded = 'REFRESH_SUPERSEDED';

  /// Backend (403): the Google account is not on the sign-in allowlist.
  /// On a refresh it also means the session is over.
  static const String accountNotAllowed = 'ACCOUNT_NOT_ALLOWED';

  /// Backend (403): a new account tried to sign in while sign-ups are closed.
  static const String registrationDisabled = 'REGISTRATION_DISABLED';
}

/// User-facing messages for errors without a backend message, in the
/// current interface language.
abstract final class ErrorMessages {
  static String get network => CurrentL10n.texts.errorNetwork;

  static String get invalidResponse => CurrentL10n.texts.errorInvalidResponse;

  static String get unexpected => CurrentL10n.texts.errorUnexpected;
}
