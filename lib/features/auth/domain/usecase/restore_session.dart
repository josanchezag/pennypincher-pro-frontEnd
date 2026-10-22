import 'package:dartz/dartz.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/features/auth/domain/entity/user_entity.dart';
import 'package:pennypincher_pro/features/auth/domain/repository/auth_repository.dart';

/// Restores the session on startup with a silent refresh: the access token
/// lives only in memory, so the httpOnly refresh cookie is the only thing
/// that survives a page reload.
class RestoreSession {
  const RestoreSession(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, User>> call() => _repository.refreshSession();
}
