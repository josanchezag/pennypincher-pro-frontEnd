import 'package:dartz/dartz.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/features/settings/domain/entity/user_preferences_entity.dart';

/// The settings of the signed-in user.
abstract interface class PreferencesRepository {
  /// The stored settings, or the defaults when the user never saved any.
  Future<Either<Failure, UserPreferences>> get();

  /// Replaces every setting with [preferences] and returns them as stored.
  Future<Either<Failure, UserPreferences>> save(UserPreferences preferences);
}
