/// Application-wide constants. No literal strings or numbers with domain
/// meaning should live outside this file or the theme tokens.
abstract final class AppConstants {
  static const String appName = 'PennyPincher Pro';
  static const String tagline = 'Your personal finance command center';

  /// The splash screen stays at least [splashMinDuration] and, while the
  /// session check is still running, at most [splashMaxDuration].
  static const Duration splashMinDuration = Duration(seconds: 1);
  static const Duration splashMaxDuration = Duration(seconds: 2);
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);

  /// Wait before repeating a refresh that another tab superseded, so the
  /// browser has stored the cookie rotated by that tab.
  static const Duration refreshSupersededRetryDelay =
      Duration(milliseconds: 300);

  static const String contentTypeJson = 'application/json';
}

/// Names of the `--dart-define` variables read at compile time.
abstract final class EnvKeys {
  static const String apiBaseUrl = 'API_BASE_URL';
  static const String googleClientId = 'GOOGLE_CLIENT_ID';
  static const String googleRedirectUri = 'GOOGLE_REDIRECT_URI';
  static const String devLogin = 'DEV_LOGIN';
}

/// Values used when a `--dart-define` variable is not provided.
abstract final class EnvDefaults {
  static const String apiBaseUrl = 'http://localhost:8080/api/v1';
  static const String googleRedirectUri = 'http://localhost:3000/auth.html';
}

/// Backend endpoints, relative to the API base URL.
abstract final class ApiPaths {
  static const String authPrefix = '/auth/';
  static const String googleCallback = '/auth/google/callback';
  static const String devLogin = '/auth/dev-login';
  static const String refresh = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String assets = '/assets';
  static const String liabilities = '/liabilities';
  static const String netWorthSnapshots = '/net-worth/snapshots';
  static const String netWorthCurrent = '/net-worth/current';
  static const String incomeSources = '/income-sources';
}

/// Keys of the backend response envelope (`{data, meta}` / `{error, meta}`).
abstract final class ApiEnvelopeKeys {
  static const String data = 'data';
  static const String error = 'error';
  static const String code = 'code';
  static const String message = 'message';
  static const String details = 'details';
  static const String field = 'field';
}

/// Names of the HTTP clients registered in the service locator.
abstract final class NetworkNames {
  static const String plainDio = 'plainDio';
}

/// HTTP header names set by the client.
abstract final class HttpHeaders {
  static const String authorization = 'Authorization';
}

/// HTTP status codes the client reacts to.
abstract final class HttpStatusCodes {
  static const int unauthorized = 401;
  static const int notFound = 404;
}
