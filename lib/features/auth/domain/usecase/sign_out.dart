import 'package:dartz/dartz.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/features/auth/domain/repository/auth_repository.dart';

/// Ends the current session.
class SignOut {
  const SignOut(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, Unit>> call() => _repository.signOut();
}
