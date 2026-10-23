import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/core/crud/presentation/crud_screen_config.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/utils/currency_formatter.dart';
import 'package:pennypincher_pro/core/widgets/loading_skeleton.dart';
import 'package:pennypincher_pro/features/budget/presentation/bloc/monthly_budget_bloc.dart';
import 'package:pennypincher_pro/features/budget/presentation/screen/budget_overview_screen.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/expense_summary_entity.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/bloc/expenses_hub_bloc.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/expense_texts.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/screen/credit_cards_screen.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/screen/expenses_hub_screen.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/widget/expense_summary_card.dart';

import '../../../../helpers/budget_mocks.dart';
import '../../../../helpers/expense_fixtures.dart';
import '../../../../helpers/expense_mocks.dart';
import '../../../../helpers/load_fonts.dart';
import '../../../../helpers/pump_app.dart';

final ExpensesHubState _loaded = ExpensesHubState(
  statuses: {
    for (final kind in ExpenseKind.values)
      kind: SummaryLoaded(
        kind == ExpenseKind.fixedExpenses ? fixedSummary : cardsSummary,
      ),
  },
);

const List<AppRoute> _routes = [
  AppRoute.expensesCreditCards,
  AppRoute.expensesLoans,
  AppRoute.expensesFixed,
  AppRoute.expensesVariable,
  AppRoute.expensesSavings,
];

Finder _card(String title) => find.ancestor(
      of: find.text(title),
      matching: find.byType(ExpenseSummaryCard),
    );

Finder _inCard(AppRoute route, Finder finder) =>
    find.descendant(of: _card(route.title), matching: finder);

void main() {
  setUpAll(() {
    registerFallbackValue(const ExpensesHubStarted());
    return loadAppFonts();
  });

  Future<MockExpensesHubBloc> pumpHub(
    WidgetTester tester,
    ExpensesHubState state, {
    Size size = TestViewports.desktop,
  }) async {
    final bloc = registerExpensesHubBloc(state);
    await tester.pumpApp(location: AppRoute.expenses.path, size: size);
    return bloc;
  }

  testWidgets('starts loading every total, each card with its skeleton',
      (tester) async {
    final bloc = await pumpHub(tester, const ExpensesHubState());

    verify(() => bloc.add(const ExpensesHubStarted())).called(1);
    expect(find.byType(ExpenseSummaryCard), findsNWidgets(5));
    expect(find.byType(SkeletonBox), findsNWidgets(15));
  });

  for (final size in TestViewports.expenseWidths) {
    testWidgets('shows the five lists with their totals at ${size.width}',
        (tester) async {
      await pumpHub(tester, _loaded, size: size);

      for (final route in _routes) {
        await tester.scrollUntilVisible(find.text(route.title), 100);
        expect(find.text(route.title), findsOneWidget);
      }
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('shows the monthly total, balance and count of a list',
      (tester) async {
    await pumpHub(tester, _loaded);

    final balance = CurrencyFormatter.format(cardsSummary.balanceTotal!);
    for (final text in [
      find.text(ExpenseTexts.totalMonthlyPayments.toUpperCase()),
      find.text(CurrencyFormatter.format(cardsSummary.monthlyTotal)),
      find.text('2 cards'),
      find.textContaining(balance, findRichText: true),
    ]) {
      expect(_inCard(AppRoute.expensesCreditCards, text), findsOneWidget);
    }
    expect(
      _inCard(AppRoute.expensesFixed, find.text('1 expense')),
      findsOneWidget,
    );
  });

  testWidgets('announces each card as a button, not a heading', (tester) async {
    final semantics = tester.ensureSemantics();
    await pumpHub(tester, _loaded);

    final node = tester.getSemantics(
      find.text(AppRoute.expensesCreditCards.title),
    );
    expect(node.hasFlag(SemanticsFlag.isButton), isTrue);
    expect(node.hasFlag(SemanticsFlag.isHeader), isFalse);
    semantics.dispose();
  });

  const networkError =
      'Could not reach the server. Check your connection and try again.';
  final mixed =
      _loaded.withStatus(ExpenseKind.loans, const SummaryLoading()).withStatus(
            ExpenseKind.fixedExpenses,
            const SummaryLoadFailure(networkError),
          );
  for (final scale in [1.0, 1.5]) {
    for (final size in [
      ...TestViewports.expenseWidths,
      const Size(1024, 800),
    ]) {
      testWidgets('fits every card state at text scale $scale at ${size.width}',
          (tester) async {
        tester.platformDispatcher.textScaleFactorTestValue = scale;
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        await pumpHub(tester, mixed, size: size);

        for (final route in _routes) {
          await tester.scrollUntilVisible(find.text(route.title), 100);
          expect(tester.takeException(), isNull);
        }
      });
    }
  }

  testWidgets('offers a retry on the failing card only', (tester) async {
    final bloc = await pumpHub(
      tester,
      _loaded.withStatus(
        ExpenseKind.loans,
        const SummaryLoadFailure('Could not reach the server.'),
      ),
    );

    expect(find.text(CrudTexts.retry), findsOneWidget);
    expect(
      _inCard(AppRoute.expensesLoans, find.text('Could not reach the server.')),
      findsOneWidget,
    );
    await tester.tap(find.text(CrudTexts.retry));

    verify(
      () => bloc.add(const ExpenseSummaryRetried(ExpenseKind.loans)),
    ).called(1);
  });

  testWidgets('opens a list from its card', (tester) async {
    await pumpHub(tester, _loaded);
    registerCreditCardBloc(const CrudLoaded([]));

    await tester.tap(find.text(AppRoute.expensesCreditCards.title));
    await tester.pumpAndSettle();

    expect(find.byType(CreditCardsScreen), findsOneWidget);
  });

  testWidgets('links to the budget overview to recalculate', (tester) async {
    await pumpHub(tester, _loaded, size: TestViewports.expenseWidths.first);
    registerMonthlyBudgetBloc(MonthlyBudgetState(month: DateTime(2026, 10)));

    final link = find.text(ExpenseTexts.openBudgetOverview);
    await tester.ensureVisible(link);
    await tester.pumpAndSettle();
    expect(find.text(ExpenseTexts.budgetHint), findsOneWidget);
    await tester.tap(link);
    await tester.pumpAndSettle();

    expect(find.byType(BudgetOverviewScreen), findsOneWidget);
    expect(find.byType(ExpensesHubScreen), findsNothing);
  });
}
