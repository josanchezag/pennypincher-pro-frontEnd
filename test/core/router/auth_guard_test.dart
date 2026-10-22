import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/router/auth_guard.dart';
import 'package:pennypincher_pro/features/auth/presentation/bloc/auth_bloc.dart';

import '../../helpers/mocks.dart';

String? _redirect(AuthState state, String location) =>
    AuthGuard.redirect(state, Uri.parse(location));

void main() {
  final signedIn = AuthAuthenticated(testUser);
  const resolving = <AuthState>[AuthInitial(), AuthLoading()];
  const signedOut = <AuthState>[AuthUnauthenticated(), AuthError('failed')];

  group('while the session check runs', () {
    for (final state in resolving) {
      test('sends ${state.runtimeType} on a protected route to the splash', () {
        expect(
          _redirect(state, '/budget/income'),
          '/?from=%2Fbudget%2Fincome',
        );
      });
    }
  });

  group('without a session', () {
    for (final state in signedOut) {
      test('sends ${state.runtimeType} on a protected route to login', () {
        expect(
          _redirect(state, '/budget/income'),
          '/login?from=%2Fbudget%2Fincome',
        );
      });
    }

    for (final state in [...resolving, ...signedOut]) {
      test('keeps ${state.runtimeType} on the login screen', () {
        expect(_redirect(state, '/login'), isNull);
      });
    }
  });

  test('sends a signed-out user to login without keeping the location', () {
    expect(
      _redirect(const AuthUnauthenticated(signedOut: true), '/budget'),
      '/login',
    );
  });

  group('with a session', () {
    test('stays on protected routes', () {
      expect(_redirect(signedIn, '/net-worth/assets'), isNull);
    });

    test('does not follow a backslash location after signing in', () {
      expect(_redirect(signedIn, '/login?from=%2F%5Cevil.com'), '/dashboard');
    });

    test('leaves the login screen for the dashboard', () {
      expect(_redirect(signedIn, '/login'), '/dashboard');
    });

    test('leaves the login screen for the location requested before', () {
      expect(
        _redirect(signedIn, '/login?from=%2Fgoals%2Fg1%2Fprojection'),
        '/goals/g1/projection',
      );
    });
  });

  test('never redirects away from the splash screen', () {
    expect(_redirect(const AuthUnauthenticated(), '/'), isNull);
    expect(_redirect(signedIn, '/'), isNull);
  });

  test('loginFor keeps the requested location', () {
    expect(AuthGuard.loginFor(null), '/login');
    expect(AuthGuard.loginFor('/goals'), '/login?from=%2Fgoals');
  });

  group('targetAfterSignIn', () {
    for (final unsafe in [
      r'/\evil.com',
      '/%5Cevil.com',
      '/%5cevil.com',
      'https://evil.com',
      '//evil.com',
      'javascript:alert(1)',
      '/does-not-exist',
      '/dashboard/',
      'dashboard',
      '',
    ]) {
      test('falls back to the dashboard for "$unsafe"', () {
        expect(AuthGuard.targetAfterSignIn(unsafe), '/dashboard');
      });
    }

    test('ignores external, missing and entry locations', () {
      expect(AuthGuard.targetAfterSignIn(null), '/dashboard');
      expect(AuthGuard.targetAfterSignIn('https://evil.test'), '/dashboard');
      expect(AuthGuard.targetAfterSignIn('//evil.test/x'), '/dashboard');
      expect(AuthGuard.targetAfterSignIn('/login?from=/x'), '/dashboard');
      expect(AuthGuard.targetAfterSignIn('/'), '/dashboard');
    });

    test('keeps a parameterized in-app location', () {
      expect(
        AuthGuard.targetAfterSignIn('/goals/g1/projection'),
        '/goals/g1/projection',
      );
    });

    test('keeps in-app locations with their query', () {
      expect(
        AuthGuard.targetAfterSignIn('/expenses/loans?page=2'),
        '/expenses/loans?page=2',
      );
    });
  });
}
