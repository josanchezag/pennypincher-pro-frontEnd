import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/error/app_exception.dart';
import 'package:pennypincher_pro/core/error/error_codes.dart';
import 'package:pennypincher_pro/features/settings/data/datasource/preferences_remote_datasource.dart';
import 'package:pennypincher_pro/features/settings/domain/entity/user_preferences_entity.dart';

import '../../../helpers/fake_http_adapter.dart';
import '../../../helpers/l10n.dart';

void main() {
  late FakeHttpAdapter adapter;
  late PreferencesRemoteDataSource dataSource;

  setUp(() {
    adapter = FakeHttpAdapter(
      (_) async => FakeResponse(
        200,
        envelope({'language': 'en', 'updatedAt': '2026-11-02T15:00:00Z'}),
      ),
    );
    dataSource = PreferencesRemoteDataSource(fakeDio(adapter));
  });

  test('reads the saved preferences of the user', () async {
    final preferences = await dataSource.get();

    final request = adapter.requests.single;
    expect(request.method, 'GET');
    expect(request.path, '/users/me/preferences');
    expect(
      preferences,
      UserPreferences(
        languageCode: 'en',
        updatedAt: DateTime.utc(2026, 11, 2, 15),
      ),
    );
    expect(preferences.isSaved, isTrue);
  });

  test('reads the defaults of a user who never saved preferences', () async {
    adapter.handler = (_) async => FakeResponse(
          200,
          envelope({'language': 'es'}),
        );

    final preferences = await dataSource.get();

    expect(preferences, const UserPreferences(languageCode: 'es'));
    expect(preferences.isSaved, isFalse);
  });

  test('puts only the settings, never the update time', () async {
    final saved = await dataSource.save(
      UserPreferences(languageCode: 'en', updatedAt: DateTime.utc(2020)),
    );

    final request = adapter.requests.single;
    expect(request.method, 'PUT');
    expect(request.path, '/users/me/preferences');
    expect(request.data, {'language': 'en'});
    expect(saved.languageCode, 'en');
    expect(saved.updatedAt, DateTime.utc(2026, 11, 2, 15));
  });

  test('rejects preferences without a language', () {
    adapter.handler = (_) async => FakeResponse(200, envelope({}));

    expect(
      dataSource.get,
      throwsA(
        isA<AppException>()
            .having((e) => e.code, 'code', ErrorCodes.invalidResponse),
      ),
    );
  });

  test('reports a rejected language in the interface language', () {
    adapter.handler = (_) async => FakeResponse(
          400,
          errorEnvelope('VALIDATION_FAILED', 'Invalid language'),
        );

    expect(
      () => dataSource.save(const UserPreferences(languageCode: 'fr')),
      throwsA(
        isA<AppException>()
            .having((e) => e.statusCode, 'statusCode', 400)
            .having((e) => e.message, 'message', l10n.errorValidationFailed),
      ),
    );
  });
}
