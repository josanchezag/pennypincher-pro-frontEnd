/// Application-wide constants. No literal strings or numbers with domain
/// meaning should live outside this file or the theme tokens.
abstract final class AppConstants {
  static const String appName = 'PennyPincher Pro';
  static const String tagline = 'Your personal finance command center';

  static const Duration splashDuration = Duration(milliseconds: 1500);
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);

  static const String contentTypeJson = 'application/json';
}

/// Names of the `--dart-define` variables read at compile time.
abstract final class EnvKeys {
  static const String apiBaseUrl = 'API_BASE_URL';
  static const String googleClientId = 'GOOGLE_CLIENT_ID';
  static const String devLogin = 'DEV_LOGIN';
}

/// Values used when a `--dart-define` variable is not provided.
abstract final class EnvDefaults {
  static const String apiBaseUrl = 'http://localhost:8080/api/v1';
}
