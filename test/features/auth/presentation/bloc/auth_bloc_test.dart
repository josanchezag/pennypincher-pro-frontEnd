import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/error/error_codes.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/features/auth/domain/entity/user_entity.dart';
import 'package:pennypincher_pro/features/auth/domain/usecase/restore_session.dart';
import 'package:pennypincher_pro/features/auth/domain/usecase/sign_in_with_dev_login.dart';
import 'package:pennypincher_pro/features/auth/domain/usecase/sign_in_with_google.dart';
import 'package:pennypincher_pro/features/auth/domain/usecase/sign_out.dart';
import 'package:pennypincher_pro/features/auth/domain/usecase/wake_up_server.dart';
import 'package:pennypincher_pro/features/auth/domain/usecase/watch_server_wake_up.dart';
import 'package:pennypincher_pro/features/auth/domain/usecase/watch_session_expiry.dart';
import 'package:pennypincher_pro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pennypincher_pro/features/auth/presentation/bloc/sign_in_messages.dart';

import '../../../../helpers/mocks.dart';

class _MockRestoreSession extends Mock implements RestoreSession {}

class _MockSignInWithGoogle extends Mock implements SignInWithGoogle {}

class _MockSignInWithDevLogin extends Mock implements SignInWithDevLogin {}

class _MockSignOut extends Mock implements SignOut {}

class _MockWatchSessionExpiry extends Mock implements WatchSessionExpiry {}

class _MockWakeUpServer extends Mock implements WakeUpServer {}

class _MockWatchServerWakeUp extends Mock implements WatchServerWakeUp {}

void main() {
  late _MockRestoreSession restoreSession;
  late _MockSignInWithGoogle signInWithGoogle;
  late _MockSignInWithDevLogin signInWithDevLogin;
  late _MockSignOut signOut;
  late _MockWatchSessionExpiry watchSessionExpiry;
  late _MockWakeUpServer wakeUpServer;
  late _MockWatchServerWakeUp watchServerWakeUp;
  late StreamController<void> expirations;
  late StreamController<bool> serverWaits;

  setUp(() {
    restoreSession = _MockRestoreSession();
    signInWithGoogle = _MockSignInWithGoogle();
    signInWithDevLogin = _MockSignInWithDevLogin();
    signOut = _MockSignOut();
    watchSessionExpiry = _MockWatchSessionExpiry();
    expirations = StreamController<void>.broadcast();
    when(watchSessionExpiry.call).thenAnswer((_) => expirations.stream);
    wakeUpServer = _MockWakeUpServer();
    when(wakeUpServer.call).thenAnswer((_) async {});
    watchServerWakeUp = _MockWatchServerWakeUp();
    serverWaits = StreamController<bool>.broadcast();
    when(watchServerWakeUp.call).thenAnswer((_) => serverWaits.stream);
  });

  tearDown(() async {
    await expirations.close();
    await serverWaits.close();
  });

  AuthBloc buildBloc() => AuthBloc(
        restoreSession,
        signInWithGoogle,
        signInWithDevLogin,
        signOut,
        wakeUpServer,
        watchSessionExpiry,
        watchServerWakeUp,
      );

  test('starts unresolved', () {
    expect(buildBloc().state, const AuthInitial());
  });

  group('AuthCheckRequested', () {
    blocTest<AuthBloc, AuthState>(
      'restores the session from the refresh cookie',
      setUp: () =>
          when(restoreSession.call).thenAnswer((_) async => Right(testUser)),
      build: buildBloc,
      act: (bloc) => bloc.add(const AuthCheckRequested()),
      expect: () => [const AuthLoading(), AuthAuthenticated(testUser)],
    );

    blocTest<AuthBloc, AuthState>(
      'signs out when there is no valid refresh cookie',
      setUp: () => when(restoreSession.call).thenAnswer(
        (_) async => const Left(UnauthorizedFailure('Session expired')),
      ),
      build: buildBloc,
      act: (bloc) => bloc.add(const AuthCheckRequested()),
      expect: () => [const AuthLoading(), const AuthUnauthenticated()],
    );

    blocTest<AuthBloc, AuthState>(
      'signs out without an error when the backend is unreachable',
      setUp: () => when(restoreSession.call).thenAnswer(
        (_) async => const Left(NetworkFailure('offline')),
      ),
      build: buildBloc,
      act: (bloc) => bloc.add(const AuthCheckRequested()),
      expect: () => [const AuthLoading(), const AuthUnauthenticated()],
    );

    blocTest<AuthBloc, AuthState>(
      'signs out without an error when the account is no longer allowed',
      setUp: () => when(restoreSession.call).thenAnswer(
        (_) async => const Left(
          ServerFailure('Not allowed', code: ErrorCodes.accountNotAllowed),
        ),
      ),
      build: buildBloc,
      act: (bloc) => bloc.add(const AuthCheckRequested()),
      expect: () => [const AuthLoading(), const AuthUnauthenticated()],
    );

    blocTest<AuthBloc, AuthState>(
      'keeps an active session without calling the backend',
      build: buildBloc,
      seed: () => AuthAuthenticated(testUser),
      act: (bloc) => bloc.add(const AuthCheckRequested()),
      expect: () => const <AuthState>[],
      verify: (_) => verifyNever(restoreSession.call),
    );

    blocTest<AuthBloc, AuthState>(
      'does not start a check while another operation runs',
      build: buildBloc,
      seed: () => const AuthLoading(),
      act: (bloc) => bloc.add(const AuthCheckRequested()),
      expect: () => const <AuthState>[],
      verify: (_) => verifyNever(restoreSession.call),
    );
  });

  group('AuthSignInRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits loading then authenticated with the user',
      setUp: () =>
          when(signInWithGoogle.call).thenAnswer((_) async => Right(testUser)),
      build: buildBloc,
      act: (bloc) => bloc.add(const AuthSignInRequested()),
      expect: () => [const AuthLoading(), AuthAuthenticated(testUser)],
    );

    blocTest<AuthBloc, AuthState>(
      'emits loading then the failure message',
      setUp: () => when(signInWithGoogle.call).thenAnswer(
        (_) async => const Left(
          AuthorizationFailure('Sign-in was cancelled.', code: 'CANCELLED'),
        ),
      ),
      build: buildBloc,
      act: (bloc) => bloc.add(const AuthSignInRequested()),
      expect: () => [
        const AuthLoading(),
        const AuthError('Sign-in was cancelled.'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'explains a refused account instead of the backend message',
      setUp: () => when(signInWithGoogle.call).thenAnswer(
        (_) async => const Left(
          ServerFailure('Not allowed', code: ErrorCodes.accountNotAllowed),
        ),
      ),
      build: buildBloc,
      act: (bloc) => bloc.add(const AuthSignInRequested()),
      expect: () => [
        const AuthLoading(),
        AuthError(SignInMessages.accountNotAllowed),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'explains that sign-ups are closed',
      setUp: () => when(signInWithGoogle.call).thenAnswer(
        (_) async => const Left(
          ServerFailure('Closed', code: ErrorCodes.registrationDisabled),
        ),
      ),
      build: buildBloc,
      act: (bloc) => bloc.add(const AuthSignInRequested()),
      expect: () => [
        const AuthLoading(),
        AuthError(SignInMessages.registrationDisabled),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'ignores a second request while one is in progress',
      setUp: () =>
          when(signInWithGoogle.call).thenAnswer((_) async => Right(testUser)),
      build: buildBloc,
      seed: () => const AuthLoading(),
      act: (bloc) => bloc.add(const AuthSignInRequested()),
      expect: () => const <AuthState>[],
      verify: (_) => verifyNever(signInWithGoogle.call),
    );
  });

  group('AuthDevSignInRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits loading then authenticated with the test user',
      setUp: () => when(signInWithDevLogin.call)
          .thenAnswer((_) async => Right(testUser)),
      build: buildBloc,
      act: (bloc) => bloc.add(const AuthDevSignInRequested()),
      expect: () => [const AuthLoading(), AuthAuthenticated(testUser)],
      verify: (_) => verifyNever(signInWithGoogle.call),
    );

    blocTest<AuthBloc, AuthState>(
      'emits the failure when the backend is unreachable',
      setUp: () => when(signInWithDevLogin.call).thenAnswer(
        (_) async => const Left(NetworkFailure('offline')),
      ),
      build: buildBloc,
      act: (bloc) => bloc.add(const AuthDevSignInRequested()),
      expect: () => [const AuthLoading(), const AuthError('offline')],
    );
  });

  group('AuthSignOutRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits unauthenticated after revoking the session',
      setUp: () =>
          when(signOut.call).thenAnswer((_) async => const Right(unit)),
      build: buildBloc,
      seed: () => AuthAuthenticated(testUser),
      act: (bloc) => bloc.add(const AuthSignOutRequested()),
      expect: () => const [AuthUnauthenticated(signedOut: true)],
      verify: (_) => verify(signOut.call).called(1),
    );

    blocTest<AuthBloc, AuthState>(
      'emits unauthenticated even when the backend call fails',
      setUp: () => when(signOut.call).thenAnswer(
        (_) async => const Left(NetworkFailure('offline')),
      ),
      build: buildBloc,
      seed: () => AuthAuthenticated(testUser),
      act: (bloc) => bloc.add(const AuthSignOutRequested()),
      expect: () => const [AuthUnauthenticated(signedOut: true)],
    );
  });

  group('AuthSessionExpired', () {
    blocTest<AuthBloc, AuthState>(
      'emits unauthenticated when the session can no longer be refreshed',
      build: buildBloc,
      seed: () => AuthAuthenticated(testUser),
      act: (_) => expirations.add(null),
      expect: () => const [AuthUnauthenticated()],
    );

    test('stops listening to expirations once closed', () async {
      final bloc = buildBloc();
      expect(expirations.hasListener, isTrue);

      await bloc.close();

      expect(expirations.hasListener, isFalse);
    });
  });

  group('AuthLoginScreenOpened', () {
    blocTest<AuthBloc, AuthState>(
      'starts waking the server up without changing the state',
      build: buildBloc,
      seed: () => const AuthUnauthenticated(),
      act: (bloc) => bloc.add(const AuthLoginScreenOpened()),
      expect: () => const <AuthState>[],
      verify: (_) => verify(wakeUpServer.call).called(1),
    );

    blocTest<AuthBloc, AuthState>(
      'does not wait for the server to answer',
      setUp: () =>
          when(wakeUpServer.call).thenAnswer((_) => Completer<void>().future),
      build: buildBloc,
      act: (bloc) => bloc
        ..add(const AuthLoginScreenOpened())
        ..add(const AuthSessionExpired()),
      expect: () => const [AuthUnauthenticated()],
    );
  });

  group('server wake-up', () {
    late Completer<Either<Failure, User>> signedIn;

    blocTest<AuthBloc, AuthState>(
      'tells a waiting sign-in that the server is waking up',
      setUp: () {
        signedIn = Completer<Either<Failure, User>>();
        when(signInWithGoogle.call).thenAnswer((_) => signedIn.future);
      },
      build: buildBloc,
      act: (bloc) async {
        bloc.add(const AuthSignInRequested());
        await pumpEventQueue();
        serverWaits.add(true);
        await pumpEventQueue();
        serverWaits.add(false);
        await pumpEventQueue();
        signedIn.complete(Right(testUser));
      },
      expect: () => [
        const AuthLoading(),
        const AuthLoading(wakingServer: true),
        const AuthLoading(),
        AuthAuthenticated(testUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'tells a waiting session check that the server is waking up',
      setUp: () => when(restoreSession.call)
          .thenAnswer((_) => Completer<Either<Failure, User>>().future),
      build: buildBloc,
      act: (bloc) async {
        bloc.add(const AuthCheckRequested());
        await pumpEventQueue();
        serverWaits.add(true);
      },
      expect: () => const [
        AuthLoading(),
        AuthLoading(wakingServer: true),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'ignores a wait reported when nothing is in progress',
      build: buildBloc,
      seed: () => AuthAuthenticated(testUser),
      act: (_) => serverWaits.add(true),
      expect: () => const <AuthState>[],
    );

    blocTest<AuthBloc, AuthState>(
      'still ignores a second sign-in while the server wakes up',
      build: buildBloc,
      seed: () => const AuthLoading(wakingServer: true),
      act: (bloc) => bloc.add(const AuthSignInRequested()),
      expect: () => const <AuthState>[],
      verify: (_) => verifyNever(signInWithGoogle.call),
    );

    test('stops listening to the server wake-up once closed', () async {
      final bloc = buildBloc();
      expect(serverWaits.hasListener, isTrue);

      await bloc.close();

      expect(serverWaits.hasListener, isFalse);
    });
  });
}
