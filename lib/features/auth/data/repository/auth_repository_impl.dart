import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/auth/token_service.dart';
import 'package:pennypincher_pro/core/constants/app_constants.dart';
import 'package:pennypincher_pro/core/error/app_exception.dart';
import 'package:pennypincher_pro/core/error/error_codes.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/core/error/failure_mapper.dart';
import 'package:pennypincher_pro/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:pennypincher_pro/features/auth/data/datasource/google_auth_datasource.dart';
import 'package:pennypincher_pro/features/auth/data/model/auth_session_model.dart';
import 'package:pennypincher_pro/features/auth/data/oauth/oauth_exception.dart';
import 'package:pennypincher_pro/features/auth/domain/entity/user_entity.dart';
import 'package:pennypincher_pro/features/auth/domain/repository/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._google, this._remote, this._tokens);

  final GoogleAuthDataSource _google;
  final AuthRemoteDataSource _remote;
  final TokenService _tokens;

  @override
  Future<Either<Failure, User>> signInWithGoogle() => _openSession(
        () async => _remote.exchangeGoogleCode(await _google.authorize()),
      );

  @override
  Future<Either<Failure, User>> signInWithDevLogin() =>
      _openSession(_remote.devLogin);

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await _remote.logout();
      return const Right(unit);
    } on AppException catch (exception) {
      return Left(FailureMapper.fromException(exception));
    } finally {
      _tokens.clear();
    }
  }

  @override
  Future<Either<Failure, User>> refreshSession() =>
      _openSession(_refreshRetryingSuperseded);

  @override
  Stream<void> get sessionExpirations => _tokens.sessionExpired;

  /// Repeats the refresh once when a concurrent refresh in another tab won.
  Future<AuthSessionModel> _refreshRetryingSuperseded() async {
    try {
      return await _remote.refresh();
    } on AppException catch (exception) {
      if (exception.code != ErrorCodes.refreshSuperseded) {
        rethrow;
      }
      await Future<void>.delayed(AppConstants.refreshSupersededRetryDelay);
      return _remote.refresh();
    }
  }

  Future<Either<Failure, User>> _openSession(
    Future<AuthSessionModel> Function() request,
  ) async {
    try {
      final session = await request();
      _tokens.save(session.accessToken);
      return Right(session.user.toEntity());
    } on OAuthException catch (exception) {
      return Left(
        AuthorizationFailure(exception.message, code: exception.code),
      );
    } on AppException catch (exception) {
      return Left(FailureMapper.fromException(exception));
    }
  }
}
