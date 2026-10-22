part of 'auth_bloc.dart';

/// Inputs of [AuthBloc].
sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => const [];
}

/// The user pressed "Sign in with Google".
final class AuthSignInRequested extends AuthEvent {
  const AuthSignInRequested();
}

/// The user pressed "Dev login" (only offered with `DEV_LOGIN=true`).
final class AuthDevSignInRequested extends AuthEvent {
  const AuthDevSignInRequested();
}

/// The user asked to end the session.
final class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}

/// The session expired and could not be refreshed. Raised by the bloc
/// itself from the session expiry notifications.
final class AuthSessionExpired extends AuthEvent {
  const AuthSessionExpired();
}
