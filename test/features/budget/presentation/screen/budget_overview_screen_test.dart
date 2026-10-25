import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/widgets/confirmation_dialog.dart';
import 'package:pennypincher_pro/core/widgets/loading_skeleton.dart';
import 'package:pennypincher_pro/core/widgets/month_selector.dart';
import 'package:pennypincher_pro/core/widgets/stat_card.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/income_source_entity.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/monthly_budget_entity.dart';
import 'package:pennypincher_pro/features/budget/presentation/bloc/budget_comparison_bloc.dart';
import 'package:pennypincher_pro/features/budget/presentation/bloc/monthly_budget_bloc.dart';
import 'package:pennypincher_pro/features/budget/presentation/budget_texts.dart';
import 'package:pennypincher_pro/features/budget/presentation/screen/budget_overview_screen.dart';
import 'package:pennypincher_pro/features/budget/presentation/screen/income_sources_screen.dart';
import 'package:pennypincher_pro/features/budget/presentation/widget/budget_breakdown_card.dart';
import 'package:pennypincher_pro/features/budget/presentation/widget/budget_details_card.dart';
import 'package:pennypincher_pro/features/budget/presentation/widget/budget_income_card.dart';
import 'package:pennypincher_pro/features/budget/presentation/widget/budget_value_dialog.dart';
import 'package:pennypincher_pro/features/budget/presentation/widget/expense_percentage_row.dart';

import '../../../../helpers/budget_fixtures.dart';
import '../../../../helpers/budget_mocks.dart';
import '../../../../helpers/load_fonts.dart';
import '../../../../helpers/pump_app.dart';

const List<IncomeSource> _income = [avenueCode, remoti, arriendoMadera];
final DateTime _october = DateTime(2026, 10);

final MonthlyBudgetState _loaded = MonthlyBudgetState(
  month: _october,
  status: BudgetLoadStatus.loaded,
  budget: octoberBudget,
  incomeSources: _income,
);

final MonthlyBudgetState _empty = MonthlyBudgetState(
  month: _october,
  status: BudgetLoadStatus.loaded,
  incomeSources: _income,
);

void main() {
  setUpAll(() {
    registerFallbackValue(const MonthlyBudgetStarted());
    return loadAppFonts();
  });

  Future<MockMonthlyBudgetBloc> pumpOverview(
    WidgetTester tester,
    MonthlyBudgetState state, {
    Size size = TestViewports.mobile,
    Stream<MonthlyBudgetState> stream = const Stream.empty(),
    bool settle = true,
  }) async {
    final bloc = registerMonthlyBudgetBloc(state, stream: stream);
    await tester.pumpApp(
      location: AppRoute.budgetOverview.path,
      size: size,
      settle: settle,
    );
    if (!settle) {
      await tester.pump();
    }
    return bloc;
  }

  Future<void> reveal(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
  }

  StatCard statCard(WidgetTester tester, String label) => tester
      .widgetList<StatCard>(find.byType(StatCard))
      .firstWhere((card) => card.label == label);

  testWidgets('starts loading the current month when it opens', (tester) async {
    final bloc =
        await pumpOverview(tester, MonthlyBudgetState(month: _october));

    expect(find.byType(BudgetOverviewScreen), findsOneWidget);
    expect(find.text('October 2026'), findsOneWidget);
    expect(find.byType(SkeletonBox), findsWidgets);
    verify(() => bloc.add(const MonthlyBudgetStarted())).called(1);
  });

  testWidgets('offers a retry when loading fails', (tester) async {
    final bloc = await pumpOverview(
      tester,
      MonthlyBudgetState(
        month: _october,
        status: BudgetLoadStatus.failure,
        loadError: 'Could not reach the server.',
      ),
    );
    clearInteractions(bloc);

    expect(find.text(BudgetTexts.loadErrorTitle), findsOneWidget);
    await tester.tap(find.text(BudgetTexts.retry));

    verify(() => bloc.add(const MonthlyBudgetReloadRequested())).called(1);
  });

  testWidgets('offers to create the budget of a month without one',
      (tester) async {
    final bloc = await pumpOverview(tester, _empty);

    expect(find.text('No budget for October 2026'), findsOneWidget);
    await tester.tap(find.byKey(BudgetOverviewScreen.createBudgetKey));

    verify(() => bloc.add(const MonthlyBudgetCreateRequested())).called(1);
  });

  testWidgets('disables the create button while creating', (tester) async {
    await pumpOverview(
      tester,
      _empty.copyWith(runningAction: () => BudgetAction.create),
      settle: false,
    );

    final button = tester.widget<ButtonStyleButton>(
      find.byKey(BudgetOverviewScreen.createBudgetKey),
    );
    expect(button.onPressed, isNull);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    final selector = tester.widget<IconButton>(
      find.byKey(MonthSelector.nextKey),
    );
    expect(selector.onPressed, isNull);
  });

  testWidgets('navigates between months', (tester) async {
    final bloc = await pumpOverview(tester, _loaded);

    await tester.tap(find.byKey(MonthSelector.nextKey));
    await tester.tap(find.byKey(MonthSelector.previousKey));

    verify(() => bloc.add(MonthlyBudgetMonthChanged(DateTime(2026, 11))))
        .called(1);
    verify(() => bloc.add(MonthlyBudgetMonthChanged(DateTime(2026, 9))))
        .called(1);
  });

  testWidgets('shows income, expenses and a positive cash flow in green',
      (tester) async {
    await pumpOverview(tester, _loaded);

    expect(
      statCard(tester, BudgetTexts.totalIncome).value,
      contains('37.152.922'),
    );
    expect(
      statCard(tester, BudgetTexts.totalExpenses).value,
      contains('19.135.201'),
    );
    final cashFlow = statCard(tester, BudgetTexts.cashFlow);
    expect(cashFlow.value, contains('18.017.721'));
    expect(cashFlow.valueColor, AppColors.success);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows a negative cash flow in red', (tester) async {
    await pumpOverview(
      tester,
      _loaded.copyWith(budget: () => novemberDeficit),
    );

    final cashFlow = statCard(tester, BudgetTexts.cashFlow);
    expect(cashFlow.value, contains('-'));
    expect(cashFlow.valueColor, AppColors.error);
  });

  testWidgets('lists every category with its share and ideal', (tester) async {
    await pumpOverview(tester, _loaded, size: TestViewports.desktop);

    final rows = tester
        .widgetList<ExpensePercentageRow>(find.byType(ExpensePercentageRow))
        .toList();
    expect(rows.map((row) => row.label), [
      'Credit cards',
      'Loans',
      'Monthly expenses',
      'Savings',
      'Charity',
    ]);
    expect(rows[1].percentage, 8.83);
    expect(rows[1].idealPercentage, isNull);
    expect(rows[0].status, PercentageStatus.onTarget);
    expect(find.text('42,7 %'), findsOneWidget);
    expect(find.text('—'), findsNWidgets(2));
  });

  testWidgets('places the breakdown next to the details on desktop',
      (tester) async {
    await pumpOverview(tester, _loaded, size: TestViewports.desktop);

    final breakdown = tester.getRect(find.byType(BudgetBreakdownCard));
    final details = tester.getRect(find.byType(BudgetDetailsCard));
    final income = tester.getRect(find.byType(BudgetIncomeCard));
    expect(details.left, greaterThan(breakdown.right));
    expect(details.top, breakdown.top);
    expect(income.top, greaterThan(details.bottom));
    expect(tester.takeException(), isNull);
  });

  testWidgets('stacks everything on mobile', (tester) async {
    await pumpOverview(tester, _loaded);

    final incomeCard = tester.getRect(find.byType(StatCard).first);
    final expensesCard = tester.getRect(find.byType(StatCard).at(1));
    expect(expensesCard.top, greaterThan(incomeCard.bottom));
    await reveal(tester, find.byType(BudgetDetailsCard));
    final breakdown = tester.getRect(find.byType(BudgetBreakdownCard));
    final details = tester.getRect(find.byType(BudgetDetailsCard));
    expect(details.top, greaterThan(breakdown.bottom));
    expect(tester.takeException(), isNull);
  });

  testWidgets('fits a tablet without overflowing', (tester) async {
    await pumpOverview(tester, _loaded, size: TestViewports.tablet);

    await reveal(tester, find.byType(BudgetIncomeCard));
    expect(tester.takeException(), isNull);
  });

  Future<void> openEditor(WidgetTester tester, Key key) async {
    await reveal(tester, find.byKey(key));
    await tester.tap(find.byKey(key));
    await tester.pumpAndSettle();
  }

  Future<void> saveValue(WidgetTester tester, String text) async {
    await tester.enterText(find.byKey(BudgetValueDialog.fieldKey), text);
    await tester.tap(find.byKey(BudgetValueDialog.saveKey));
    await tester.pumpAndSettle();
  }

  testWidgets('edits the exchange rate and keeps the work days',
      (tester) async {
    final bloc = await pumpOverview(tester, _loaded);

    await openEditor(tester, BudgetDetailsCard.exchangeRateEditKey);
    expect(find.text('Edit ${BudgetTexts.exchangeRate}'), findsOneWidget);
    await saveValue(tester, '0');
    expect(find.text(BudgetTexts.exchangeRateInvalid), findsOneWidget);
    await saveValue(tester, '3.950,25');

    verify(
      () => bloc.add(
        const MonthlyBudgetSettingsChanged(
          BudgetSettings(exchangeRate: Money.fromCents(395025), workDays: 22),
        ),
      ),
    ).called(1);
    expect(find.byType(BudgetValueDialog), findsNothing);
  });

  testWidgets('edits and clears the work days', (tester) async {
    final bloc = await pumpOverview(tester, _loaded);

    await openEditor(tester, BudgetDetailsCard.workDaysEditKey);
    await saveValue(tester, '32');
    expect(find.text(BudgetTexts.workDaysInvalid), findsOneWidget);
    await saveValue(tester, '');

    verify(
      () => bloc.add(
        const MonthlyBudgetSettingsChanged(
          BudgetSettings(exchangeRate: Money.fromPesos(3300)),
        ),
      ),
    ).called(1);
  });

  testWidgets('cancelling the editor changes nothing', (tester) async {
    final bloc = await pumpOverview(tester, _loaded);
    clearInteractions(bloc);

    await openEditor(tester, BudgetDetailsCard.workDaysEditKey);
    await tester.tap(find.text(BudgetTexts.cancel));
    await tester.pumpAndSettle();

    verifyNever(() => bloc.add(any()));
  });

  testWidgets('shows the exchange rate with cents and the work days',
      (tester) async {
    await pumpOverview(tester, _loaded, size: TestViewports.desktop);

    expect(find.text('\$\u00A03.300,00'), findsOneWidget);
    expect(find.text('22'), findsOneWidget);
  });

  testWidgets('says when the settings are not set', (tester) async {
    await pumpOverview(
      tester,
      _loaded.copyWith(budget: () => novemberDeficit),
      size: TestViewports.desktop,
    );

    expect(find.text(BudgetTexts.notSet), findsNWidgets(2));
  });

  testWidgets('lists the current income sources with their total',
      (tester) async {
    await pumpOverview(tester, _loaded, size: TestViewports.desktop);

    final card = find.byType(BudgetIncomeCard);
    for (final name in ['AvenueCode', 'Remoti', 'Arriendo Madera']) {
      expect(
        find.descendant(of: card, matching: find.text(name)),
        findsOneWidget,
      );
    }
    expect(find.text(BudgetTexts.currentTotal), findsOneWidget);
    expect(find.text(BudgetTexts.incomeNote), findsOneWidget);
    expect(find.text(BudgetTexts.incomeChanged), findsNothing);
  });

  testWidgets('warns when the current income differs from the budget',
      (tester) async {
    await pumpOverview(
      tester,
      _loaded.copyWith(incomeSources: () => const [remoti]),
      size: TestViewports.desktop,
    );

    expect(find.text(BudgetTexts.incomeChanged), findsOneWidget);
  });

  testWidgets('reports income sources that could not be loaded',
      (tester) async {
    await pumpOverview(
      tester,
      _loaded.copyWith(
        incomeSources: () => null,
        incomeError: () => 'Income unavailable',
      ),
      size: TestViewports.desktop,
    );

    expect(find.text('Income unavailable'), findsOneWidget);
  });

  testWidgets('retries income sources that could not be loaded',
      (tester) async {
    final bloc = await pumpOverview(
      tester,
      _loaded.copyWith(
        incomeSources: () => null,
        incomeError: () => 'Income unavailable',
      ),
      size: TestViewports.desktop,
    );

    await tester.tap(find.byKey(BudgetIncomeCard.retryKey));

    verify(() => bloc.add(const MonthlyBudgetIncomeReloadRequested()))
        .called(1);
  });

  testWidgets('marks the section titles as headings', (tester) async {
    final semantics = tester.ensureSemantics();
    await pumpOverview(tester, _loaded, size: TestViewports.desktop);

    for (final title in [
      BudgetTexts.breakdownTitle,
      BudgetTexts.detailsTitle,
      BudgetTexts.incomeTitle,
    ]) {
      expect(
        tester.getSemantics(find.text(title)),
        matchesSemantics(label: title, isHeader: true),
      );
    }
    semantics.dispose();
  });

  testWidgets('wraps long messages of the value editor', (tester) async {
    await pumpOverview(tester, _loaded);

    await openEditor(tester, BudgetDetailsCard.exchangeRateEditKey);
    final field = tester.widget<TextField>(
      find.descendant(
        of: find.byKey(BudgetValueDialog.fieldKey),
        matching: find.byType(TextField),
      ),
    );
    expect(field.decoration?.errorMaxLines, BudgetValueDialog.maxMessageLines);
    expect(field.decoration?.helperMaxLines, BudgetValueDialog.maxMessageLines);
    await saveValue(tester, '0');
    expect(tester.takeException(), isNull);
  });

  testWidgets('recalculates only after confirmation', (tester) async {
    final bloc = await pumpOverview(tester, _loaded);
    final button = find.byKey(BudgetIncomeCard.recalculateKey);
    await reveal(tester, button);

    await tester.tap(button);
    await tester.pumpAndSettle();
    expect(find.text('Recalculate October 2026?'), findsOneWidget);
    await tester.tap(find.text(ConfirmationDialog.cancelLabel));
    await tester.pumpAndSettle();
    verifyNever(() => bloc.add(const MonthlyBudgetRecalculateRequested()));

    await tester.tap(button);
    await tester.pumpAndSettle();
    await tester
        .tap(find.widgetWithText(FilledButton, BudgetTexts.recalculate));
    await tester.pumpAndSettle();
    verify(() => bloc.add(const MonthlyBudgetRecalculateRequested())).called(1);
  });

  testWidgets('disables the changes while one is running', (tester) async {
    await pumpOverview(
      tester,
      _loaded.copyWith(runningAction: () => BudgetAction.recalculate),
      size: TestViewports.desktop,
      settle: false,
    );

    final recalculate = tester.widget<ButtonStyleButton>(
      find.byKey(BudgetIncomeCard.recalculateKey),
    );
    expect(recalculate.onPressed, isNull);
    final edit = tester.widget<IconButton>(
      find.byKey(BudgetDetailsCard.exchangeRateEditKey),
    );
    expect(edit.onPressed, isNull);
  });

  testWidgets('opens the income sources screen', (tester) async {
    await pumpOverview(tester, _loaded, size: TestViewports.desktop);
    registerIncomeSourceBloc(const CrudLoaded([]));

    await tester.tap(find.text(BudgetTexts.manageIncome));
    await tester.pumpAndSettle();

    expect(find.byType(IncomeSourcesScreen), findsOneWidget);
  });

  testWidgets('confirms a finished change and reports a failed one',
      (tester) async {
    final states = StreamController<MonthlyBudgetState>();
    addTearDown(states.close);
    final creating = _empty.copyWith(runningAction: () => BudgetAction.create);
    await pumpOverview(
      tester,
      creating,
      stream: states.stream,
      settle: false,
    );

    states.add(_loaded.copyWith(finishedAction: BudgetAction.create));
    await tester.pumpAndSettle();
    expect(find.text('Budget created for October 2026'), findsOneWidget);

    states
      ..add(_loaded.copyWith(runningAction: () => BudgetAction.update))
      ..add(
        _loaded.copyWith(
          finishedAction: BudgetAction.update,
          actionError: 'Validation failed',
        ),
      );
    await tester.pumpAndSettle();
    expect(find.text('Validation failed'), findsOneWidget);
  });

  testWidgets('says when a create found the budget already created',
      (tester) async {
    final states = StreamController<MonthlyBudgetState>();
    addTearDown(states.close);
    await pumpOverview(
      tester,
      _empty.copyWith(runningAction: () => BudgetAction.create),
      stream: states.stream,
      settle: false,
    );

    states.add(
      _loaded.copyWith(
        finishedAction: BudgetAction.create,
        alreadyExisted: true,
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Budget for October 2026 already existed and was loaded'),
      findsOneWidget,
    );
    expect(find.textContaining('Budget created'), findsNothing);
  });

  testWidgets('opens the comparison from the header', (tester) async {
    await pumpOverview(tester, _loaded);
    registerBudgetComparisonBloc(const BudgetComparisonState());

    await tester.tap(find.byKey(BudgetOverviewScreen.comparisonKey));
    await tester.pump(const Duration(seconds: 1));

    expect(
      GoRouter.of(tester.element(find.byType(Scaffold).first))
          .routeInformationProvider
          .value
          .uri
          .path,
      AppRoute.budgetComparison.path,
    );
  });
}
