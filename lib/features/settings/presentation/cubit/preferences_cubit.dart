import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/l10n/locale_cubit.dart';
import 'package:pennypincher_pro/core/l10n/locale_store.dart';
import 'package:pennypincher_pro/core/storage/currency_store.dart';
import 'package:pennypincher_pro/core/utils/app_currency.dart';
import 'package:pennypincher_pro/features/settings/domain/entity/user_preferences_entity.dart';
import 'package:pennypincher_pro/features/settings/domain/usecase/preferences_use_cases.dart';

part 'preferences_state.dart';

/// Keeps the user's settings in sync with the backend. Before sign-in, and
/// whenever the backend cannot be reached, the interface uses the language
/// and the currency remembered on this device ([LocaleCubit] and
/// [CurrencyStore]). After sign-in, [load] applies the ones saved in the
/// account. A user who never saved a language keeps the one picked on this
/// device, which is then saved to the account; the currency of such a user
/// is the backend default, Colombian pesos.
///
/// [changeLanguage] and [changeCurrency] apply a setting at once and save
/// only that one, so a setting that could not be loaded is never
/// overwritten. If saving fails, the previous value comes back and
/// [PreferencesState.saveError] says why.
@lazySingleton
class PreferencesCubit extends Cubit<PreferencesState> {
  PreferencesCubit(
    this._getPreferences,
    this._savePreferences,
    this._localeCubit,
    this._localeStore,
    this._currencyStore,
  ) : super(
          PreferencesState(
            language: _localeCubit.state,
            currency: AppCurrency.forCode(_currencyStore.read()) ??
                AppCurrency.fallback,
          ),
        );

  final GetPreferences _getPreferences;
  final SavePreferences _savePreferences;
  final LocaleCubit _localeCubit;
  final LocaleStore _localeStore;
  final CurrencyStore _currencyStore;

  /// Counts the loads, so a load that a sign-out or a newer load replaced
  /// does not apply its result.
  int _generation = 0;

  /// Loads the settings of the user who just signed in.
  Future<void> load() async {
    final generation = ++_generation;
    final remembered = _localeStore.read();
    emit(state.copyWith(status: PreferencesStatus.loading));
    final result = await _getPreferences();
    if (generation != _generation || isClosed) {
      return;
    }
    await result.fold(
      (_) async => emit(state.copyWith(status: PreferencesStatus.loadFailed)),
      (stored) => _adopt(stored, remembered),
    );
  }

  /// Applies the [stored] settings, except a language the user never saved
  /// when they picked another on this device ([remembered]): that one is
  /// kept and saved to the account.
  Future<void> _adopt(UserPreferences stored, String? remembered) async {
    _currencyStore.write(stored.currency.code);
    final deviceChoice = AppLocales.forLanguageCode(remembered);
    if (stored.isSaved ||
        deviceChoice == null ||
        deviceChoice.languageCode == stored.languageCode) {
      final language = AppLocales.forLanguageCode(stored.languageCode);
      _apply(language ?? state.language, stored.currency);
      return;
    }
    _apply(deviceChoice, stored.currency);
    emit(
      state.copyWith(
        saving: true,
        changedSetting: PreferenceSetting.language,
      ),
    );
    await _savePreferences(
      PreferencesChange.language(deviceChoice.languageCode),
    );
    if (!isClosed) {
      emit(state.copyWith(saving: false));
    }
  }

  /// Applies [locale] and saves it to the account. Ignored while another
  /// change is being saved or when [locale] is already applied.
  Future<void> changeLanguage(Locale locale) async {
    final selected = AppLocales.forLanguageCode(locale.languageCode);
    if (selected == null || state.saving || selected == state.language) {
      return;
    }
    final previous = state.language;
    _localeCubit.select(selected);
    emit(
      state.copyWith(
        language: selected,
        saving: true,
        changedSetting: PreferenceSetting.language,
      ),
    );
    final result = await _savePreferences(
      PreferencesChange.language(selected.languageCode),
    );
    _settle(result, () {
      _localeCubit.select(previous);
      return state.copyWith(language: previous);
    });
  }

  /// Shows every amount in [currency] at once and saves it to the account.
  /// The amounts themselves are not converted. Ignored while another
  /// change is being saved or when [currency] is already applied.
  Future<void> changeCurrency(AppCurrency currency) async {
    if (state.saving || currency == state.currency) {
      return;
    }
    final previous = state.currency;
    _currencyStore.write(currency.code);
    emit(
      state.copyWith(
        currency: currency,
        saving: true,
        changedSetting: PreferenceSetting.currency,
      ),
    );
    final result = await _savePreferences(PreferencesChange.currency(currency));
    _settle(result, () {
      _currencyStore.write(previous.code);
      return state.copyWith(currency: previous);
    });
  }

  /// Ends a save: on failure, [revert] brings back the previous value and
  /// the state says why.
  void _settle(
    Either<Failure, UserPreferences> result,
    PreferencesState Function() revert,
  ) {
    if (isClosed) {
      return;
    }
    result.fold(
      (failure) => emit(revert().copyWith(saving: false, saveError: failure)),
      (_) => emit(state.copyWith(saving: false)),
    );
  }

  /// Forgets the account after sign-out; the interface keeps its language
  /// and its currency.
  void reset() {
    _generation++;
    emit(
      PreferencesState(language: _localeCubit.state, currency: state.currency),
    );
  }

  void _apply(Locale language, AppCurrency currency) {
    _localeCubit.select(language);
    emit(
      state.copyWith(
        language: language,
        currency: currency,
        status: PreferencesStatus.ready,
      ),
    );
  }
}
