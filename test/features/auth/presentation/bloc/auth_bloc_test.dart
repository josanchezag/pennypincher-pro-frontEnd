import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/features/auth/domain/usecase/sign_in_with_dev_login.dart';
import 'package:pennypincher_pro/features/auth/domain/usecase/sign_in_with_google.dart';
import 'package:pennypincher_pro/features/auth/domain/usecase/sign_out.dart';
import 'package:pennypincher_pro/features/auth/presentation/bloc/auth_bloc.dart';

import '../../../../helpers/mocks.dart';

class _MockSignInWithGoogle extends Mock implements SignInWithGoogle {}

class _MockSignInWithDevLogin extends Mock implements SignInWithDevLogin {}

class _MockSignOut extends Mock implements SignOut {}

void main() {
  late _MockSignInWithGoogle signInWithGoogle;
  late _MockSignInWithDevLogin signInWithDevLogin;
  late _MockSignOut signOut;

  setUp(() {
    signInWithGoogle = _MockSignInWithGoogle();
    signInWithDevLogin = _MockSignInWithDevLogin();
    signOut = _MockSignOut();
  });

  AuthBloc buildBloc() =>
      AuthBloc(signInWithGoogle, signInWithDevLogin, signOut);

  test('starts unresolved', () {
    expect(buildBloc().state, const AuthInitial());
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
      expect: () => [const AuthLoading(), const AuthUnauthenticated()],
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
      expect: () => [const AuthLoading(), const AuthUnauthenticated()],
    );
  });
}
