import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/time/month_format.dart';
import 'package:pennypincher_pro/core/utils/currency_formatter.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/utils/percent_formatter.dart';
import 'package:pennypincher_pro/core/widgets/chart_style.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/monthly_comparison_entity.dart';
import 'package:pennypincher_pro/features/budget/presentation/budget_texts.dart';
import 'package:pennypincher_pro/features/budget/presentation/widget/budget_comparison_scale.dart';

/// Income and expense bars per month with the cash flow line behind them.
/// A month without a budget shows an empty bar; it is labeled `No budget`
/// under the bars when there is room, and always in its tooltip and the
/// legend. Bars and labels size themselves to the width of each month.
/// The line chart reserves the same axes so its points stay centered over
/// each group of bars, and sits below the bars so their tooltips are drawn
/// over it.
class BudgetComparisonChart extends StatelessWidget {
  const BudgetComparisonChart({required this.months, super.key});

  static const double height = 300;
  static const double axisWidth = 64;
  static const double bottomAxisHeight = 40;
  static const double lineWidth = 2.5;
  static const double dotRadius = 3.5;
  static const double emptyOpacity = 0.35;
  static const double tooltipWidth = 240;

  static const Color incomeColor = AppColors.brandPrimary;
  static const Color expensesColor = AppColors.warning;
  static const Color cashFlowColor = AppColors.accentTeal;
  static const Color emptyColor = AppColors.borderDefault;

  /// Oldest first; must not be empty.
  final List<MonthComparison> months;

  @override
  Widget build(BuildContext context) {
    final scale = BudgetComparisonScale.of(months);
    return Semantics(
      container: true,
      label: _description(),
      child: ExcludeSemantics(
        child: SizedBox(
          height: height,
          child: LayoutBuilder(
            builder: (context, constraints) => Stack(
              children: [
                Positioned.fill(
                  child: IgnorePointer(
                    child: LineChart(ComparisonLine(months, scale).build()),
                  ),
                ),
                Positioned.fill(
                  child: BarChart(
                    ComparisonBars(
                      months,
                      scale,
                      groupWidth: groupWidthOf(constraints.maxWidth),
                    ).build(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Width of the plot given to each month at a chart [width].
  double groupWidthOf(double width) =>
      math.max(width - axisWidth, 0) / months.length;

  String _description() {
    final withBudget = months.where((month) => month.exists).length;
    return '${BudgetTexts.comparisonChartLabel}, '
        '${MonthFormat.long.format(months.first.month)} – '
        '${MonthFormat.long.format(months.last.month)}, $withBudget '
        '${BudgetTexts.monthsWithBudget}';
  }
}

/// Bars of a [BudgetComparisonChart].
class ComparisonBars {
  const ComparisonBars(this.months, this.scale, {required this.groupWidth});

  /// Share of a month's width taken by each of its two bars, and the
  /// limits of a bar's width.
  static const double rodShare = 0.28;
  static const double minRodWidth = 4;
  static const double maxRodWidth = 18;

  /// Gap between the two bars of a month, as a share of a bar's width.
  static const double rodSpaceShare = 0.3;

  /// Narrower months get the month and year on two lines and no
  /// `No budget` label.
  static const double wideLabelWidth = 72;

  final List<MonthComparison> months;
  final BudgetComparisonScale scale;

  /// Width of the plot given to each month.
  final double groupWidth;

  double get rodWidth =>
      (groupWidth * rodShare).clamp(minRodWidth, maxRodWidth).toDouble();

  bool get wideLabels => groupWidth >= wideLabelWidth;

  BarChartData build() => BarChartData(
        alignment: BarChartAlignment.spaceAround,
        minY: scale.minY,
        maxY: scale.maxY,
        barGroups: [
          for (final (index, month) in months.indexed) _group(index, month),
        ],
        gridData: ChartStyle.horizontalGrid(scale.interval),
        borderData: FlBorderData(show: false),
        barTouchData: BarTouchData(
          allowTouchBarBackDraw: true,
          touchTooltipData: _tooltip(),
        ),
        titlesData: _titles(),
      );

  BarChartGroupData _group(int index, MonthComparison month) {
    final figures = month.figures;
    return BarChartGroupData(
      x: index,
      barsSpace: rodWidth * rodSpaceShare,
      barRods: [
        _rod(figures?.totalIncome, BudgetComparisonChart.incomeColor),
        _rod(figures?.totalExpenses, BudgetComparisonChart.expensesColor),
      ],
    );
  }

  /// A full-height faded bar when there is no [amount].
  BarChartRodData _rod(Money? amount, Color color) => BarChartRodData(
        toY: amount?.pesos ?? 0,
        color: amount == null ? Colors.transparent : color,
        width: rodWidth,
        borderRadius: BorderRadius.zero,
        backDrawRodData: BackgroundBarChartRodData(
          show: amount == null,
          toY: scale.maxY,
          color: BudgetComparisonChart.emptyColor
              .withOpacity(BudgetComparisonChart.emptyOpacity),
        ),
      );

  BarTouchTooltipData _tooltip() => BarTouchTooltipData(
        getTooltipColor: ChartStyle.tooltipColor,
        fitInsideHorizontally: true,
        fitInsideVertically: true,
        maxContentWidth: BudgetComparisonChart.tooltipWidth,
        getTooltipItem: (group, groupIndex, rod, rodIndex) =>
            tooltipOf(months[groupIndex]),
      );

  /// Month and figures of [month], or `No budget`.
  static BarTooltipItem tooltipOf(MonthComparison month) {
    final figures = month.figures;
    final percentage = figures?.cashFlowPercentage;
    return BarTooltipItem(
      '${MonthFormat.long.format(month.month)}\n',
      AppTypography.bodySmall,
      textAlign: TextAlign.left,
      children: figures == null
          ? [_line(BudgetTexts.noBudget)]
          : [
              _line('${BudgetTexts.income} '
                  '${CurrencyFormatter.format(figures.totalIncome)}\n'),
              _line('${BudgetTexts.expenses} '
                  '${CurrencyFormatter.format(figures.totalExpenses)}\n'),
              _line('${BudgetTexts.cashFlow} '
                  '${CurrencyFormatter.format(figures.cashFlow)}'
                  '${percentage == null ? '' : '${BudgetTexts.detailSeparator}'
                      '${PercentFormatter.format(percentage)}'}'),
            ],
    );
  }

  static TextSpan _line(String text) =>
      TextSpan(text: text, style: ChartStyle.tooltipValue);

  FlTitlesData _titles() => FlTitlesData(
        topTitles: const AxisTitles(),
        rightTitles: const AxisTitles(),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: BudgetComparisonChart.axisWidth,
            interval: scale.interval,
            getTitlesWidget: ChartStyle.millionsLabel,
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: BudgetComparisonChart.bottomAxisHeight,
            getTitlesWidget: _xLabel,
          ),
        ),
      );

  Widget _xLabel(double value, TitleMeta meta) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      fitInside: SideTitleFitInsideData.fromTitleMeta(meta),
      child: Text(
        labelOf(months[value.toInt()]),
        style: AppTypography.bodySmall,
        textAlign: TextAlign.center,
      ),
    );
  }

  /// `May '26`, with `No budget` below for a month without one, when
  /// there is room; `May` over `'26` otherwise.
  String labelOf(MonthComparison month) {
    if (!wideLabels) {
      return MonthFormat.axisStacked.format(month.month);
    }
    final label = MonthFormat.axis.format(month.month);
    return month.exists ? label : '$label\n${BudgetTexts.noBudget}';
  }
}

/// Cash flow line of a [BudgetComparisonChart], with a gap at each month
/// without a budget.
class ComparisonLine {
  const ComparisonLine(this.months, this.scale);

  final List<MonthComparison> months;
  final BudgetComparisonScale scale;

  LineChartData build() => LineChartData(
        minX: -BudgetComparisonScale.groupHalfWidth,
        maxX: months.length - BudgetComparisonScale.groupHalfWidth,
        minY: scale.minY,
        maxY: scale.maxY,
        lineBarsData: [_cashFlow()],
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        lineTouchData: const LineTouchData(enabled: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
          leftTitles: _reserved(BudgetComparisonChart.axisWidth),
          bottomTitles: _reserved(BudgetComparisonChart.bottomAxisHeight),
        ),
      );

  LineChartBarData _cashFlow() => LineChartBarData(
        spots: spots(),
        color: BudgetComparisonChart.cashFlowColor,
        barWidth: BudgetComparisonChart.lineWidth,
        dotData: FlDotData(
          getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
            radius: BudgetComparisonChart.dotRadius,
            color: BudgetComparisonChart.cashFlowColor,
          ),
        ),
      );

  List<FlSpot> spots() => [
        for (final (index, month) in months.indexed)
          if (month.figures case final figures?)
            FlSpot(index.toDouble(), figures.cashFlow.pesos)
          else
            FlSpot.nullSpot,
      ];

  /// Same space as the bar chart axis, without labels.
  static AxisTitles _reserved(double size) => AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: size,
          getTitlesWidget: (_, __) => const SizedBox.shrink(),
        ),
      );
}
