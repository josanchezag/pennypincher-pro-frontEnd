part of 'auth_bloc.dart';

/// Session state exposed to the UI and the router.
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => const [];
}

/// The session has not been resolved yet.
final class AuthInitial extends AuthState {
  const AuthInitial();
}

/// A sign-in, sign-out or session check is in progress.
final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.user);

  final User user;

  @override
  List<Object?> get props => [user];
}

final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated({this.signedOut = false});

  /// The user signed out on purpose, so the current location is not kept
  /// for after the next sign-in.
  final bool signedOut;

  @override
  List<Object?> get props => [signedOut];
}

/// The last sign-in attempt failed; the user is not signed in.
final class AuthError extends AuthState {
  const AuthError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
