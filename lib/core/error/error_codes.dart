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

  // Other backend codes, which the interface explains in its own words.
  static const String validationFailed = 'VALIDATION_FAILED';
  static const String unauthorized = 'UNAUTHORIZED';
  static const String forbidden = 'FORBIDDEN';
  static const String forbiddenOrigin = 'FORBIDDEN_ORIGIN';
  static const String notFound = 'NOT_FOUND';
  static const String conflict = 'CONFLICT';
  static const String rateLimited = 'RATE_LIMITED';
  static const String googleAuthFailed = 'GOOGLE_AUTH_FAILED';
  static const String identityProviderUnavailable =
      'IDENTITY_PROVIDER_UNAVAILABLE';
}

/// User-facing error messages in the current interface language. The
/// backend writes its messages in English for developers, so the interface
/// never shows them: it explains each backend error code in its own words.
abstract final class ErrorMessages {
  static String get network => CurrentL10n.texts.errorNetwork;

  static String get invalidResponse => CurrentL10n.texts.errorInvalidResponse;

  static String get unexpected => CurrentL10n.texts.errorUnexpected;

  /// What the interface says for the backend error [code]; codes without
  /// a message of their own get [unexpected].
  static String forBackendCode(String code) {
    final texts = CurrentL10n.texts;
    return switch (code) {
      ErrorCodes.validationFailed => texts.errorValidationFailed,
      ErrorCodes.unauthorized => texts.errorSessionExpired,
      ErrorCodes.forbidden ||
      ErrorCodes.forbiddenOrigin =>
        texts.errorForbidden,
      ErrorCodes.notFound => texts.errorNotFound,
      ErrorCodes.conflict => texts.errorConflict,
      ErrorCodes.rateLimited => texts.errorRateLimited,
      ErrorCodes.accountNotAllowed => texts.signInAccountNotAllowed,
      ErrorCodes.registrationDisabled => texts.signInRegistrationDisabled,
      ErrorCodes.googleAuthFailed => texts.signInFailed,
      ErrorCodes.identityProviderUnavailable =>
        texts.errorIdentityProviderUnavailable,
      _ => texts.errorUnexpected,
    };
  }
}
