import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/features/auth/domain/repository/auth_repository.dart';
import 'package:pennypincher_pro/features/auth/domain/usecase/restore_session.dart';
import 'package:pennypincher_pro/features/auth/domain/usecase/sign_in_with_dev_login.dart';
import 'package:pennypincher_pro/features/auth/domain/usecase/sign_in_with_google.dart';
import 'package:pennypincher_pro/features/auth/domain/usecase/sign_out.dart';
import 'package:pennypincher_pro/features/auth/domain/usecase/watch_session_expiry.dart';

/// Registers the auth use cases, keeping the domain layer free of
/// dependency injection annotations.
@module
abstract class AuthModule {
  @injectable
  SignInWithGoogle signInWithGoogle(AuthRepository repository) =>
      SignInWithGoogle(repository);

  @injectable
  SignInWithDevLogin signInWithDevLogin(AuthRepository repository) =>
      SignInWithDevLogin(repository);

  @injectable
  SignOut signOut(AuthRepository repository) => SignOut(repository);

  @injectable
  RestoreSession restoreSession(AuthRepository repository) =>
      RestoreSession(repository);

  @injectable
  WatchSessionExpiry watchSessionExpiry(AuthRepository repository) =>
      WatchSessionExpiry(repository);
}
