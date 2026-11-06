import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/error/app_exception.dart';
import 'package:pennypincher_pro/core/error/error_codes.dart';
import 'package:pennypincher_pro/core/utils/app_currency.dart';
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
    adapter.handler = (_) async => FakeResponse(
          200,
          envelope({
            'language': 'en',
            'currency': 'USD',
            'updatedAt': '2026-11-02T15:00:00Z',
          }),
        );

    final preferences = await dataSource.get();

    final request = adapter.requests.single;
    expect(request.method, 'GET');
    expect(request.path, '/users/me/preferences');
    expect(
      preferences,
      UserPreferences(
        languageCode: 'en',
        currency: AppCurrency.usd,
        updatedAt: DateTime.utc(2026, 11, 2, 15),
      ),
    );
    expect(preferences.isSaved, isTrue);
  });

  test('reads pesos from a backend without the currency setting', () async {
    final preferences = await dataSource.get();

    expect(preferences.currency, AppCurrency.cop);
    expect(preferences.languageCode, 'en');
  });

  test('reads pesos for a currency the app does not offer', () async {
    adapter.handler = (_) async => FakeResponse(
          200,
          envelope({'language': 'es', 'currency': 'GBP'}),
        );

    expect((await dataSource.get()).currency, AppCurrency.cop);
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

  test('puts only the language when the language changes', () async {
    final saved = await dataSource.save(const PreferencesChange.language('en'));

    final request = adapter.requests.single;
    expect(request.method, 'PUT');
    expect(request.path, '/users/me/preferences');
    expect(request.data, {'language': 'en'});
    expect(saved.languageCode, 'en');
    expect(saved.updatedAt, DateTime.utc(2026, 11, 2, 15));
  });

  test('puts only the currency code when the currency changes', () async {
    await dataSource.save(const PreferencesChange.currency(AppCurrency.eur));

    expect(adapter.requests.single.data, {'currency': 'EUR'});
  });

  test('puts both settings when both change', () async {
    await dataSource.save(
      const PreferencesChange(languageCode: 'es', currency: AppCurrency.usd),
    );

    expect(adapter.requests.single.data, {'language': 'es', 'currency': 'USD'});
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
      () => dataSource.save(const PreferencesChange.language('fr')),
      throwsA(
        isA<AppException>()
            .having((e) => e.statusCode, 'statusCode', 400)
            .having((e) => e.message, 'message', l10n.errorValidationFailed),
      ),
    );
  });
}
