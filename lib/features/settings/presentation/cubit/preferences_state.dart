part of 'preferences_cubit.dart';

/// How far loading the stored settings of the signed-in user got.
enum PreferencesStatus {
  /// Nobody is signed in, or the load has not started.
  initial,
  loading,

  /// The settings came from the backend.
  ready,

  /// The backend could not be reached: the interface keeps the settings
  /// remembered on this device.
  loadFailed,
}

/// A setting of the preferences screen.
enum PreferenceSetting { language, currency }

/// The settings the interface applies and whether they are synced with
/// the backend.
final class PreferencesState extends Equatable {
  const PreferencesState({
    required this.language,
    this.currency = AppCurrency.fallback,
    this.status = PreferencesStatus.initial,
    this.saving = false,
    this.saveError,
    this.changedSetting,
  });

  /// Language the interface is in.
  final Locale language;

  /// Currency every amount is shown in.
  final AppCurrency currency;
  final PreferencesStatus status;

  /// A change is being saved; further changes wait until it ends.
  final bool saving;

  /// The setting of the change being saved, or of the last one.
  final PreferenceSetting? changedSetting;

  /// Why the last change could not be saved; set once per failed save, so
  /// the screen shows it once.
  final Failure? saveError;

  PreferencesState copyWith({
    Locale? language,
    AppCurrency? currency,
    PreferencesStatus? status,
    bool? saving,
    Failure? saveError,
    PreferenceSetting? changedSetting,
  }) =>
      PreferencesState(
        language: language ?? this.language,
        currency: currency ?? this.currency,
        status: status ?? this.status,
        saving: saving ?? this.saving,
        saveError: saveError,
        changedSetting: changedSetting ?? this.changedSetting,
      );

  /// Whether a change of [setting] is being saved.
  bool savingSetting(PreferenceSetting setting) =>
      saving && changedSetting == setting;

  @override
  List<Object?> get props =>
      [language, currency, status, saving, saveError, changedSetting];
}
