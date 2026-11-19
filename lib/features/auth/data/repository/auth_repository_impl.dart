import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/auth/token_service.dart';
import 'package:pennypincher_pro/core/constants/app_constants.dart';
import 'package:pennypincher_pro/core/error/app_exception.dart';
import 'package:pennypincher_pro/core/error/error_codes.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/core/error/failure_mapper.dart';
import 'package:pennypincher_pro/core/network/server_wake_up.dart';
import 'package:pennypincher_pro/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:pennypincher_pro/features/auth/data/datasource/google_auth_datasource.dart';
import 'package:pennypincher_pro/features/auth/data/model/auth_session_model.dart';
import 'package:pennypincher_pro/features/auth/data/oauth/oauth_exception.dart';
import 'package:pennypincher_pro/features/auth/domain/entity/user_entity.dart';
import 'package:pennypincher_pro/features/auth/domain/repository/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._google, this._remote, this._tokens, this._server);

  final GoogleAuthDataSource _google;
  final AuthRemoteDataSource _remote;
  final TokenService _tokens;
  final ServerWakeUp _server;
  final StreamController<bool> _waitingForServer =
      StreamController<bool>.broadcast();

  /// The server wakes up while the user is in the Google flow, which opens
  /// right away: browsers only allow its popup straight after the click.
  /// The code is exchanged once the server is up, and never twice because
  /// Google codes are single-use.
  @override
  Future<Either<Failure, User>> signInWithGoogle() {
    final serverAwake = _server.wakeUp();
    return _openSession(() async {
      final authorization = await _google.authorize();
      await _awaitServer(serverAwake);
      return _remote.exchangeGoogleCode(authorization);
    });
  }

  @override
  Future<Either<Failure, User>> signInWithDevLogin() => _openSession(() async {
        await _awaitServer(_server.wakeUp());
        return _remote.devLogin();
      });

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
  Future<Either<Failure, User>> refreshSession() => _openSession(() async {
        await _awaitServer(_server.wakeUp());
        return _refreshRetryingSuperseded();
      });

  @override
  Stream<void> get sessionExpirations => _tokens.sessionExpired;

  @override
  Future<void> wakeUpServer() => _server.wakeUp();

  @override
  Stream<bool> get waitingForServer => _waitingForServer.stream;

  /// Waits for [serverAwake], reporting on [waitingForServer] when the wait
  /// lasts longer than [AppConstants.serverWakeUpNoticeDelay].
  Future<void> _awaitServer(Future<void> serverAwake) async {
    var noticeShown = false;
    final notice = Timer(AppConstants.serverWakeUpNoticeDelay, () {
      noticeShown = true;
      _waitingForServer.add(true);
    });
    try {
      await serverAwake;
    } finally {
      notice.cancel();
      if (noticeShown) {
        _waitingForServer.add(false);
      }
    }
  }

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
