import 'package:dartz/dartz.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/features/auth/domain/entity/user_entity.dart';
import 'package:pennypincher_pro/features/auth/domain/repository/auth_repository.dart';

/// Signs the user in with their Google account.
class SignInWithGoogle {
  const SignInWithGoogle(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, User>> call() => _repository.signInWithGoogle();
}
