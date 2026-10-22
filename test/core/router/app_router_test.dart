import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/layout/app_shell.dart';
import 'package:pennypincher_pro/core/router/app_destination.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/widgets/placeholder_screen.dart';
import 'package:pennypincher_pro/features/auth/presentation/screen/login_screen.dart';

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
    for (final route in AppRoute.shellRoutes) {
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

    testWidgets('renders the login route without the shell', (tester) async {
      await tester.pumpApp(location: AppRoute.login.path);

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
}
