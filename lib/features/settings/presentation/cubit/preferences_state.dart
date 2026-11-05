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

/// The settings the interface applies and whether they are synced with
/// the backend.
final class PreferencesState extends Equatable {
  const PreferencesState({
    required this.language,
    this.status = PreferencesStatus.initial,
    this.saving = false,
    this.saveError,
  });

  /// Language the interface is in.
  final Locale language;
  final PreferencesStatus status;

  /// A change is being saved; further changes wait until it ends.
  final bool saving;

  /// Why the last change could not be saved; set once per failed save, so
  /// the screen shows it once.
  final Failure? saveError;

  PreferencesState copyWith({
    Locale? language,
    PreferencesStatus? status,
    bool? saving,
    Failure? saveError,
  }) =>
      PreferencesState(
        language: language ?? this.language,
        status: status ?? this.status,
        saving: saving ?? this.saving,
        saveError: saveError,
      );

  @override
  List<Object?> get props => [language, status, saving, saveError];
}
