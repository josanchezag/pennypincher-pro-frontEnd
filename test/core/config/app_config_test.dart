import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/config/app_config.dart';
import 'package:pennypincher_pro/core/constants/app_constants.dart';

void main() {
  group('AppConfig.fromEnvironment', () {
    test('falls back to local defaults without dart-defines', () {
      final config = AppConfig.fromEnvironment();

      expect(config.apiBaseUrl, EnvDefaults.apiBaseUrl);
      expect(config.googleClientId, isEmpty);
      expect(config.devLoginEnabled, isFalse);
      expect(config.isGoogleSignInConfigured, isFalse);
    });
  });

  test('isGoogleSignInConfigured is true when a client id is set', () {
    const config = AppConfig(
      apiBaseUrl: EnvDefaults.apiBaseUrl,
      googleClientId: 'client.apps.googleusercontent.com',
      devLoginEnabled: true,
    );

    expect(config.isGoogleSignInConfigured, isTrue);
  });
}
