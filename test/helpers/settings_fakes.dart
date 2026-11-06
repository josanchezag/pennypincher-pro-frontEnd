import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/core/l10n/locale_cubit.dart';
import 'package:pennypincher_pro/core/l10n/locale_store.dart';
import 'package:pennypincher_pro/core/storage/currency_store.dart';
import 'package:pennypincher_pro/core/utils/app_currency.dart';
import 'package:pennypincher_pro/features/settings/domain/entity/user_preferences_entity.dart';
import 'package:pennypincher_pro/features/settings/domain/repository/preferences_repository.dart';
import 'package:pennypincher_pro/features/settings/domain/usecase/preferences_use_cases.dart';
import 'package:pennypincher_pro/features/settings/presentation/cubit/preferences_cubit.dart';

/// Preferences saved in the account with [languageCode] and [currency].
UserPreferences savedPreferences(
  String languageCode, [
  AppCurrency currency = AppCurrency.cop,
]) =>
    UserPreferences(
      languageCode: languageCode,
      currency: currency,
      updatedAt: DateTime.utc(2026, 11, 2, 15),
    );

/// The backend defaults of a user who never saved preferences.
const UserPreferences defaultPreferences = UserPreferences(languageCode: 'es');

const Failure offline = NetworkFailure('Offline');

/// In-memory backend of the preferences: [stored] is what a load returns
/// and what a save changes, setting by setting, as the backend does. [loadFailure] and [saveFailure] make the
/// calls fail; [pendingSave] holds a save until the test completes it.
class FakePreferencesRepository implements PreferencesRepository {
  FakePreferencesRepository([this.stored = defaultPreferences]);

  UserPreferences stored;
  Failure? loadFailure;
  Failure? saveFailure;
  Completer<void>? pendingSave;
  int loads = 0;
  final List<PreferencesChange> saves = [];

  @override
  Future<Either<Failure, UserPreferences>> get() async {
    loads++;
    final failure = loadFailure;
    return failure == null ? Right(stored) : Left(failure);
  }

  @override
  Future<Either<Failure, UserPreferences>> save(
    PreferencesChange change,
  ) async {
    saves.add(change);
    await pendingSave?.future;
    final failure = saveFailure;
    if (failure != null) {
      return Left(failure);
    }
    stored = savedPreferences(
      change.languageCode ?? stored.languageCode,
      change.currency ?? stored.currency,
    );
    return Right(stored);
  }
}

/// [CurrencyStore] kept in memory, optionally starting with [currencyCode].
class MemoryCurrencyStore implements CurrencyStore {
  MemoryCurrencyStore([this.currencyCode]);

  String? currencyCode;

  @override
  String? read() => currencyCode;

  @override
  void write(String currencyCode) => this.currencyCode = currencyCode;
}

/// A [PreferencesCubit] over [repository] that applies languages to
/// [localeCubit], reads the device language from [store] and the device
/// currency from [currencies] (none by default).
PreferencesCubit preferencesCubit(
  PreferencesRepository repository,
  LocaleCubit localeCubit,
  LocaleStore store, [
  CurrencyStore? currencies,
]) =>
    PreferencesCubit(
      GetPreferences(repository),
      SavePreferences(repository),
      localeCubit,
      store,
      currencies ?? MemoryCurrencyStore(),
    );
