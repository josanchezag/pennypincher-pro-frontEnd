import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/core/utils/app_currency.dart';
import 'package:pennypincher_pro/features/settings/domain/entity/user_preferences_entity.dart';
import 'package:pennypincher_pro/features/settings/domain/usecase/preferences_use_cases.dart';

import '../../../helpers/settings_fakes.dart';

void main() {
  test('loads and saves through the repository', () async {
    final repository = FakePreferencesRepository(savedPreferences('es'));

    expect(
      await GetPreferences(repository)(),
      Right<Failure, UserPreferences>(savedPreferences('es')),
    );
    await SavePreferences(repository)(const PreferencesChange.language('en'));
    await SavePreferences(repository)(
      const PreferencesChange.currency(AppCurrency.eur),
    );

    expect(repository.saves.first.languageCode, 'en');
    expect(repository.saves.last.currency, AppCurrency.eur);
    expect(repository.stored, savedPreferences('en', AppCurrency.eur));
  });

  test('tells saved preferences from the defaults', () {
    expect(defaultPreferences.isSaved, isFalse);
    expect(defaultPreferences.currency, AppCurrency.cop);
    expect(savedPreferences('es').isSaved, isTrue);
  });

  test('builds a change of a single setting', () {
    const language = PreferencesChange.language('en');
    const currency = PreferencesChange.currency(AppCurrency.usd);

    expect(language.currency, isNull);
    expect(currency.languageCode, isNull);
    expect(
      const PreferencesChange(languageCode: 'en', currency: AppCurrency.eur),
      isNot(language),
    );
    expect(PreferencesChange.new, throwsAssertionError);
  });
}
