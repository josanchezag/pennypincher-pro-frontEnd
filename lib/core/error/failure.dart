/// Failures returned by domain use cases inside `Either<Failure, T>`.
sealed class Failure {
  const Failure(this.message);

  final String message;
}

/// The backend answered with an error envelope.
final class ServerFailure extends Failure {
  const ServerFailure(super.message, {required this.code});

  final String code;
}

/// The request never reached the backend or timed out.
final class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// The session is missing or could not be refreshed.
final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.message);
}

/// The requested resource does not exist for the current user.
final class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

/// The sign-in flow with the identity provider did not complete
/// (cancelled, misconfigured or tampered with).
final class AuthorizationFailure extends Failure {
  const AuthorizationFailure(super.message, {required this.code});

  final String code;
}
