import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/core/layout/app_shell.dart';
import 'package:pennypincher_pro/core/router/app_destination.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/widgets/placeholder_screen.dart';
import 'package:pennypincher_pro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pennypincher_pro/features/auth/presentation/screen/login_screen.dart';
import 'package:pennypincher_pro/features/auth/presentation/screen/splash_screen.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/net_worth_pages.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/screen/assets_screen.dart';

import '../../helpers/mocks.dart';
import '../../helpers/net_worth_mocks.dart';
import '../../helpers/pump_app.dart';

String _concretePath(AppRoute route) =>
    route.path.replaceFirst(':${AppRoute.goalIdParam}', 'goal-1');

void main() {
  group('AppRoute', () {
    test('declares the navigation structure of the design system', () {
      final paths = AppRoute.values.map((route) => route.path).toSet();

      expect(
        paths,
        containsAll(<String>[
          '/dashboard',
          '/net-worth',
          '/net-worth/assets',
          '/net-worth/liabilities',
          '/budget',
          '/budget/overview',
          '/budget/income',
          '/expenses',
          '/expenses/credit-cards',
          '/expenses/loans',
          '/expenses/fixed',
          '/expenses/variable',
          '/expenses/savings',
          '/goals',
          '/goals/:goalId/projection',
          '/settings',
          '/settings/profile',
        ]),
      );
      expect(paths, hasLength(AppRoute.values.length));
    });
  });

  group('AppRoute.matching', () {
    test('matches static and parameterized paths exactly', () {
      expect(AppRoute.matching('/budget/income'), AppRoute.budgetIncome);
      expect(
        AppRoute.matching('/goals/g1/projection'),
        AppRoute.goalProjection,
      );
      expect(AppRoute.matching('/'), AppRoute.splash);
    });

    test('rejects unknown, partial and relative paths', () {
      expect(AppRoute.matching('/budget/unknown'), isNull);
      expect(AppRoute.matching('/goals//projection'), isNull);
      expect(AppRoute.matching('/budget/'), isNull);
      expect(AppRoute.matching('budget'), isNull);
    });
  });

  group('AppDestination.indexForLocation', () {
    test('selects the section that owns a nested location', () {
      expect(
        AppDestination.indexForLocation('/expenses/loans'),
        AppDestination.expenses.index,
      );
      expect(
        AppDestination.indexForLocation('/goals/abc/projection'),
        AppDestination.goals.index,
      );
    });

    test('keeps settings out of the mobile bottom bar', () {
      expect(AppDestination.mobile, isNot(contains(AppDestination.settings)));
      expect(
        AppDestination.mobile,
        hasLength(AppDestination.values.length - 1),
      );
    });

    test('falls back to the dashboard for unknown sections', () {
      expect(
        AppDestination.indexForLocation('/budgeting'),
        AppDestination.dashboard.index,
      );
    });
  });

  group('AppRouter', () {
    final placeholders = AppRoute.shellRoutes
        .where((route) => !NetWorthPages.builders.containsKey(route));
    for (final route in placeholders) {
      testWidgets('renders ${route.path} inside the shell', (tester) async {
        await tester.pumpApp(location: _concretePath(route));

        expect(find.byType(AppShell), findsOneWidget);
        expect(find.byType(PlaceholderScreen), findsOneWidget);
        expect(
          find.descendant(
            of: find.byType(PlaceholderScreen),
            matching: find.text(route.title),
          ),
          findsOneWidget,
        );
      });
    }

    testWidgets('renders the assets screen inside the shell', (tester) async {
      registerAssetBloc(const CrudLoaded([]));

      await tester.pumpApp(location: AppRoute.netWorthAssets.path);

      expect(find.byType(AppShell), findsOneWidget);
      expect(find.byType(AssetsScreen), findsOneWidget);
    });

    testWidgets('renders the login route without the shell', (tester) async {
      await tester.pumpApp(
        location: AppRoute.login.path,
        authBloc: mockAuthBloc(const AuthUnauthenticated()),
      );

      expect(find.byType(AppShell), findsNothing);
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('shows the not found screen for unknown paths', (tester) async {
      await tester.pumpApp(location: '/does-not-exist');

      expect(find.text(NotFoundScreen.title), findsOneWidget);
    });

    testWidgets('navigates between sections from the rail', (tester) async {
      await tester.pumpApp();

      await tester.tap(find.byIcon(AppDestination.goals.icon));
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byType(PlaceholderScreen),
          matching: find.text(AppRoute.goals.title),
        ),
        findsOneWidget,
      );
    });
  });

  group('route protection', () {
    testWidgets('sends signed-out users to the login screen', (tester) async {
      await tester.pumpApp(
        location: AppRoute.budgetIncome.path,
        authBloc: mockAuthBloc(const AuthUnauthenticated()),
      );

      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.byType(AppShell), findsNothing);
    });

    testWidgets('sign out from the shell lands on /login', (tester) async {
      final states = StreamController<AuthState>.broadcast();
      addTearDown(states.close);
      final bloc = mockAuthBloc(
        AuthAuthenticated(testUser),
        stream: states.stream,
      );
      await tester.pumpApp(location: AppRoute.budget.path, authBloc: bloc);
      final router = GoRouter.of(tester.element(find.byType(AppShell)));

      await tester.tap(find.byTooltip(AppShell.signOutTooltip));
      verify(() => bloc.add(const AuthSignOutRequested())).called(1);
      states.add(const AuthUnauthenticated(signedOut: true));
      await tester.pumpAndSettle();

      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.byType(SplashScreen), findsNothing);
      expect(router.routeInformationProvider.value.uri.toString(), '/login');
    });

    testWidgets('returns to login when the session expires', (tester) async {
      final states = StreamController<AuthState>.broadcast();
      addTearDown(states.close);
      await tester.pumpApp(
        authBloc: mockAuthBloc(
          AuthAuthenticated(testUser),
          stream: states.stream,
        ),
      );
      expect(find.byType(AppShell), findsOneWidget);

      states.add(const AuthUnauthenticated());
      await tester.pumpAndSettle();

      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('opens the requested location after signing in',
        (tester) async {
      final states = StreamController<AuthState>.broadcast();
      addTearDown(states.close);
      await tester.pumpApp(
        location: AppRoute.goals.path,
        authBloc: mockAuthBloc(
          const AuthUnauthenticated(),
          stream: states.stream,
        ),
      );
      expect(find.byType(LoginScreen), findsOneWidget);

      states.add(AuthAuthenticated(testUser));
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byType(PlaceholderScreen),
          matching: find.text(AppRoute.goals.title),
        ),
        findsOneWidget,
      );
    });

    testWidgets('ignores an unsafe return location after signing in',
        (tester) async {
      await tester.pumpApp(location: '/login?from=%2F%5Cevil.com');

      expect(tester.takeException(), isNull);
      expect(find.byType(LoginScreen), findsNothing);
      expect(
        find.descendant(
          of: find.byType(PlaceholderScreen),
          matching: find.text(AppRoute.dashboard.title),
        ),
        findsOneWidget,
      );
    });

    testWidgets('keeps signed-in users away from the login screen',
        (tester) async {
      await tester.pumpApp(location: AppRoute.login.path);

      expect(find.byType(LoginScreen), findsNothing);
      expect(
        find.descendant(
          of: find.byType(PlaceholderScreen),
          matching: find.text(AppRoute.dashboard.title),
        ),
        findsOneWidget,
      );
    });
  });
}
