import 'package:pennypincher_pro/core/config/app_config.dart';

/// Configurations used by widget and unit tests.
abstract final class TestConfigs {
  static const String apiBaseUrl = 'http://api.test/api/v1';
  static const String clientId = 'client-id.apps.googleusercontent.com';
  static const String redirectUri = 'http://localhost:3000/auth.html';

  static const AppConfig googleOnly = AppConfig(
    apiBaseUrl: apiBaseUrl,
    googleClientId: clientId,
    googleRedirectUri: redirectUri,
    devLoginEnabled: false,
  );

  static const AppConfig withDevLogin = AppConfig(
    apiBaseUrl: apiBaseUrl,
    googleClientId: clientId,
    googleRedirectUri: redirectUri,
    devLoginEnabled: true,
  );

  static const AppConfig unconfigured = AppConfig(
    apiBaseUrl: apiBaseUrl,
    googleClientId: '',
    googleRedirectUri: redirectUri,
    devLoginEnabled: false,
  );
}
