import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/auth/token_service.dart';
import 'package:pennypincher_pro/core/error/app_exception.dart';
import 'package:pennypincher_pro/core/error/error_codes.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:pennypincher_pro/features/auth/data/datasource/google_auth_datasource.dart';
import 'package:pennypincher_pro/features/auth/data/model/auth_session_model.dart';
import 'package:pennypincher_pro/features/auth/data/model/google_authorization.dart';
import 'package:pennypincher_pro/features/auth/data/oauth/oauth_constants.dart';
import 'package:pennypincher_pro/features/auth/data/oauth/oauth_exception.dart';
import 'package:pennypincher_pro/features/auth/data/repository/auth_repository_impl.dart';
import 'package:pennypincher_pro/features/auth/domain/usecase/restore_session.dart';

import '../../../../helpers/fake_http_adapter.dart';
import '../../../../helpers/mocks.dart';

class _MockGoogleAuthDataSource extends Mock implements GoogleAuthDataSource {}

class _MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

const GoogleAuthorization _authorization = GoogleAuthorization(
  code: 'auth-code',
  redirectUri: 'http://localhost:3000/auth.html',
  codeVerifier: 'verifier',
);

const AppException _unauthorized = AppException(
  code: 'UNAUTHORIZED',
  message: 'Session expired',
  statusCode: 401,
);

const AppException _superseded = AppException(
  code: ErrorCodes.refreshSuperseded,
  message: 'Refresh token superseded',
  statusCode: 401,
);

void main() {
  late _MockGoogleAuthDataSource google;
  late _MockAuthRemoteDataSource remote;
  late TokenService tokens;
  late AuthRepositoryImpl repository;
  final session = AuthSessionModel.fromJson(sessionJson());

  setUpAll(() => registerFallbackValue(_authorization));

  setUp(() {
    google = _MockGoogleAuthDataSource();
    remote = _MockAuthRemoteDataSource();
    tokens = TokenService();
    repository = AuthRepositoryImpl(google, remote, tokens);
  });

  group('signInWithGoogle', () {
    test('exchanges the Google code and keeps the token in memory', () async {
      when(google.authorize).thenAnswer((_) async => _authorization);
      when(() => remote.exchangeGoogleCode(_authorization))
          .thenAnswer((_) async => session);

      final result = await repository.signInWithGoogle();

      expect(result, Right<Failure, Object>(testUser));
      expect(tokens.accessToken, 'access-1');
    });

    test('maps an interrupted Google flow to an authorization failure',
        () async {
      when(google.authorize).thenThrow(const OAuthException.cancelled());

      final result = await repository.signInWithGoogle();

      final failure = result.fold((f) => f, (_) => null);
      expect(
        failure,
        isA<AuthorizationFailure>()
            .having((f) => f.code, 'code', OAuthErrorCodes.cancelled)
            .having((f) => f.message, 'message', OAuthMessages.cancelled),
      );
      verifyNever(() => remote.exchangeGoogleCode(any()));
      expect(tokens.hasToken, isFalse);
    });

    test('maps a rejected code to an unauthorized failure', () async {
      when(google.authorize).thenAnswer((_) async => _authorization);
      when(() => remote.exchangeGoogleCode(any())).thenThrow(_unauthorized);

      final result = await repository.signInWithGoogle();

      expect(result.fold((f) => f, (_) => null), isA<UnauthorizedFailure>());
      expect(tokens.hasToken, isFalse);
    });
  });

  group('signInWithDevLogin', () {
    test('opens a session for the test user', () async {
      when(remote.devLogin).thenAnswer((_) async => session);

      final result = await repository.signInWithDevLogin();

      expect(result, Right<Failure, Object>(testUser));
      expect(tokens.accessToken, 'access-1');
    });

    test('maps an unreachable backend to a network failure', () async {
      when(remote.devLogin).thenThrow(
        const AppException(
          code: ErrorCodes.networkError,
          message: ErrorMessages.network,
        ),
      );

      final result = await repository.signInWithDevLogin();

      expect(result.fold((f) => f, (_) => null), isA<NetworkFailure>());
    });
  });

  group('signOut', () {
    setUp(() => tokens.save('access-1'));

    test('revokes the session and forgets the token', () async {
      when(remote.logout).thenAnswer((_) async {});

      final result = await repository.signOut();

      expect(result, const Right<Failure, Unit>(unit));
      expect(tokens.hasToken, isFalse);
    });

    test('forgets the token even when the backend call fails', () async {
      when(remote.logout).thenThrow(
        const AppException(
          code: 'INTERNAL_ERROR',
          message: 'boom',
          statusCode: 500,
        ),
      );

      final result = await repository.signOut();

      expect(result.fold((f) => f, (_) => null), isA<ServerFailure>());
      expect(tokens.hasToken, isFalse);
    });
  });

  group('refreshSession', () {
    test('stores the renewed token and returns the user', () async {
      when(remote.refresh).thenAnswer((_) async => session);

      final result = await repository.refreshSession();

      expect(result, Right<Failure, Object>(testUser));
      expect(tokens.accessToken, 'access-1');
    });

    test('retries once when another tab refreshed first', () async {
      var calls = 0;
      when(remote.refresh).thenAnswer((_) async {
        calls++;
        if (calls == 1) {
          throw _superseded;
        }
        return session;
      });

      final result = await repository.refreshSession();

      expect(result, Right<Failure, Object>(testUser));
      expect(calls, 2);
      expect(tokens.accessToken, 'access-1');
    });

    test('keeps the session when the refresh stays superseded', () async {
      tokens.save('access-old');
      when(remote.refresh).thenThrow(_superseded);

      final result = await repository.refreshSession();

      expect(
        result.fold((f) => f, (_) => null),
        isA<ServerFailure>()
            .having((f) => f.code, 'code', ErrorCodes.refreshSuperseded),
      );
      verify(remote.refresh).called(2);
      expect(tokens.accessToken, 'access-old');
    });

    test('maps a rejected cookie to an unauthorized failure', () async {
      when(remote.refresh).thenThrow(_unauthorized);

      final result = await repository.refreshSession();

      expect(result.fold((f) => f, (_) => null), isA<UnauthorizedFailure>());
    });
  });

  test('restores the session on startup after a superseded refresh', () async {
    var calls = 0;
    when(remote.refresh).thenAnswer((_) async {
      calls++;
      return calls == 1 ? throw _superseded : session;
    });

    final result = await RestoreSession(repository)();

    expect(result, Right<Failure, Object>(testUser));
    expect(tokens.accessToken, 'access-1');
  });

  test('exposes the session expirations of the token service', () async {
    final expired = expectLater(repository.sessionExpirations, emits(null));

    tokens.expireSession();

    await expired;
  });
}
