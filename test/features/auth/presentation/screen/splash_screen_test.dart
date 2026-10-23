import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/constants/app_constants.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/widgets/placeholder_screen.dart';
import 'package:pennypincher_pro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pennypincher_pro/features/auth/presentation/screen/login_screen.dart';
import 'package:pennypincher_pro/features/auth/presentation/screen/splash_screen.dart';
import 'package:pennypincher_pro/features/auth/presentation/widget/brand_header.dart';

import '../../../../helpers/mocks.dart';
import '../../../../helpers/pump_app.dart';

const Duration _justBefore = Duration(milliseconds: 1);
const Duration _halfSecond = Duration(milliseconds: 500);

Finder _screenTitled(AppRoute route) => find.descendant(
      of: find.byType(PlaceholderScreen),
      matching: find.text(route.title),
    );

void main() {
  late StreamController<AuthState> states;

  setUp(() => states = StreamController<AuthState>.broadcast());
  tearDown(() => states.close());

  Future<MockAuthBloc> pumpSplash(
    WidgetTester tester, {
    required AuthState state,
    String location = '/',
  }) async {
    final bloc = mockAuthBloc(state, stream: states.stream);
    await tester.pumpApp(location: location, authBloc: bloc, settle: false);
    return bloc;
  }

  Future<void> settleAfter(WidgetTester tester, Duration elapsed) async {
    await tester.pump(elapsed);
    await tester.pumpAndSettle();
  }

  testWidgets('shows the logo, brand and progress', (tester) async {
    final semantics = tester.ensureSemantics();
    await pumpSplash(tester, state: const AuthLoading());

    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.byIcon(BrandHeader.logo), findsOneWidget);
    expect(find.text(AppConstants.appName), findsOneWidget);
    expect(find.text(AppConstants.tagline), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.bySemanticsLabel(SplashScreen.progressLabel), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('starts the session check when the app starts', (tester) async {
    final bloc = await pumpSplash(tester, state: const AuthInitial());

    verify(() => bloc.add(const AuthCheckRequested())).called(1);
  });

  testWidgets('stays for the minimum time even if the session is ready',
      (tester) async {
    await pumpSplash(tester, state: AuthAuthenticated(testUser));

    await tester.pump(AppConstants.splashMinDuration - _justBefore);
    expect(find.byType(SplashScreen), findsOneWidget);

    await settleAfter(tester, _justBefore);
    expect(find.byType(SplashScreen), findsNothing);
    expect(_screenTitled(AppRoute.dashboard), findsOneWidget);
  });

  testWidgets('opens the dashboard when the session is restored later',
      (tester) async {
    await pumpSplash(tester, state: const AuthLoading());
    await tester.pump(AppConstants.splashMinDuration);
    expect(find.byType(SplashScreen), findsOneWidget);

    states.add(AuthAuthenticated(testUser));
    await settleAfter(tester, _halfSecond ~/ 2);

    expect(_screenTitled(AppRoute.dashboard), findsOneWidget);
  });

  testWidgets('opens the login screen when there is no session',
      (tester) async {
    await pumpSplash(tester, state: const AuthLoading());

    states.add(const AuthUnauthenticated());
    await settleAfter(tester, AppConstants.splashMinDuration);

    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('opens the login screen when the check fails', (tester) async {
    await pumpSplash(tester, state: const AuthError('failed'));

    await settleAfter(tester, AppConstants.splashMinDuration);

    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets(
      'moves on to login after the maximum time and follows a late '
      'restore', (tester) async {
    await pumpSplash(tester, state: const AuthLoading());

    await tester.pump(AppConstants.splashMaxDuration);
    await tester.pump(_halfSecond);
    expect(find.byType(SplashScreen), findsNothing);
    expect(find.byType(LoginScreen), findsOneWidget);

    states.add(AuthAuthenticated(testUser));
    await tester.pumpAndSettle();
    expect(_screenTitled(AppRoute.dashboard), findsOneWidget);
  });

  testWidgets('returns to the deep link that was requested', (tester) async {
    await pumpSplash(
      tester,
      state: const AuthInitial(),
      location: AppRoute.settingsProfile.path,
    );
    expect(find.byType(SplashScreen), findsOneWidget);

    states.add(AuthAuthenticated(testUser));
    await settleAfter(tester, AppConstants.splashMinDuration);

    expect(_screenTitled(AppRoute.settingsProfile), findsOneWidget);
  });
}
