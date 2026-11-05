import 'package:dartz/dartz.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/features/settings/domain/entity/user_preferences_entity.dart';
import 'package:pennypincher_pro/features/settings/domain/repository/preferences_repository.dart';

/// Loads the settings of the signed-in user.
class GetPreferences {
  const GetPreferences(this._repository);

  final PreferencesRepository _repository;

  Future<Either<Failure, UserPreferences>> call() => _repository.get();
}

/// Saves some settings of the signed-in user.
class SavePreferences {
  const SavePreferences(this._repository);

  final PreferencesRepository _repository;

  Future<Either<Failure, UserPreferences>> call(PreferencesChange change) =>
      _repository.save(change);
}
