import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/time/month_format.dart';
import 'package:pennypincher_pro/core/utils/chart_axis.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/utils/money_formatter.dart';
import 'package:pennypincher_pro/core/widgets/chart_legend.dart';
import 'package:pennypincher_pro/core/widgets/chart_style.dart';
import 'package:pennypincher_pro/core/widgets/money_format_scope.dart';
import 'package:pennypincher_pro/core/widgets/report_section_card.dart';
import 'package:pennypincher_pro/core/widgets/time_range_selector.dart';
import 'package:pennypincher_pro/features/ant_expenses/domain/entity/ant_expense_report_entity.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/bloc/ant_section.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/widget/ant_section_states.dart';

/// Spending per month of purchase over the last 6 or 12 months, with the
/// monthly limit as a dashed line when there is one.
class AntTrendCard extends StatelessWidget {
  const AntTrendCard({
    required this.trend,
    required this.months,
    required this.limit,
    required this.onMonthsChanged,
    required this.onRetry,
    super.key,
  });

  static const Key selectorKey = Key('ant-trend-months');

  final AntSection<List<AntTrendMonth>> trend;
  final int months;
  final Money? limit;
  final ValueChanged<int> onMonthsChanged;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ReportSectionCard(
      title: l10n.antTrendTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: SegmentedButton<int>(
              key: selectorKey,
              showSelectedIcon: false,
              style: TimeRangeSelector.style,
              segments: [
                ButtonSegment(
                  value: AntExpenseLimits.shortTrendMonths,
                  label: Text(l10n.timeRangeSixMonths),
                ),
                ButtonSegment(
                  value: AntExpenseLimits.longTrendMonths,
                  label: Text(l10n.timeRangeOneYear),
                ),
              ],
              selected: {months},
              onSelectionChanged: (selected) =>
                  onMonthsChanged(selected.single),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          switch (trend) {
            AntSectionLoading() => const AntSectionSkeleton(
                heights: [AntTrendChart.height],
              ),
            AntSectionFailure(:final message) => AntSectionError(
                title: l10n.antTrendLoadError,
                message: message,
                onRetry: onRetry,
              ),
            AntSectionLoaded(:final value) when value.isEmpty => Text(
                l10n.antTrendEmpty,
                style: AppTypography.bodyMedium,
              ),
            AntSectionLoaded(:final value) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AntTrendChart(months: value, limit: limit),
                  const SizedBox(height: AppSpacing.sm),
                  ChartLegend(
                    entries: [
                      LegendEntry(
                        color: AntTrendChart.barColor,
                        label: l10n.antTrendSpent,
                      ),
                      if (limit != null)
                        LegendEntry(
                          color: AntTrendChart.limitColor,
                          label: l10n.antLimitTitle,
                        ),
                    ],
                  ),
                ],
              ),
          },
        ],
      ),
    );
  }
}

/// Bars of the spending of each month, oldest first, sized to the width
/// of each month. Screen readers get a one-sentence description instead.
class AntTrendChart extends StatelessWidget {
  const AntTrendChart({required this.months, required this.limit, super.key});

  static const double height = 220;
  static const double axisWidth = 64;
  static const double bottomAxisHeight = 40;
  static const double rodShare = 0.5;
  static const double minRodWidth = 4;
  static const double maxRodWidth = 28;
  static const double tooltipWidth = 200;

  /// Narrower months get the month and year on two lines.
  static const double wideLabelWidth = 56;
  static const List<int> limitDash = [6, 4];

  static const Color barColor = AppColors.accentGold;
  static const Color limitColor = AppColors.error;

  /// Oldest first; must not be empty.
  final List<AntTrendMonth> months;
  final Money? limit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final money = context.money;
    return Semantics(
      container: true,
      label: _description(l10n, money),
      child: ExcludeSemantics(
        child: SizedBox(
          height: height,
          child: LayoutBuilder(
            builder: (context, constraints) => BarChart(
              _data(
                l10n,
                money,
                math.max(constraints.maxWidth - axisWidth, 0) / months.length,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _description(AppLocalizations l10n, MoneyFormatter money) {
    final highest =
        months.reduce((a, b) => b.total.compareTo(a.total) > 0 ? b : a);
    return l10n.antTrendDescription(
      MonthFormat.long.format(months.first.month),
      MonthFormat.long.format(months.last.month),
      money.format(highest.total),
      MonthFormat.long.format(highest.month),
    );
  }

  BarChartData _data(
    AppLocalizations l10n,
    MoneyFormatter money,
    double groupWidth,
  ) {
    final limit = this.limit;
    final high = [
      0.0,
      for (final month in months) month.total.units,
      if (limit != null) limit.units,
    ].reduce(math.max);
    final interval = ChartAxis.niceInterval(high);
    final maxY =
        math.max((high / interval).ceilToDouble() * interval, interval);
    final rodWidth =
        (groupWidth * rodShare).clamp(minRodWidth, maxRodWidth).toDouble();
    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      minY: 0,
      maxY: maxY,
      barGroups: [
        for (final (index, month) in months.indexed)
          BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: month.total.units,
                color: barColor,
                width: rodWidth,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppSpacing.xxs),
                ),
              ),
            ],
          ),
      ],
      gridData: ChartStyle.horizontalGrid(interval),
      borderData: FlBorderData(show: false),
      extraLinesData: ExtraLinesData(
        horizontalLines: [
          if (limit != null)
            HorizontalLine(
              y: limit.units,
              color: limitColor,
              strokeWidth: 1.5,
              dashArray: limitDash,
            ),
        ],
      ),
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: ChartStyle.tooltipColor,
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          maxContentWidth: tooltipWidth,
          getTooltipItem: (group, groupIndex, rod, rodIndex) =>
              tooltipOf(l10n, money, months[groupIndex]),
        ),
      ),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(),
        rightTitles: const AxisTitles(),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: axisWidth,
            interval: interval,
            getTitlesWidget: ChartStyle.amountLabel(money),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: bottomAxisHeight,
            getTitlesWidget: (value, meta) => SideTitleWidget(
              axisSide: meta.axisSide,
              fitInside: SideTitleFitInsideData.fromTitleMeta(meta),
              child: Text(
                (groupWidth >= wideLabelWidth
                        ? MonthFormat.axis
                        : MonthFormat.axisStacked)
                    .format(months[value.toInt()].month),
                style: AppTypography.bodySmall,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Month, amount and number of expenses of [month].
  static BarTooltipItem tooltipOf(
    AppLocalizations l10n,
    MoneyFormatter money,
    AntTrendMonth month,
  ) =>
      BarTooltipItem(
        '${MonthFormat.long.format(month.month)}\n',
        AppTypography.bodySmall,
        textAlign: TextAlign.left,
        children: [
          TextSpan(
            text: '${money.format(month.total)}\n',
            style: ChartStyle.tooltipValue,
          ),
          TextSpan(
            text: l10n.expenseItemCount(month.count),
            style: ChartStyle.tooltipValue,
          ),
        ],
      );
}
