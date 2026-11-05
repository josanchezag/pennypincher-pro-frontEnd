import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/l10n/locale_cubit.dart';
import 'package:pennypincher_pro/core/l10n/locale_store.dart';
import 'package:pennypincher_pro/features/settings/domain/entity/user_preferences_entity.dart';
import 'package:pennypincher_pro/features/settings/domain/usecase/preferences_use_cases.dart';

part 'preferences_state.dart';

/// Keeps the user's settings in sync with the backend. Before sign-in, and
/// whenever the backend cannot be reached, the interface uses the language
/// remembered on this device ([LocaleCubit]). After sign-in, [load] applies
/// the language saved in the account. A user who never saved one keeps the
/// language picked on this device, which is then saved to the account.
/// [changeLanguage] applies a language at once and saves it; if saving
/// fails, the previous language comes back and [PreferencesState.saveError]
/// says why.
@lazySingleton
class PreferencesCubit extends Cubit<PreferencesState> {
  PreferencesCubit(
    this._getPreferences,
    this._savePreferences,
    this._localeCubit,
    this._localeStore,
  ) : super(PreferencesState(language: _localeCubit.state));

  final GetPreferences _getPreferences;
  final SavePreferences _savePreferences;
  final LocaleCubit _localeCubit;
  final LocaleStore _localeStore;

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

  /// Applies the [stored] language, unless the user never saved one and
  /// picked another on this device ([remembered]): that one is kept and
  /// saved to the account.
  Future<void> _adopt(UserPreferences stored, String? remembered) async {
    final deviceChoice = AppLocales.forLanguageCode(remembered);
    if (stored.isSaved ||
        deviceChoice == null ||
        deviceChoice.languageCode == stored.languageCode) {
      final language = AppLocales.forLanguageCode(stored.languageCode);
      _apply(language ?? state.language, PreferencesStatus.ready);
      return;
    }
    _apply(deviceChoice, PreferencesStatus.ready);
    emit(state.copyWith(saving: true));
    await _savePreferences(
      UserPreferences(languageCode: deviceChoice.languageCode),
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
    emit(state.copyWith(language: selected, saving: true));
    final result = await _savePreferences(
      UserPreferences(languageCode: selected.languageCode),
    );
    if (isClosed) {
      return;
    }
    result.fold(
      (failure) {
        _localeCubit.select(previous);
        emit(
          state.copyWith(
            language: previous,
            saving: false,
            saveError: failure,
          ),
        );
      },
      (_) => emit(state.copyWith(saving: false)),
    );
  }

  /// Forgets the account after sign-out; the interface keeps its language.
  void reset() {
    _generation++;
    emit(PreferencesState(language: _localeCubit.state));
  }

  void _apply(Locale language, PreferencesStatus status) {
    _localeCubit.select(language);
    emit(state.copyWith(language: language, status: status));
  }
}
