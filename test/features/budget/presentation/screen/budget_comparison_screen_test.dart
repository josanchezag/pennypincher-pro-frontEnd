import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/time/month_format.dart';
import 'package:pennypincher_pro/core/utils/currency_formatter.dart';
import 'package:pennypincher_pro/core/utils/percent_formatter.dart';
import 'package:pennypincher_pro/core/widgets/loading_skeleton.dart';
import 'package:pennypincher_pro/features/budget/presentation/bloc/budget_comparison_bloc.dart';
import 'package:pennypincher_pro/features/budget/presentation/bloc/monthly_budget_bloc.dart';
import 'package:pennypincher_pro/features/budget/presentation/budget_texts.dart';
import 'package:pennypincher_pro/features/budget/presentation/screen/budget_comparison_screen.dart';
import 'package:pennypincher_pro/features/budget/presentation/widget/budget_comparison_chart.dart';
import 'package:pennypincher_pro/features/budget/presentation/widget/budget_comparison_scale.dart';
import 'package:pennypincher_pro/features/budget/presentation/widget/budget_comparison_table.dart';

import '../../../../helpers/budget_fixtures.dart';
import '../../../../helpers/budget_mocks.dart';
import '../../../../helpers/load_fonts.dart';
import '../../../../helpers/pump_app.dart';

final BudgetComparisonState _loaded = BudgetComparisonState(
  status: ComparisonStatus.loaded,
  months: sixMonthComparison,
);

String _location(WidgetTester tester) => GoRouter.of(
      tester.element(find.byType(Scaffold).first),
    ).routeInformationProvider.value.uri.path;

void main() {
  setUpAll(loadAppFonts);

  Future<MockBudgetComparisonBloc> pumpComparison(
    WidgetTester tester,
    BudgetComparisonState state, {
    Size size = TestViewports.mobile,
  }) async {
    final bloc = registerBudgetComparisonBloc(state);
    await tester.pumpApp(
      location: AppRoute.budgetComparison.path,
      size: size,
      settle: false,
    );
    await tester.pump(const Duration(seconds: 1));
    return bloc;
  }

  Future<void> reveal(WidgetTester tester, Finder finder) async {
    await tester.scrollUntilVisible(
      finder,
      200,
      scrollable: find
          .descendant(
            of: find.byType(BudgetComparisonScreen),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.pump();
  }

  testWidgets('starts loading when it opens', (tester) async {
    final bloc = await pumpComparison(tester, const BudgetComparisonState());

    expect(find.byType(LoadingSkeleton), findsOneWidget);
    verify(() => bloc.add(const BudgetComparisonLoadRequested())).called(1);
  });

  testWidgets('offers a retry when loading fails', (tester) async {
    final bloc = await pumpComparison(
      tester,
      const BudgetComparisonState(
        status: ComparisonStatus.failure,
        error: 'Offline',
      ),
    );
    clearInteractions(bloc);

    expect(find.text('Offline'), findsOneWidget);
    await tester.tap(find.byKey(BudgetComparisonScreen.retryKey));

    verify(() => bloc.add(const BudgetComparisonLoadRequested())).called(1);
  });

  testWidgets('links to the budget when no month has one', (tester) async {
    await pumpComparison(
      tester,
      BudgetComparisonState(
        status: ComparisonStatus.loaded,
        months: [comparisonOf(9), comparisonOf(10)],
      ),
    );
    registerMonthlyBudgetBloc(MonthlyBudgetState(month: DateTime(2026, 10)));

    expect(find.text(BudgetTexts.comparisonEmptyTitle), findsOneWidget);
    await tester.tap(find.byKey(BudgetComparisonScreen.openBudgetKey));
    await tester.pump(const Duration(seconds: 1));

    expect(_location(tester), AppRoute.budgetOverview.path);
  });

  testWidgets('goes back to the budget overview', (tester) async {
    await pumpComparison(tester, _loaded);
    registerMonthlyBudgetBloc(MonthlyBudgetState(month: DateTime(2026, 10)));

    await tester.tap(find.byTooltip(BudgetTexts.backToBudget));
    await tester.pump(const Duration(seconds: 1));

    expect(_location(tester), AppRoute.budgetOverview.path);
  });

  testWidgets('names the compared months', (tester) async {
    await pumpComparison(tester, _loaded);

    expect(find.text('Last 6 months up to October 2026'), findsOneWidget);
  });

  group('chart', () {
    testWidgets('groups income and expense bars per month', (tester) async {
      await pumpComparison(tester, _loaded);

      final chart = tester.widget<BarChart>(find.byType(BarChart));
      final groups = chart.data.barGroups;
      expect(groups, hasLength(6));
      expect(chart.data.alignment, BarChartAlignment.spaceAround);
      final [income, expenses] = groups.first.barRods;
      expect(income.color, BudgetComparisonChart.incomeColor);
      expect(income.toY, 30e6);
      expect(expenses.color, BudgetComparisonChart.expensesColor);
      expect(expenses.toY, 20e6);
    });

    testWidgets('shows an empty bar labeled No budget for a missing month',
        (tester) async {
      await pumpComparison(tester, _loaded, size: TestViewports.desktop);

      final chart = tester.widget<BarChart>(find.byType(BarChart));
      final july = chart.data.barGroups[2].barRods;
      expect(july.every((rod) => rod.toY == 0), isTrue);
      expect(july.every((rod) => rod.backDrawRodData.show), isTrue);
      expect(chart.data.barTouchData.allowTouchBarBackDraw, isTrue);
      expect(find.text("Jul '26\n${BudgetTexts.noBudget}"), findsOneWidget);
    });

    test('tells a missing month apart in its tooltip', () {
      final missing = ComparisonBars.tooltipOf(comparisonOf(7));
      final october = ComparisonBars.tooltipOf(sixMonthComparison.last);

      expect(missing.text, 'July 2026\n');
      expect(missing.children?.single.text, BudgetTexts.noBudget);
      final lines = october.children!.map((span) => span.text).join();
      expect(lines, contains(PercentFormatter.format(48.5)));
    });

    testWidgets('lays the cash flow line over the bar groups with a gap',
        (tester) async {
      await pumpComparison(tester, _loaded);

      final line = tester.widget<LineChart>(find.byType(LineChart));
      final bar = tester.widget<BarChart>(find.byType(BarChart));
      expect(line.data.minX, -0.5);
      expect(line.data.maxX, 5.5);
      expect(line.data.minY, bar.data.minY);
      expect(line.data.maxY, bar.data.maxY);
      final spots = line.data.lineBarsData.single.spots;
      expect(spots[2], FlSpot.nullSpot);
      expect(spots[3], const FlSpot(3, 9e6));
      expect(spots[4].y, -3e6);
      expect(
        find.ancestor(
          of: find.byType(LineChart),
          matching: find.byType(IgnorePointer),
        ),
        findsWidgets,
      );
    });

    testWidgets('keeps the month labels apart on a narrow phone',
        (tester) async {
      await pumpComparison(tester, _loaded);

      final labels = [
        for (final month in sixMonthComparison)
          tester.getRect(
            find.text(MonthFormat.axisStacked.format(month.month)),
          ),
      ];
      for (var index = 1; index < labels.length; index++) {
        expect(labels[index - 1].right, lessThan(labels[index].left));
      }
      expect(find.textContaining(BudgetTexts.noBudget), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    test('sizes the bars to the room of each month', () {
      final scale = BudgetComparisonScale.of(sixMonthComparison);
      double rodWidthAt(double groupWidth) =>
          ComparisonBars(sixMonthComparison, scale, groupWidth: groupWidth)
              .rodWidth;

      expect(rodWidthAt(40), lessThan(rodWidthAt(50)));
      expect(rodWidthAt(1), ComparisonBars.minRodWidth);
      expect(rodWidthAt(500), ComparisonBars.maxRodWidth);
    });

    testWidgets('gives narrow months thinner bars', (tester) async {
      await pumpComparison(tester, _loaded);

      final chart = tester.widget<BarChart>(find.byType(BarChart));
      final rods = chart.data.barGroups.first.barRods;
      expect(rods.first.width, lessThan(ComparisonBars.maxRodWidth));
      expect(chart.data.barGroups.first.barsSpace, lessThan(rods.first.width));
    });

    testWidgets('draws the cash flow line below the bars and their tooltips',
        (tester) async {
      await pumpComparison(tester, _loaded);

      final stack = tester.widget<Stack>(
        find
            .ancestor(of: find.byType(BarChart), matching: find.byType(Stack))
            .first,
      );
      final layers = [
        for (final child in stack.children)
          find.descendant(
            of: find.byWidget(child),
            matching: find.byType(LineChart),
          ),
      ];
      expect(layers.first, findsOneWidget);
      expect(layers.last, findsNothing);
    });

    testWidgets('centers each line point over its bar group', (tester) async {
      await pumpComparison(tester, _loaded, size: TestViewports.desktop);

      final barBox = tester.getRect(find.byType(BarChart));
      final lineBox = tester.getRect(find.byType(LineChart));
      expect(lineBox, barBox);
    });

    testWidgets('describes the chart to screen readers', (tester) async {
      final semantics = tester.ensureSemantics();
      await pumpComparison(tester, _loaded);

      expect(
        find.bySemanticsLabel(
          RegExp(
            '^${BudgetTexts.comparisonChartLabel}, May 2026 – October 2026, '
            '5 ${BudgetTexts.monthsWithBudget}',
          ),
        ),
        findsOneWidget,
      );
      semantics.dispose();
    });
  });

  group('table', () {
    final colors = {
      30.0: AppColors.warning,
      30.01: AppColors.success,
      10.0: AppColors.warning,
      9.99: AppColors.error,
    };
    for (final MapEntry(key: percentage, value: color) in colors.entries) {
      test('colors a cash flow share of $percentage %', () {
        final cell = BudgetComparisonTable.percentCell(percentage);

        expect(cell.color, color);
        expect(cell.text, PercentFormatter.format(percentage));
      });
    }

    test('shows dashes for a month without a budget', () {
      final cells = BudgetComparisonTable.cellsOf(comparisonOf(7));

      expect(cells.first.text, 'Jul 2026');
      expect(
        cells.skip(1).map((cell) => cell.text),
        everyElement(BudgetTexts.noValue),
      );
      expect(BudgetComparisonTable.percentCell(null).text, BudgetTexts.noValue);
    });

    test('shows a negative cash flow in red', () {
      final cells = BudgetComparisonTable.cellsOf(sixMonthComparison[4]);

      expect(cells[3].color, AppColors.error);
      expect(cells[4].color, AppColors.error);
    });

    testWidgets('lists the months newest first', (tester) async {
      await pumpComparison(tester, _loaded, size: TestViewports.desktop);
      await reveal(tester, find.byType(DataTable));

      final table = tester.widget<DataTable>(find.byType(DataTable));
      expect(table.rows, hasLength(6));
      expect(
        tester.getTopLeft(find.text('Oct 2026')).dy,
        lessThan(tester.getTopLeft(find.text('May 2026')).dy),
      );
      expect(
        find.text(
          CurrencyFormatter.format(
            sixMonthComparison.last.figures!.cashFlow,
          ),
        ),
        findsOneWidget,
      );
    });
  });

  for (final size in TestViewports.expenseWidths) {
    testWidgets('fits at ${size.width.toInt()} px', (tester) async {
      await pumpComparison(tester, _loaded, size: size);
      expect(tester.takeException(), isNull);

      await reveal(tester, find.text('May 2026'));

      expect(tester.takeException(), isNull);
      final percent = find.text(PercentFormatter.format(33.33));
      expect(tester.getRect(percent).right, lessThanOrEqualTo(size.width));
    });
  }
}
