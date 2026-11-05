import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/features/settings/domain/repository/preferences_repository.dart';
import 'package:pennypincher_pro/features/settings/domain/usecase/preferences_use_cases.dart';

/// Registers the settings use cases, keeping the domain layer free of
/// dependency injection annotations.
@module
abstract class SettingsModule {
  @injectable
  GetPreferences getPreferences(PreferencesRepository repository) =>
      GetPreferences(repository);

  @injectable
  SavePreferences savePreferences(PreferencesRepository repository) =>
      SavePreferences(repository);
}
