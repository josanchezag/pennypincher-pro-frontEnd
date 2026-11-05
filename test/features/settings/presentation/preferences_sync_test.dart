import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/router/app_destination.dart';
import 'package:pennypincher_pro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pennypincher_pro/features/auth/presentation/screen/login_screen.dart';

import '../../../helpers/l10n.dart';
import '../../../helpers/mocks.dart';
import '../../../helpers/pump_app.dart';
import '../../../helpers/settings_fakes.dart';

void main() {
  testWidgets('applies the account language when the user signs in',
      (tester) async {
    final states = StreamController<AuthState>.broadcast();
    addTearDown(states.close);
    final account = FakePreferencesRepository(savedPreferences('en'));
    await tester.pumpApp(
      location: '/login',
      locale: AppLocales.spanish,
      authBloc:
          mockAuthBloc(const AuthUnauthenticated(), stream: states.stream),
      preferences: account,
    );
    expect(account.loads, 0);

    states.add(AuthAuthenticated(testUser));
    await tester.pumpAndSettle();

    expect(account.loads, 1);
    expect(find.text(AppDestination.netWorth.label(l10n)), findsWidgets);
    expect(find.text(AppDestination.netWorth.label(l10nEs)), findsNothing);
  });

  testWidgets('loads the preferences of a session restored at start',
      (tester) async {
    final account = FakePreferencesRepository(savedPreferences('es'));

    await tester.pumpApp(preferences: account);

    expect(account.loads, 1);
    expect(find.text(AppDestination.netWorth.label(l10nEs)), findsWidgets);
  });

  testWidgets('keeps the language after sign-out and loads again on sign-in',
      (tester) async {
    final states = StreamController<AuthState>.broadcast();
    addTearDown(states.close);
    final account = FakePreferencesRepository(savedPreferences('en'));
    await tester.pumpApp(
      authBloc:
          mockAuthBloc(AuthAuthenticated(testUser), stream: states.stream),
      preferences: account,
    );

    states.add(const AuthUnauthenticated(signedOut: true));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    states.add(AuthAuthenticated(testUser));
    await tester.pumpAndSettle();

    expect(account.loads, 2);
  });
}
