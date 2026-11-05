import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/core/error/failure_guard.dart';
import 'package:pennypincher_pro/features/settings/data/datasource/preferences_remote_datasource.dart';
import 'package:pennypincher_pro/features/settings/domain/entity/user_preferences_entity.dart';
import 'package:pennypincher_pro/features/settings/domain/repository/preferences_repository.dart';

@LazySingleton(as: PreferencesRepository)
class PreferencesRepositoryImpl implements PreferencesRepository {
  PreferencesRepositoryImpl(this._remote);

  final PreferencesRemoteDataSource _remote;

  @override
  Future<Either<Failure, UserPreferences>> get() => guardFailures(_remote.get);

  @override
  Future<Either<Failure, UserPreferences>> save(UserPreferences preferences) =>
      guardFailures(() => _remote.save(preferences));
}
