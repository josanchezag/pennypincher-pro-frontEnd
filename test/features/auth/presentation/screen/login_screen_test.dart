import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/constants/app_constants.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pennypincher_pro/features/auth/presentation/screen/login_screen.dart';
import 'package:pennypincher_pro/features/auth/presentation/widget/google_sign_in_button.dart';
import 'package:pennypincher_pro/features/dashboard/presentation/screen/dashboard_screen.dart';

import '../../../../helpers/load_fonts.dart';
import '../../../../helpers/mocks.dart';
import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_config.dart';

Finder get _googleButton =>
    find.byWidgetPredicate((widget) => widget is FilledButton);

Finder get _devLoginButton => find.byKey(LoginScreen.devLoginKey);

FilledButton _button(WidgetTester tester) => tester.widget(_googleButton);

void main() {
  late StreamController<AuthState> states;

  setUpAll(loadAppFonts);

  setUp(() => states = StreamController<AuthState>.broadcast());
  tearDown(() => states.close());

  Future<MockAuthBloc> pumpLogin(
    WidgetTester tester, {
    AuthState state = const AuthUnauthenticated(),
    Size size = TestViewports.desktop,
    bool devLogin = false,
  }) async {
    final bloc = mockAuthBloc(state, stream: states.stream);
    await tester.pumpApp(
      location: AppRoute.login.path,
      size: size,
      authBloc: bloc,
      config: devLogin ? TestConfigs.withDevLogin : TestConfigs.googleOnly,
      settle: state is! AuthLoading,
    );
    await tester.pump();
    return bloc;
  }

  testWidgets('shows the brand, tagline and Google button', (tester) async {
    await pumpLogin(tester);

    expect(find.text(AppConstants.appName), findsOneWidget);
    expect(find.text(AppConstants.tagline), findsOneWidget);
    expect(find.text(GoogleSignInButton.label), findsOneWidget);
    expect(_button(tester).onPressed, isNotNull);
  });

  testWidgets('starts the Google sign-in when the button is pressed',
      (tester) async {
    final bloc = await pumpLogin(tester);

    await tester.tap(_googleButton);

    verify(() => bloc.add(const AuthSignInRequested())).called(1);
  });

  testWidgets('disables the button and shows progress while loading',
      (tester) async {
    await pumpLogin(tester, state: const AuthLoading());

    expect(_button(tester).onPressed, isNull);
    expect(
      find.descendant(
        of: _googleButton,
        matching: find.byType(CircularProgressIndicator),
      ),
      findsOneWidget,
    );
  });

  testWidgets('shows the error message in a snack bar', (tester) async {
    await pumpLogin(tester);

    states.add(const AuthError('Sign-in was cancelled.'));
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Sign-in was cancelled.'), findsOneWidget);
    expect(_button(tester).onPressed, isNotNull);
  });

  testWidgets('opens the dashboard once signed in', (tester) async {
    await pumpLogin(tester);

    states.add(AuthAuthenticated(testUser));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsNothing);
    expect(find.byType(DashboardScreen), findsOneWidget);
  });

  testWidgets('uses a centered card on desktop', (tester) async {
    await pumpLogin(tester);

    final card = tester.getRect(find.byKey(LoginScreen.cardKey));
    expect(card.width, LoginScreen.cardMaxWidth);
    expect(card.center.dx, TestViewports.desktop.width / 2);
    expect(tester.takeException(), isNull);
  });

  testWidgets('uses a centered card on tablet', (tester) async {
    await pumpLogin(tester, size: TestViewports.tablet);

    expect(find.byKey(LoginScreen.cardKey), findsOneWidget);
  });

  testWidgets('fills the screen without a card on mobile', (tester) async {
    await pumpLogin(tester, size: TestViewports.mobile, devLogin: true);

    expect(find.byKey(LoginScreen.cardKey), findsNothing);
    expect(
      tester.getSize(_googleButton).width,
      greaterThan(TestViewports.mobile.width / 2),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('hides the dev login button by default', (tester) async {
    await pumpLogin(tester);

    expect(_devLoginButton, findsNothing);
  });

  testWidgets('offers dev login when the flag is enabled', (tester) async {
    final bloc = await pumpLogin(tester, devLogin: true);

    expect(find.text(LoginScreen.devLoginLabel), findsOneWidget);
    await tester.tap(_devLoginButton);

    verify(() => bloc.add(const AuthDevSignInRequested())).called(1);
  });

  testWidgets('disables dev login while loading', (tester) async {
    await pumpLogin(tester, state: const AuthLoading(), devLogin: true);

    expect(tester.widget<OutlinedButton>(_devLoginButton).onPressed, isNull);
  });

  testWidgets('disables Google sign-in when no client id is configured',
      (tester) async {
    await tester.pumpApp(
      location: AppRoute.login.path,
      authBloc: mockAuthBloc(const AuthUnauthenticated()),
      config: TestConfigs.unconfigured,
    );

    expect(_button(tester).onPressed, isNull);
    expect(find.text(LoginScreen.notConfiguredMessage), findsOneWidget);
  });
}
