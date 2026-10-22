import 'package:pennypincher_pro/core/constants/app_constants.dart';

/// Runtime configuration resolved from `--dart-define` values.
class AppConfig {
  const AppConfig({
    required this.apiBaseUrl,
    required this.googleClientId,
    required this.googleRedirectUri,
    required this.devLoginEnabled,
  });

  /// Reads the compile-time environment. A missing client id is empty and
  /// dev login stays disabled unless `DEV_LOGIN=true`. The calls must stay
  /// `const` so the compiler inlines the values.
  factory AppConfig.fromEnvironment() => const AppConfig(
        apiBaseUrl: String.fromEnvironment(
          EnvKeys.apiBaseUrl,
          defaultValue: EnvDefaults.apiBaseUrl,
        ),
        googleClientId: String.fromEnvironment(EnvKeys.googleClientId),
        googleRedirectUri: String.fromEnvironment(
          EnvKeys.googleRedirectUri,
          defaultValue: EnvDefaults.googleRedirectUri,
        ),
        devLoginEnabled: bool.fromEnvironment(EnvKeys.devLogin),
      );

  final String apiBaseUrl;
  final String googleClientId;

  /// Page of this app that receives the Google authorization code. It must
  /// be `<app origin>/auth.html` and be registered in Google Cloud Console
  /// and in the backend allowlist.
  final String googleRedirectUri;
  final bool devLoginEnabled;

  bool get isGoogleSignInConfigured => googleClientId.isNotEmpty;
}
