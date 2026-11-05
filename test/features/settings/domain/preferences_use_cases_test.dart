import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
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
    await SavePreferences(repository)(
      const UserPreferences(languageCode: 'en'),
    );

    expect(repository.saves.single.languageCode, 'en');
    expect(repository.stored, savedPreferences('en'));
  });

  test('tells saved preferences from the defaults', () {
    expect(defaultPreferences.isSaved, isFalse);
    expect(savedPreferences('es').isSaved, isTrue);
  });
}
