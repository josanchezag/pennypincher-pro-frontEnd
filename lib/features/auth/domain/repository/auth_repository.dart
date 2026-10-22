import 'package:dartz/dartz.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/features/auth/domain/entity/user_entity.dart';

/// Session management against the identity provider and the backend.
abstract interface class AuthRepository {
  /// Runs the Google authorization code + PKCE flow and opens a session.
  Future<Either<Failure, User>> signInWithGoogle();

  /// Opens a session for the local test user (backend `local` profile).
  Future<Either<Failure, User>> signInWithDevLogin();

  /// Revokes the refresh cookie and forgets the access token. The local
  /// session is always cleared, even when the backend call fails.
  Future<Either<Failure, Unit>> signOut();

  /// Renews the session with the refresh cookie.
  Future<Either<Failure, User>> refreshSession();

  /// Emits when the session expired and could not be renewed.
  Stream<void> get sessionExpirations;
}
