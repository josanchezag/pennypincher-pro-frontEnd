import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/error/app_exception.dart';
import 'package:pennypincher_pro/core/error/error_codes.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/core/utils/app_currency.dart';
import 'package:pennypincher_pro/features/settings/data/datasource/preferences_remote_datasource.dart';
import 'package:pennypincher_pro/features/settings/data/repository/preferences_repository_impl.dart';
import 'package:pennypincher_pro/features/settings/domain/entity/user_preferences_entity.dart';

import '../../../helpers/settings_fakes.dart';

class _MockPreferencesRemoteDataSource extends Mock
    implements PreferencesRemoteDataSource {}

void main() {
  late _MockPreferencesRemoteDataSource remote;
  late PreferencesRepositoryImpl repository;
  final saved = savedPreferences('en');

  setUpAll(
    () => registerFallbackValue(const PreferencesChange.language('es')),
  );

  setUp(() {
    remote = _MockPreferencesRemoteDataSource();
    repository = PreferencesRepositoryImpl(remote);
  });

  test('loads the preferences', () async {
    when(() => remote.get()).thenAnswer((_) async => saved);

    expect(await repository.get(), Right<Failure, UserPreferences>(saved));
  });

  test('saves the preferences and returns them as stored', () async {
    const draft = PreferencesChange.language('en');
    when(() => remote.save(draft)).thenAnswer((_) async => saved);

    expect(
      await repository.save(draft),
      Right<Failure, UserPreferences>(saved),
    );
  });

  test('turns a network error into a failure', () async {
    when(() => remote.save(any())).thenThrow(
      const AppException(code: ErrorCodes.networkError, message: 'Offline'),
    );

    final result = await repository
        .save(const PreferencesChange.currency(AppCurrency.usd));

    final failure = result.fold((failure) => failure, (_) => null);
    expect(failure, isA<NetworkFailure>());
  });
}
