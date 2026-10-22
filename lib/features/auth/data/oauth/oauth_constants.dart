/// Parameters of the Google OAuth 2.0 authorization code flow with PKCE
/// (RFC 7636).
abstract final class GoogleOAuth {
  static const String authorizationHost = 'accounts.google.com';
  static const String authorizationPath = '/o/oauth2/v2/auth';
  static const String scope = 'openid email profile';
  static const String responseType = 'code';
  static const String codeChallengeMethod = 'S256';
  static const String prompt = 'select_account';
}

/// Query parameter names of the authorization request and its callback.
abstract final class OAuthParams {
  static const String clientId = 'client_id';
  static const String redirectUri = 'redirect_uri';
  static const String responseType = 'response_type';
  static const String scope = 'scope';
  static const String codeChallenge = 'code_challenge';
  static const String codeChallengeMethod = 'code_challenge_method';
  static const String state = 'state';
  static const String prompt = 'prompt';
  static const String code = 'code';
  static const String error = 'error';
}

/// PKCE sizes: RFC 7636 allows verifiers of 43 to 128 characters.
abstract final class PkceSpec {
  static const int verifierLength = 64;
  static const int stateBytes = 32;
  static const int byteValues = 256;
  static const String unreservedCharacters =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';
}

/// Browser storage key where `web/auth_callback.js` leaves the callback URL
/// when the authorization tab was opened without `window.opener`.
abstract final class OAuthStorage {
  static const String callbackKey = 'flutter-web-auth-2';
}

/// Client-side error codes of the sign-in flow.
abstract final class OAuthErrorCodes {
  static const String cancelled = 'GOOGLE_AUTH_CANCELLED';
  static const String stateMismatch = 'OAUTH_STATE_MISMATCH';
  static const String failed = 'GOOGLE_AUTH_FAILED';
  static const String notConfigured = 'GOOGLE_AUTH_NOT_CONFIGURED';
}

/// User-facing messages of the sign-in flow.
abstract final class OAuthMessages {
  static const String cancelled = 'Sign-in was cancelled.';
  static const String stateMismatch =
      'The sign-in response could not be verified. Please try again.';
  static const String failed = 'Google sign-in failed. Please try again.';
  static const String notConfigured = 'Google sign-in is not configured.';
}
