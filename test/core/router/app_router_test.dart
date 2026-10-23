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
import 'package:pennypincher_pro/features/budget/presentation/bloc/monthly_budget_bloc.dart';
import 'package:pennypincher_pro/features/budget/presentation/budget_pages.dart';
import 'package:pennypincher_pro/features/budget/presentation/screen/budget_overview_screen.dart';
import 'package:pennypincher_pro/features/budget/presentation/screen/income_sources_screen.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/bloc/expenses_hub_bloc.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/expense_details_pages.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/screen/credit_cards_screen.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/screen/expenses_hub_screen.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/screen/fixed_expenses_screen.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/screen/loans_screen.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/screen/savings_screen.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/screen/variable_expenses_screen.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/financial_goals_pages.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/screen/goals_screen.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/bloc/net_worth_bloc.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/net_worth_pages.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/screen/assets_screen.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/screen/liabilities_screen.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/screen/net_worth_screen.dart';

import '../../helpers/budget_mocks.dart';
import '../../helpers/expense_mocks.dart';
import '../../helpers/goal_mocks.dart';
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
    final placeholders = AppRoute.shellRoutes.where(
      (route) =>
          route != AppRoute.budget &&
          !NetWorthPages.builders.containsKey(route) &&
          !BudgetPages.builders.containsKey(route) &&
          !ExpenseDetailsPages.builders.containsKey(route) &&
          !FinancialGoalsPages.builders.containsKey(route),
    );
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

    testWidgets('renders the net worth screen inside the shell',
        (tester) async {
      registerNetWorthBloc(const NetWorthLoading());

      await tester.pumpApp(location: AppRoute.netWorth.path);

      expect(find.byType(AppShell), findsOneWidget);
      expect(find.byType(NetWorthScreen), findsOneWidget);
    });

    testWidgets('renders the assets screen inside the shell', (tester) async {
      registerAssetBloc(const CrudLoaded([]));

      await tester.pumpApp(location: AppRoute.netWorthAssets.path);

      expect(find.byType(AppShell), findsOneWidget);
      expect(find.byType(AssetsScreen), findsOneWidget);
    });

    testWidgets('renders the liabilities screen inside the shell',
        (tester) async {
      registerLiabilityBloc(const CrudLoaded([]));

      await tester.pumpApp(location: AppRoute.netWorthLiabilities.path);

      expect(find.byType(AppShell), findsOneWidget);
      expect(find.byType(LiabilitiesScreen), findsOneWidget);
    });

    testWidgets('opens the budget overview from the budget section',
        (tester) async {
      registerMonthlyBudgetBloc(MonthlyBudgetState(month: DateTime(2026, 10)));

      await tester.pumpApp(location: AppRoute.budget.path);

      expect(find.byType(AppShell), findsOneWidget);
      expect(find.byType(BudgetOverviewScreen), findsOneWidget);
      final router = GoRouter.of(tester.element(find.byType(AppShell)));
      expect(
        router.routeInformationProvider.value.uri.path,
        AppRoute.budgetOverview.path,
      );
    });

    testWidgets('renders the income sources screen inside the shell',
        (tester) async {
      registerIncomeSourceBloc(const CrudLoaded([]));

      await tester.pumpApp(location: AppRoute.budgetIncome.path);

      expect(find.byType(AppShell), findsOneWidget);
      expect(find.byType(IncomeSourcesScreen), findsOneWidget);
    });

    testWidgets('renders the expenses hub inside the shell', (tester) async {
      registerExpensesHubBloc(const ExpensesHubState());

      await tester.pumpApp(location: AppRoute.expenses.path);

      expect(find.byType(AppShell), findsOneWidget);
      expect(find.byType(ExpensesHubScreen), findsOneWidget);
    });

    testWidgets('renders the credit cards screen inside the shell',
        (tester) async {
      registerCreditCardBloc(const CrudLoaded([]));

      await tester.pumpApp(location: AppRoute.expensesCreditCards.path);

      expect(find.byType(AppShell), findsOneWidget);
      expect(find.byType(CreditCardsScreen), findsOneWidget);
    });

    testWidgets('renders the loans screen inside the shell', (tester) async {
      registerLoanBloc(const CrudLoaded([]));

      await tester.pumpApp(location: AppRoute.expensesLoans.path);

      expect(find.byType(AppShell), findsOneWidget);
      expect(find.byType(LoansScreen), findsOneWidget);
    });

    testWidgets('renders the fixed and variable expenses inside the shell',
        (tester) async {
      registerFixedExpenseBloc(const CrudLoaded([]));
      registerVariableExpenseBloc(const CrudLoaded([]));

      await tester.pumpApp(location: AppRoute.expensesFixed.path);
      expect(find.byType(FixedExpensesScreen), findsOneWidget);
      await tester.pumpApp(location: AppRoute.expensesVariable.path);
      expect(find.byType(VariableExpensesScreen), findsOneWidget);
      expect(find.byType(AppShell), findsOneWidget);
    });

    testWidgets('renders the savings screen inside the shell', (tester) async {
      registerSavingsAccountBloc(const CrudLoaded([]));

      await tester.pumpApp(location: AppRoute.expensesSavings.path);

      expect(find.byType(AppShell), findsOneWidget);
      expect(find.byType(SavingsScreen), findsOneWidget);
    });

    testWidgets('renders the goals screen inside the shell', (tester) async {
      registerGoalsBloc(const CrudLoaded([]));

      await tester.pumpApp(location: AppRoute.goals.path);

      expect(find.byType(AppShell), findsOneWidget);
      expect(find.byType(GoalsScreen), findsOneWidget);
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

      await tester.tap(find.byIcon(AppDestination.settings.icon));
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byType(PlaceholderScreen),
          matching: find.text(AppRoute.settings.title),
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
      await tester.pumpApp(location: AppRoute.settings.path, authBloc: bloc);
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
        location: AppRoute.settingsProfile.path,
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
          matching: find.text(AppRoute.settingsProfile.title),
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
