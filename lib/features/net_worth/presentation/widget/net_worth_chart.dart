import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/utils/currency_formatter.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/net_worth_snapshot_entity.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/widget/chart_scale.dart';

/// Line chart of the monthly net worth with a gradient fill and a tooltip
/// per point. The y axis stays fixed while the months scroll horizontally
/// once they no longer fit, starting at the latest month.
class NetWorthChart extends StatelessWidget {
  const NetWorthChart({required this.history, super.key});

  static const double height = 260;
  static const double axisWidth = 56;
  static const double axisLabelWidth = axisWidth - AppSpacing.borderWidth;

  /// Widest month column; narrower screens shrink it so that
  /// [ChartScale.minVisibleMonths] always fit.
  static const double maxMonthWidth = 56;

  /// Narrower month columns label every other month so labels never
  /// overlap.
  static const double minLabelWidth = 52;
  static const int sparseLabelStep = 2;

  /// Room after the last month so its label and touch dot are not clipped.
  static const double endPadding = AppSpacing.lg;
  static const double bottomAxisHeight = 28;
  static const double lineWidth = 3;
  static const double dotRadius = 3;
  static const String semanticsPrefix = 'Net worth history chart';

  static final DateFormat monthLabel = DateFormat("MMM ''yy");
  static final DateFormat tooltipMonth = DateFormat('MMMM yyyy');

  /// Snapshots sorted from the oldest month; must not be empty.
  final List<NetWorthSnapshot> history;

  @override
  Widget build(BuildContext context) {
    final scale = ChartScale.of(history);
    return Semantics(
      container: true,
      label: _description(),
      child: ExcludeSemantics(
        child: SizedBox(
          height: height,
          child: Row(
            children: [
              SizedBox(width: axisWidth, child: LineChart(_axisData(scale))),
              Expanded(child: _ScrollingChart(history: history, scale: scale)),
            ],
          ),
        ),
      ),
    );
  }

  String _description() {
    final first = tooltipMonth.format(history.first.snapshotDate);
    final last = history.last;
    return '$semanticsPrefix, ${history.length} months from $first to '
        '${tooltipMonth.format(last.snapshotDate)}, latest '
        '${CurrencyFormatter.format(last.netWorth)}';
  }

  /// Chart without data that only draws the y axis labels, aligned with
  /// the scrolling chart because both share the same scale and insets.
  static LineChartData _axisData(ChartScale scale) => LineChartData(
        minX: 0,
        maxX: 1,
        minY: scale.minY,
        maxY: scale.maxY,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        lineTouchData: const LineTouchData(enabled: false),
        titlesData: FlTitlesData(
          topTitles: _hidden,
          rightTitles: _hidden,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: bottomAxisHeight,
              getTitlesWidget: (_, __) => const SizedBox.shrink(),
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: axisLabelWidth,
              interval: scale.interval,
              getTitlesWidget: _yLabel,
            ),
          ),
        ),
      );

  static const AxisTitles _hidden = AxisTitles();

  static Widget _yLabel(double value, TitleMeta meta) => SideTitleWidget(
        axisSide: meta.axisSide,
        child: Text(
          CurrencyFormatter.formatCompact(value),
          style: AppTypography.monoSmall,
        ),
      );
}

class _ScrollingChart extends StatelessWidget {
  const _ScrollingChart({required this.history, required this.scale});

  final List<NetWorthSnapshot> history;
  final ChartScale scale;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final available = constraints.maxWidth - NetWorthChart.endPadding;
        final monthWidth = math.min(
          NetWorthChart.maxMonthWidth,
          available / ChartScale.minVisibleMonths,
        );
        final width = math.max(available, scale.visibleMonths * monthWidth);
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          reverse: true,
          padding: const EdgeInsets.only(right: NetWorthChart.endPadding),
          child: SizedBox(
            width: width,
            child: LineChart(
              _ChartData(
                history,
                scale,
                labelEvery: monthWidth < NetWorthChart.minLabelWidth
                    ? NetWorthChart.sparseLabelStep
                    : 1,
              ).build(),
            ),
          ),
        );
      },
    );
  }
}

/// fl_chart configuration of the data chart.
class _ChartData {
  const _ChartData(this.history, this.scale, {required this.labelEvery});

  final List<NetWorthSnapshot> history;
  final ChartScale scale;

  /// Months between two x labels, counted back from the latest month.
  final int labelEvery;

  LineChartData build() => LineChartData(
        minX: scale.minX,
        maxX: scale.maxX,
        minY: scale.minY,
        maxY: scale.maxY,
        lineBarsData: [_line()],
        gridData: FlGridData(
          drawVerticalLine: false,
          horizontalInterval: scale.interval,
          getDrawingHorizontalLine: (_) =>
              const FlLine(color: AppColors.borderMuted, strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        lineTouchData: LineTouchData(touchTooltipData: _tooltip()),
        titlesData: FlTitlesData(
          topTitles: NetWorthChart._hidden,
          rightTitles: NetWorthChart._hidden,
          leftTitles: NetWorthChart._hidden,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              reservedSize: NetWorthChart.bottomAxisHeight,
              getTitlesWidget: _xLabel,
            ),
          ),
        ),
      );

  LineChartBarData _line() => LineChartBarData(
        spots: [
          for (final snapshot in history)
            FlSpot(scale.xOf(snapshot.snapshotDate), snapshot.netWorth.pesos),
        ],
        color: AppColors.chartLinePositive,
        barWidth: NetWorthChart.lineWidth,
        dotData: FlDotData(
          getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
            radius: NetWorthChart.dotRadius,
            color: AppColors.chartLinePositive,
          ),
        ),
        belowBarData: BarAreaData(
          show: true,
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.chartGradientStart, AppColors.chartGradientEnd],
          ),
        ),
      );

  LineTouchTooltipData _tooltip() => LineTouchTooltipData(
        getTooltipColor: (_) => AppColors.backgroundModal,
        fitInsideHorizontally: true,
        fitInsideVertically: true,
        getTooltipItems: (spots) => [
          for (final spot in spots) _tooltipItem(spot),
        ],
      );

  LineTooltipItem _tooltipItem(LineBarSpot spot) {
    final snapshot = history[spot.spotIndex];
    return LineTooltipItem(
      '${CurrencyFormatter.format(snapshot.netWorth)}\n',
      AppTypography.monoMedium,
      children: [
        TextSpan(
          text: NetWorthChart.tooltipMonth.format(snapshot.snapshotDate),
          style: AppTypography.bodySmall,
        ),
      ],
    );
  }

  Widget _xLabel(double value, TitleMeta meta) {
    if ((scale.maxX - value).round() % labelEvery != 0) {
      return const SizedBox.shrink();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        NetWorthChart.monthLabel.format(scale.monthAt(value)),
        style: AppTypography.bodySmall,
      ),
    );
  }
}
