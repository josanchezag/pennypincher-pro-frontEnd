import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/core/crud/presentation/widget/item_form_sheet.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/utils/app_currency.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/utils/money_formatter.dart';
import 'package:pennypincher_pro/core/utils/percent_formatter.dart';
import 'package:pennypincher_pro/features/ant_expenses/domain/entity/ant_expense_entity.dart';
import 'package:pennypincher_pro/features/ant_expenses/domain/entity/ant_expense_report_entity.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/bloc/ant_insights_cubit.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/bloc/ant_section.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/screen/ant_expenses_screen.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/widget/ant_cut_sheet.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/widget/ant_expense_form.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/widget/ant_limit_dialog.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/widget/ant_period_card.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/widget/ant_quick_add.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/widget/ant_trend_card.dart';
import 'package:pennypincher_pro/features/budget/presentation/bloc/monthly_budget_bloc.dart';
import 'package:pennypincher_pro/features/budget/presentation/screen/budget_overview_screen.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/bloc/expenses_hub_bloc.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/screen/expenses_hub_screen.dart';

import '../../../../helpers/ant_fixtures.dart';
import '../../../../helpers/ant_mocks.dart';
import '../../../../helpers/budget_mocks.dart';
import '../../../../helpers/crud_screen_helpers.dart';
import '../../../../helpers/expense_mocks.dart';
import '../../../../helpers/l10n.dart';
import '../../../../helpers/load_fonts.dart';
import '../../../../helpers/pump_app.dart';

typedef _Doubles = ({MockAntExpenseBloc bloc, MockAntInsightsCubit cubit});

Finder get _scrollable => find
    .descendant(
      of: find.byKey(AntExpensesScreen.scrollKey),
      matching: find.byType(Scrollable),
    )
    .first;

/// Scrolls the screen until [finder] is in view, and lays it out there.
Future<void> _reveal(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(finder, 200, scrollable: _scrollable);
  await tester.pump();
}

String _cop(int units) => testMoney.format(Money.fromUnits(units));

AntInsightsState _withSummary(AntSummary summary) =>
    antInsightsLoaded.copyWith(summary: AntSectionLoaded(summary));

void main() {
  setUpAll(() {
    registerFallbackValue(const CrudLoadRequested<AntExpenseDraft>());
    registerFallbackValue(const Money.fromUnits(1));
    return loadAppFonts();
  });

  Future<_Doubles> pumpScreen(
    WidgetTester tester, {
    CrudState<AntExpense>? list,
    AntInsightsState? insights,
    Stream<CrudState<AntExpense>> stream = const Stream.empty(),
    Stream<AntInsightsState> insightsStream = const Stream.empty(),
    Size size = TestViewports.desktop,
    Locale locale = testLocale,
    bool settle = true,
  }) async {
    final bloc = registerAntExpenseBloc(
      list ?? CrudLoaded(openExpenses),
      stream: stream,
    );
    final cubit = registerAntInsightsCubit(
      insights ?? antInsightsLoaded,
      stream: insightsStream,
    );
    await tester.pumpApp(
      location: AppRoute.expensesAnt.path,
      size: size,
      locale: locale,
      settle: settle,
    );
    return (bloc: bloc, cubit: cubit);
  }

  group('loading', () {
    testWidgets('starts loading the list and every report', (tester) async {
      final doubles = await pumpScreen(
        tester,
        list: const CrudLoading(),
        insights: AntInsightsState(today: antToday),
      );

      verify(
        () => doubles.bloc.add(const CrudLoadRequested<AntExpenseDraft>()),
      ).called(1);
      verify(doubles.cubit.load).called(1);
      expect(find.byKey(AntExpensesScreen.addButtonKey), findsNothing);
      expect(find.bySemanticsLabel(l10n.commonLoading), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('retries the list after it failed', (tester) async {
      final doubles = await pumpScreen(
        tester,
        list: const CrudLoadFailure('Could not reach the server.'),
      );

      await _reveal(tester, find.text(l10n.commonRetry));
      expect(find.text(l10n.antListLoadError), findsOneWidget);
      clearInteractions(doubles.bloc);
      await tester.tap(find.text(l10n.commonRetry));

      verify(
        () => doubles.bloc.add(const CrudLoadRequested<AntExpenseDraft>()),
      ).called(1);
    });

    testWidgets('retries each report on its own', (tester) async {
      final doubles = await pumpScreen(
        tester,
        insights: AntInsightsState(
          today: antToday,
          summary: const AntSectionFailure('Offline summary'),
          trend: const AntSectionFailure('Offline trend'),
          cuts: const AntSectionFailure('Offline cuts'),
        ),
      );

      expect(find.text(l10n.antSummaryLoadError), findsNWidgets(2));
      expect(find.text(l10n.antTrendLoadError), findsOneWidget);
      expect(find.text(l10n.antCutsLoadError), findsOneWidget);
      final retries = find.text(l10n.commonRetry);
      expect(retries, findsNWidgets(4));
      for (final index in [0, 2, 3]) {
        await tester.ensureVisible(retries.at(index));
        await tester.tap(retries.at(index));
      }

      verify(doubles.cubit.retrySummary).called(1);
      verify(doubles.cubit.retryTrend).called(1);
      verify(doubles.cubit.retryCuts).called(1);
    });
  });

  group('period', () {
    for (final size in TestViewports.expenseWidths) {
      testWidgets('lays out every part at ${size.width}', (tester) async {
        await pumpScreen(tester, size: size);

        expect(find.text(testMoney.format(antSummary.total)), findsOneWidget);
        for (final text in [
          l10n.antListTitle,
          l10n.antBreakdownTitle,
          l10n.antTrendTitle,
          l10n.antCutsTitle,
          l10n.antCutHint,
        ]) {
          await _reveal(tester, find.text(text));
          expect(tester.takeException(), isNull);
        }
      });
    }

    testWidgets('fits at a 390 px phone with large text', (tester) async {
      tester.platformDispatcher.textScaleFactorTestValue = 1.5;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await pumpScreen(tester, size: TestViewports.expenseWidths.first);

      await _reveal(tester, find.text(l10n.antCutHint));
      expect(tester.takeException(), isNull);
    });

    testWidgets('shows the totals, the last cut and the top category',
        (tester) async {
      await pumpScreen(tester);

      expect(find.text('3 expenses'), findsOneWidget);
      expect(
        find.text(
          l10n.labelValue(
            l10n.antDailyAverage,
            testMoney.format(antSummary.dailyAverage),
          ),
        ),
        findsOneWidget,
      );
      expect(
        find.text('Since the last cut: 5 days · Period since Oct 31, 2026'),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel('${l10n.antTopCategory}: Transport'),
        findsOneWidget,
      );
    });

    testWidgets('says there was no cut yet for a new user', (tester) async {
      await pumpScreen(
        tester,
        list: const CrudLoaded([]),
        insights: _withSummary(emptySummary),
      );

      expect(find.text(l10n.antNoCutsYet), findsOneWidget);
      expect(find.text(l10n.antEmptyTitle), findsOneWidget);
      expect(find.text(l10n.antBreakdownEmpty), findsOneWidget);
      expect(find.text(l10n.antLimitNone), findsOneWidget);
      expect(find.text(l10n.antLimitSet), findsOneWidget);
    });

    Color barColor(WidgetTester tester) => tester
        .widget<LinearProgressIndicator>(find.byKey(AntPeriodCard.limitBarKey))
        .color!;

    testWidgets('colors the limit green while there is room', (tester) async {
      await pumpScreen(tester);

      expect(barColor(tester), AppColors.success);
      expect(
        find.text(l10n.antLimitRemaining(_cop(123000))),
        findsOneWidget,
      );
      expect(
        find.text(l10n.antLimitUsed('18.0%', _cop(150000))),
        findsOneWidget,
      );
    });

    testWidgets('colors the limit amber close to it and red past it',
        (tester) async {
      final close = antSummary.copyWith(
        limit: const AntLimitUsage(
          monthlyLimit: Money.fromUnits(30000),
          usedPercentage: 90,
          remaining: Money.fromUnits(3000),
        ),
      );
      final states = StreamController<AntInsightsState>();
      addTearDown(states.close);
      await pumpScreen(
        tester,
        insights: _withSummary(close),
        insightsStream: states.stream,
      );
      expect(barColor(tester), AppColors.warning);

      states.add(
        _withSummary(
          antSummary.copyWith(
            limit: const AntLimitUsage(
              monthlyLimit: Money.fromUnits(20000),
              usedPercentage: 135,
              remaining: Money.fromUnits(-7000),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(barColor(tester), AppColors.error);
      expect(find.text(l10n.antLimitExceeded(_cop(7000))), findsOneWidget);
      expect(
        find.bySemanticsLabel(RegExp('over the limit')),
        findsOneWidget,
      );
    });

    testWidgets('is in Spanish by default', (tester) async {
      await pumpScreen(
        tester,
        size: TestViewports.expenseWidths.first,
        locale: AppLocales.spanish,
      );

      expect(find.text(l10nEs.routeExpensesAnt), findsOneWidget);
      expect(
        find.text(
          'Desde el último corte: 5 días · Periodo desde el 31 oct 2026',
        ),
        findsOneWidget,
      );
      expect(
        find.text(
          l10nEs.antLimitRemaining(
            MoneyFormatter.of(AppCurrency.cop, 'es')
                .format(const Money.fromUnits(123000)),
          ),
        ),
        findsOneWidget,
      );
      expect(find.text(l10nEs.antToday.toUpperCase()), findsOneWidget);
      expect(find.text(l10nEs.antAdd), findsOneWidget);
      await _reveal(tester, find.text('TRANSPORTE'));
      expect(find.text('TRANSPORTE'), findsOneWidget);
    });
  });

  group('list', () {
    testWidgets('groups the expenses by day, newest first', (tester) async {
      await pumpScreen(tester);

      final today = tester.getTopLeft(find.text('TODAY')).dy;
      final yesterday = tester.getTopLeft(find.text('YESTERDAY')).dy;
      final taxiTop = tester.getTopLeft(find.text('Taxi a casa')).dy;
      final coffeeTop = tester.getTopLeft(find.text('Tinto en la oficina')).dy;
      expect(today, lessThan(taxiTop));
      expect(taxiTop, lessThan(coffeeTop));
      expect(coffeeTop, lessThan(yesterday));
      expect(
        find.bySemanticsLabel(
          '${l10n.antToday}, ${testMoney.format(const Money.fromUnits(18000))}',
        ),
        findsOneWidget,
      );
      expect(find.text(l10n.antCategoryFastFood), findsWidgets);
    });

    testWidgets('names an expense without description by its category',
        (tester) async {
      await pumpScreen(tester);

      expect(
        find.byTooltip(l10n.crudDeleteTooltip(l10n.antCategoryFastFood)),
        findsOneWidget,
      );
    });

    testWidgets('deletes an expense after confirming the swipe',
        (tester) async {
      final doubles = await pumpScreen(tester);

      await _reveal(tester, find.text('Tinto en la oficina'));
      await tester.drag(
        find.text('Tinto en la oficina'),
        const Offset(-600, 0),
      );
      await tester.pumpAndSettle();
      expect(find.text(l10n.antDeleteTitle), findsOneWidget);
      expect(
        find.text(
          l10n.antDeleteMessage('Tinto en la oficina', _cop(3500)),
        ),
        findsOneWidget,
      );
      await tester.tap(find.widgetWithText(FilledButton, l10n.commonDelete));
      await tester.pumpAndSettle();

      verify(
        () => doubles.bloc
            .add(const CrudDeleteRequested<AntExpenseDraft>('ae-1')),
      ).called(1);
    });

    testWidgets('keeps the expense when the delete is cancelled',
        (tester) async {
      final doubles = await pumpScreen(tester);

      final delete = find.byTooltip(l10n.crudDeleteTooltip('Taxi a casa'));
      await _reveal(tester, delete);
      await tester.tap(delete);
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n.commonCancel));
      await tester.pumpAndSettle();

      verifyNever(
        () => doubles.bloc.add(
          any(that: isA<CrudDeleteRequested<AntExpenseDraft>>()),
        ),
      );
    });

    testWidgets('reports an expense a cut already took', (tester) async {
      final states = StreamController<CrudState<AntExpense>>();
      addTearDown(states.close);
      final doubles = await pumpScreen(tester, stream: states.stream);

      states
        ..add(CrudLoaded(openExpenses, busy: true))
        ..add(
          CrudLoaded(
            openExpenses,
            errorMessage: l10n.errorAntExpenseAlreadyCut,
            failedAction: CrudAction.delete,
          ),
        );
      await tester.pumpAndSettle();

      expect(find.text(l10n.errorAntExpenseAlreadyCut), findsOneWidget);
      verifyNever(doubles.cubit.refreshPeriod);
    });

    testWidgets('refreshes the totals after a change', (tester) async {
      final states = StreamController<CrudState<AntExpense>>();
      addTearDown(states.close);
      final doubles = await pumpScreen(tester, stream: states.stream);

      states
        ..add(CrudLoaded(openExpenses, busy: true))
        ..add(CrudLoaded(openExpenses.sublist(1)));
      await tester.pumpAndSettle();

      verify(doubles.cubit.refreshPeriod).called(1);
    });
  });

  group('add sheet', () {
    testWidgets('adds an expense today with the amount focused',
        (tester) async {
      final doubles = await pumpScreen(tester);

      await tester.tap(find.byKey(AntExpensesScreen.addButtonKey));
      await tester.pumpAndSettle();

      expect(find.text(l10n.antAdd), findsNWidgets(2));
      final focused = FocusManager.instance.primaryFocus!.context!;
      expect(
        find.descendant(
          of: find.byKey(AntExpenseForm.amountKey),
          matching: find.byWidget(focused.widget),
        ),
        findsOneWidget,
      );
      expect(find.text(l10n.antToday), findsOneWidget);
      await tester.tap(find.byKey(ItemFormSheet.saveKey));
      await tester.pumpAndSettle();
      expect(find.text(l10n.crudAmountRequired), findsOneWidget);
      expect(find.text(l10n.crudCategoryRequired), findsOneWidget);

      await tester.enterText(fieldLabeled(l10n.antAmountLabel), '4200');
      await tester.tap(find.text(l10n.antCategoryCoffeeAndDrinks).last);
      await tester.enterText(
        fieldLabeled(l10n.antDescriptionLabel),
        '  Agua  ',
      );
      await tester.tap(find.byKey(ItemFormSheet.saveKey));
      await tester.pump();

      verify(
        () => doubles.bloc.add(
          CrudSaveRequested(
            AntExpenseDraft(
              amount: const Money.fromUnits(4200),
              category: AntExpenseCategory.coffeeAndDrinks,
              spentOn: antToday,
              description: 'Agua',
            ),
          ),
        ),
      ).called(1);
    });

    testWidgets('quick add opens the sheet with the category chosen',
        (tester) async {
      final doubles = await pumpScreen(tester);

      await tester.tap(
        find.byKey(AntQuickAdd.chipKey(AntExpenseCategory.transport)),
      );
      await tester.pumpAndSettle();
      await tester.enterText(fieldLabeled(l10n.antAmountLabel), '6000');
      await tester.tap(find.byKey(ItemFormSheet.saveKey));
      await tester.pump();

      verify(
        () => doubles.bloc.add(
          CrudSaveRequested(
            AntExpenseDraft(
              amount: const Money.fromUnits(6000),
              category: AntExpenseCategory.transport,
              spentOn: antToday,
            ),
          ),
        ),
      ).called(1);
    });

    testWidgets('picks an earlier day from the calendar', (tester) async {
      final doubles = await pumpScreen(tester);

      await tester.tap(
        find.byKey(AntQuickAdd.chipKey(AntExpenseCategory.fastFood)),
      );
      await tester.pumpAndSettle();
      await tester.enterText(fieldLabeled(l10n.antAmountLabel), '9000');
      await tester.tap(find.byKey(AntExpenseForm.dateKey));
      await tester.pumpAndSettle();
      expect(find.byType(DatePickerDialog), findsOneWidget);
      await tester.tap(find.text('3'));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(find.text('Tuesday, November 3'), findsOneWidget);
      await tester.tap(find.byKey(ItemFormSheet.saveKey));
      await tester.pump();

      verify(
        () => doubles.bloc.add(
          CrudSaveRequested(
            AntExpenseDraft(
              amount: const Money.fromUnits(9000),
              category: AntExpenseCategory.fastFood,
              spentOn: DateTime(2026, 11, 3),
            ),
          ),
        ),
      ).called(1);
    });

    testWidgets('edits an open expense', (tester) async {
      final doubles = await pumpScreen(tester);

      await tester.tap(find.text('Taxi a casa'));
      await tester.pumpAndSettle();
      expect(find.text(l10n.antEdit), findsOneWidget);
      expect(find.text('14,500'), findsOneWidget);
      await tester.enterText(fieldLabeled(l10n.antAmountLabel), '15000');
      await tester.tap(find.byKey(ItemFormSheet.saveKey));
      await tester.pump();
      verify(
        () => doubles.bloc.add(
          CrudSaveRequested(
            AntExpenseDraft(
              amount: const Money.fromUnits(15000),
              category: AntExpenseCategory.transport,
              spentOn: antToday,
              description: 'Taxi a casa',
            ),
            id: 'ae-2',
          ),
        ),
      ).called(1);
    });

    testWidgets('deletes an expense from its sheet', (tester) async {
      final doubles = await pumpScreen(tester);

      await tester.tap(find.text('Taxi a casa'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(ItemFormSheet.deleteKey));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, l10n.commonDelete));
      await tester.pumpAndSettle();

      verify(
        () => doubles.bloc
            .add(const CrudDeleteRequested<AntExpenseDraft>('ae-2')),
      ).called(1);
    });

    testWidgets('keeps the sheet open with the reason a save failed',
        (tester) async {
      final states = StreamController<CrudState<AntExpense>>();
      addTearDown(states.close);
      await pumpScreen(tester, stream: states.stream);

      await tester.tap(find.text('Taxi a casa'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(ItemFormSheet.saveKey));
      await tester.pump();
      states
        ..add(CrudLoaded(openExpenses, busy: true))
        ..add(
          CrudLoaded(
            openExpenses,
            errorMessage: l10n.errorAntExpenseAlreadyCut,
            failedAction: CrudAction.save,
          ),
        );
      await tester.pumpAndSettle();

      expect(find.byKey(ItemFormSheet.errorKey), findsOneWidget);
      expect(find.text(l10n.errorAntExpenseAlreadyCut), findsOneWidget);
    });
  });

  group('limit', () {
    testWidgets('changes the limit from the period card', (tester) async {
      final doubles = await pumpScreen(tester);

      await tester.tap(find.byKey(AntPeriodCard.limitButtonKey));
      await tester.pumpAndSettle();
      expect(find.text(l10n.antLimitDialogTitle), findsOneWidget);
      expect(find.text('150,000'), findsOneWidget);
      await tester.enterText(find.byKey(AntLimitDialog.fieldKey), '200000');
      await tester.tap(find.byKey(AntLimitDialog.saveKey));
      await tester.pumpAndSettle();

      verify(
        () => doubles.cubit.saveLimit(const Money.fromUnits(200000)),
      ).called(1);
    });

    testWidgets('removes the limit', (tester) async {
      final doubles = await pumpScreen(tester);

      await tester.tap(find.byKey(AntPeriodCard.limitButtonKey));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(AntLimitDialog.removeKey));
      await tester.pumpAndSettle();

      verify(() => doubles.cubit.saveLimit(null)).called(1);
    });

    testWidgets('asks for an amount above zero', (tester) async {
      final doubles = await pumpScreen(
        tester,
        insights: _withSummary(emptySummary),
      );

      await tester.tap(find.byKey(AntPeriodCard.limitButtonKey));
      await tester.pumpAndSettle();
      expect(find.byKey(AntLimitDialog.removeKey), findsNothing);
      await tester.enterText(find.byKey(AntLimitDialog.fieldKey), '0');
      await tester.tap(find.byKey(AntLimitDialog.saveKey));
      await tester.pumpAndSettle();

      expect(find.text(l10n.crudAmountNotPositive), findsOneWidget);
      verifyNever(() => doubles.cubit.saveLimit(any()));
    });

    testWidgets('confirms a saved limit and reports a failed one',
        (tester) async {
      final states = StreamController<AntInsightsState>();
      addTearDown(states.close);
      await pumpScreen(tester, insightsStream: states.stream);

      states
        ..add(antInsightsLoaded.copyWith(savingLimit: true))
        ..add(antInsightsLoaded);
      await tester.pumpAndSettle();
      expect(find.text(l10n.antLimitSaved), findsOneWidget);

      states
        ..add(antInsightsLoaded.copyWith(savingLimit: true))
        ..add(antInsightsLoaded.copyWith(limitError: () => 'Rejected'));
      await tester.pumpAndSettle();
      expect(find.text('Rejected'), findsOneWidget);
    });
  });

  group('reports', () {
    testWidgets('describes the trend and shows twelve months on request',
        (tester) async {
      final doubles = await pumpScreen(tester);

      expect(
        find.bySemanticsLabel(
          l10n.antTrendDescription(
            'June 2026',
            'November 2026',
            _cop(212000),
            'October 2026',
          ),
        ),
        findsOneWidget,
      );
      await tester.tap(find.text(l10n.timeRangeOneYear));
      await tester.pumpAndSettle();

      verify(() => doubles.cubit.changeTrendMonths(12)).called(1);
    });

    testWidgets('shows the tooltip of a month', (tester) async {
      await pumpScreen(tester);

      final item = AntTrendChart.tooltipOf(l10n, testMoney, antTrend[4]);
      expect(item.text, 'October 2026\n');
      expect(
        item.children!.map((span) => span.toPlainText()),
        ['${_cop(212000)}\n', '14 expenses'],
      );
    });

    testWidgets('shows the share of every category', (tester) async {
      await pumpScreen(tester);

      expect(
        find.bySemanticsLabel(
          'Transport, ${_cop(14500)}, ${PercentFormatter.format(53.7)}, '
          '1 expense',
        ),
        findsOneWidget,
      );
    });

    testWidgets('lists the cuts and opens one, read only', (tester) async {
      final semantics = tester.ensureSemantics();
      await pumpScreen(tester);
      final items = registerAntCutItemsCubit(AntSectionLoaded([octoberSnack]));

      final row = find.text('October 2026');
      await _reveal(tester, row);
      expect(
        find.text('41 expenses · Purchases from Oct 1 to Oct 31'),
        findsOneWidget,
      );
      expect(
        find.text(
          'Fast food ${PercentFormatter.format(56.6)} · Coffee and drinks '
          '${PercentFormatter.format(24.53)} · Transport '
          '${PercentFormatter.format(18.87)}',
        ),
        findsOneWidget,
      );
      expect(
        tester.getSemantics(row).hasFlag(SemanticsFlag.isButton),
        isTrue,
      );
      await tester.tap(row);
      await tester.pumpAndSettle();

      verify(() => items.load(octoberBudgetId)).called(1);
      expect(find.text(l10n.antCutTitle('October 2026')), findsOneWidget);
      expect(find.text(l10n.antCutLocked('October 2026')), findsOneWidget);
      expect(find.text('Galletas'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AntCutSheet),
          matching: find.byIcon(Icons.delete_outline),
        ),
        findsNothing,
      );
      semantics.dispose();
    });

    testWidgets('retries the expenses of a cut', (tester) async {
      await pumpScreen(tester);
      final items = registerAntCutItemsCubit(
        const AntSectionFailure('Could not reach the server.'),
      );

      await _reveal(tester, find.text('October 2026'));
      await tester.tap(find.text('October 2026'));
      await tester.pumpAndSettle();
      expect(find.text(l10n.antCutItemsLoadError), findsOneWidget);
      await tester.tap(
        find.descendant(
          of: find.byType(AntCutSheet),
          matching: find.text(l10n.commonRetry),
        ),
      );

      verify(() => items.load(octoberBudgetId)).called(2);
    });

    testWidgets('explains the cuts when there is none yet', (tester) async {
      await pumpScreen(
        tester,
        insights: antInsightsLoaded.copyWith(cuts: const AntSectionLoaded([])),
      );

      await _reveal(tester, find.text(l10n.antCutsEmpty));
      expect(find.text(l10n.antCutsEmpty), findsOneWidget);
    });
  });

  group('navigation', () {
    testWidgets('goes back to the expenses hub', (tester) async {
      await pumpScreen(tester);
      registerExpensesHubBloc(const ExpensesHubState());

      await tester.tap(
        find.byTooltip(l10n.commonBackTo(AppRoute.expenses.title(l10n))),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ExpensesHubScreen), findsOneWidget);
    });

    testWidgets('links to the budget overview from the cut hint',
        (tester) async {
      await pumpScreen(tester, size: TestViewports.expenseWidths.first);
      registerMonthlyBudgetBloc(MonthlyBudgetState(month: DateTime(2026, 11)));

      final link = find.text(l10n.expenseOpenBudgetOverview);
      await _reveal(tester, link);
      await tester.tap(link);
      await tester.pumpAndSettle();

      expect(find.byType(BudgetOverviewScreen), findsOneWidget);
    });
  });
}
