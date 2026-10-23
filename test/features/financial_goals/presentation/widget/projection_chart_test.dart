import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_theme.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/utils/currency_formatter.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_projection_entity.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/projection_chart.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/projection_scale.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/projection_summary.dart';

import '../../../../helpers/goal_fixtures.dart';

final GoalProjection _reachable = computedProjection(
  target: 605000000,
  current: netWorth,
  monthly: 1470000,
);
final GoalProjection _unreachable = computedProjection(
  target: 4366000000,
  current: netWorth,
  monthly: 0,
  annual: 0.001,
);
final GoalProjection _reached = computedProjection(
  target: 400000000,
  current: netWorth,
  monthly: 1000,
);

Future<LineChartData> _pumpChart(
  WidgetTester tester,
  GoalProjection projection,
) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.dark,
      home: Scaffold(body: ProjectionChart(projection: projection)),
    ),
  );
  return tester.widget<LineChart>(find.byType(LineChart)).data;
}

void main() {
  group('scale', () {
    test('runs in years from now and leaves room above the target', () {
      final scale = ProjectionScale.of(_reachable);

      expect(_reachable.projectedMonthsToGoal, 31);
      expect(scale.maxX, 31 / 12);
      expect(scale.xInterval, 1);
      expect(scale.minY, 0);
      expect(scale.maxY, greaterThan(605000000));
    });

    test('goes below zero for a negative net worth', () {
      final scale = ProjectionScale.of(
        computedProjection(
          target: 100000000,
          current: const Money.fromPesos(-50000000),
          monthly: 3000000,
        ),
      );

      expect(scale.minY, lessThan(0));
    });

    test('labels every ten years over fifty years', () {
      final scale = ProjectionScale.of(_unreachable);

      expect(scale.maxX, 50);
      expect(scale.xInterval, 10);
    });
  });

  testWidgets('draws the projected values from the current net worth',
      (tester) async {
    final data = await _pumpChart(tester, _reachable);

    final spots = data.lineBarsData.single.spots;
    expect(spots.first, FlSpot(0, netWorth.pesos));
    expect(spots, hasLength(_reachable.dataPoints.length));
    expect(spots.last.x, 31 / 12);
  });

  testWidgets('draws the target as a dashed horizontal line', (tester) async {
    final data = await _pumpChart(tester, _reachable);

    final target = data.extraLinesData.horizontalLines.single;
    expect(target.y, 605000000);
    expect(target.dashArray, ProjectionChart.targetDash);
    expect(target.color, AppColors.accentGold);
  });

  testWidgets('marks the month the target is reached', (tester) async {
    final data = await _pumpChart(tester, _reachable);

    final marker = data.extraLinesData.verticalLines.single;
    expect(marker.x, 31 / 12);
    final dots = data.lineBarsData.single.dotData;
    final bar = data.lineBarsData.single;
    expect(dots.checkToShowDot(const FlSpot(31 / 12, 1), bar), isTrue);
    expect(dots.checkToShowDot(const FlSpot(1, 1), bar), isFalse);
  });

  testWidgets('marks the start when the goal is already reached',
      (tester) async {
    final data = await _pumpChart(tester, _reached);

    expect(data.extraLinesData.verticalLines.single.x, 0);
    expect(data.maxX, 1);
  });

  testWidgets('has no marker when the goal is not reachable', (tester) async {
    final data = await _pumpChart(tester, _unreachable);

    expect(data.extraLinesData.verticalLines, isEmpty);
    expect(data.extraLinesData.horizontalLines, hasLength(1));
  });

  testWidgets('shows the value and month of a point in its tooltip',
      (tester) async {
    final data = await _pumpChart(tester, _reachable);

    final bar = data.lineBarsData.single;
    final items = data.lineTouchData.touchTooltipData
        .getTooltipItems([LineBarSpot(bar, 0, bar.spots[12])]);
    final item = items.single!;
    expect(
      item.text,
      '${CurrencyFormatter.format(_reachable.dataPoints[12].projectedValue)}\n',
    );
    expect(item.children!.single.toPlainText(), 'October 2027');
  });

  testWidgets('keeps tooltip values of ten digits on one line', (tester) async {
    final data = await _pumpChart(tester, _reachable);

    final painter = TextPainter(
      text: TextSpan(
        text: CurrencyFormatter.format(const Money.fromPesos(1021304980)),
        style: AppTypography.monoMedium,
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    addTearDown(painter.dispose);
    expect(
      data.lineTouchData.touchTooltipData.maxContentWidth,
      greaterThan(painter.width),
    );
  });

  testWidgets('fits y labels of hundreds of thousands of millions',
      (tester) async {
    final huge = computedProjection(
      target: 100000000000,
      current: netWorth,
      monthly: 15850000,
    );
    final data = await _pumpChart(tester, huge);

    final top = CurrencyFormatter.formatCompact(data.maxY);
    expect(top, '150.000M');
    final oneLine = tester.getSize(find.text('0').first).height;
    expect(tester.getSize(find.text(top)).height, oneLine);
    expect(
      data.titlesData.leftTitles.sideTitles.reservedSize,
      greaterThan(ProjectionChart.minLeftAxisWidth),
    );
  });

  testWidgets('labels the axes in millions and whole years', (tester) async {
    await _pumpChart(tester, _reachable);

    expect(find.text('600M'), findsOneWidget);
    expect(find.text('Years from now'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.textContaining(','), findsNothing);
  });

  testWidgets('describes the chart to screen readers', (tester) async {
    final semantics = tester.ensureSemantics();
    await _pumpChart(tester, _reachable);

    expect(
      find.bySemanticsLabel(RegExp('Projection chart of Seguridad Financiera')),
      findsOneWidget,
    );
    semantics.dispose();
  });

  group('summary', () {
    test('says when the goal is reached at this rate', () {
      expect(
        ProjectionSummary.textOf(_reachable),
        "At this rate, you'll reach Seguridad Financiera in 2,58 years "
        'on May 2029',
      );
    });

    test('says a single year in the singular', () {
      final inAYear = _reachable.copyWith(projectedYearsToGoal: 1);

      expect(ProjectionSummary.textOf(inAYear), contains('in 1 year on'));
    });

    test('says when the goal is already reached', () {
      expect(
        ProjectionSummary.textOf(_reached),
        "You've already reached Seguridad Financiera: your current net "
        'worth covers its target.',
      );
    });

    test('says when the goal is out of reach', () {
      expect(
        ProjectionSummary.textOf(_unreachable),
        startsWith(
          "At this rate, you won't reach Seguridad Financiera within 50 years",
        ),
      );
    });
  });
}
