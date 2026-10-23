import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/time/month_format.dart';
import 'package:pennypincher_pro/core/utils/currency_formatter.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/widgets/chart_style.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/net_worth_trend_entity.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/net_worth_texts.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/widget/chart_scale.dart';

/// Full-width chart of a net worth report: the net worth line over the
/// assets and liabilities areas, with the best month marked, a tooltip per
/// month and the amounts in millions on the y axis. Month labels thin out
/// so they never overlap.
class FullHistoryChart extends StatelessWidget {
  const FullHistoryChart({required this.trend, super.key});

  static const double height = 320;
  static const double axisWidth = 64;
  static const double bottomAxisHeight = 28;
  static const double minLabelWidth = 64;
  static const double netWorthWidth = 3;
  static const double areaLineWidth = 1.5;
  static const double areaOpacity = 0.15;
  static const double bestDotRadius = 5;
  static const double tooltipWidth = 260;

  static const Color assetsColor = AppColors.success;
  static const Color liabilitiesColor = AppColors.error;
  static const Color netWorthColor = AppColors.brandPrimary;
  static const Color bestColor = AppColors.accentGold;

  /// Must not be empty.
  final NetWorthTrend trend;

  List<NetWorthTrendPoint> get _points => trend.points;

  ChartScale get scale => ChartScale.span(
        firstMonth: _points.first.month,
        lastMonth: _points.last.month,
        values: [
          for (final point in _points) ...[
            point.totalAssets.pesos,
            point.totalLiabilities.pesos,
            point.netWorth.pesos,
          ],
        ],
      );

  /// Months between two x labels so each label gets [minLabelWidth].
  static int labelStep(ChartScale scale, double width) => math.max(
        1,
        (scale.visibleMonths * minLabelWidth / math.max(width - axisWidth, 1))
            .ceil(),
      );

  @override
  Widget build(BuildContext context) {
    final chartScale = scale;
    return Semantics(
      container: true,
      label: _description(),
      child: ExcludeSemantics(
        child: SizedBox(
          height: height,
          child: LayoutBuilder(
            builder: (context, constraints) => LineChart(
              _ChartData(
                this,
                chartScale,
                labelStep(chartScale, constraints.maxWidth),
              ).build(),
            ),
          ),
        ),
      ),
    );
  }

  String _description() {
    final last = _points.last;
    return '${NetWorthTexts.reportChartLabel}, ${_points.length} '
        '${NetWorthTexts.months} ${NetWorthTexts.from} '
        '${MonthFormat.long.format(_points.first.month)} ${NetWorthTexts.to} '
        '${MonthFormat.long.format(last.month)}, ${NetWorthTexts.latest} '
        '${CurrencyFormatter.format(last.netWorth)}';
  }
}

/// fl_chart configuration of a [FullHistoryChart].
class _ChartData {
  const _ChartData(this.chart, this.scale, this.labelEvery);

  final FullHistoryChart chart;
  final ChartScale scale;
  final int labelEvery;

  List<NetWorthTrendPoint> get _points => chart.trend.points;

  LineChartData build() => LineChartData(
        minX: scale.minX,
        maxX: scale.maxX,
        minY: scale.minY,
        maxY: scale.maxY,
        lineBarsData: [
          _area((point) => point.totalAssets, FullHistoryChart.assetsColor),
          _area(
            (point) => point.totalLiabilities,
            FullHistoryChart.liabilitiesColor,
          ),
          _netWorth(),
        ],
        gridData: ChartStyle.horizontalGrid(scale.interval),
        borderData: FlBorderData(show: false),
        lineTouchData: LineTouchData(touchTooltipData: _tooltip()),
        titlesData: _titles(),
      );

  List<FlSpot> _spots(Money Function(NetWorthTrendPoint point) amountOf) => [
        for (final point in _points)
          FlSpot(scale.xOf(point.month), amountOf(point).pesos),
      ];

  LineChartBarData _area(
    Money Function(NetWorthTrendPoint point) amountOf,
    Color color,
  ) =>
      LineChartBarData(
        spots: _spots(amountOf),
        color: color,
        barWidth: FullHistoryChart.areaLineWidth,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          color: color.withOpacity(FullHistoryChart.areaOpacity),
        ),
      );

  LineChartBarData _netWorth() {
    final best = chart.trend.best;
    final bestX = best == null ? null : scale.xOf(best.month);
    return LineChartBarData(
      spots: _spots((point) => point.netWorth),
      color: FullHistoryChart.netWorthColor,
      barWidth: FullHistoryChart.netWorthWidth,
      dotData: FlDotData(
        checkToShowDot: (spot, _) => spot.x == bestX,
        getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
          radius: FullHistoryChart.bestDotRadius,
          color: FullHistoryChart.bestColor,
        ),
      ),
    );
  }

  LineTouchTooltipData _tooltip() => LineTouchTooltipData(
        getTooltipColor: ChartStyle.tooltipColor,
        fitInsideHorizontally: true,
        fitInsideVertically: true,
        maxContentWidth: FullHistoryChart.tooltipWidth,
        getTooltipItems: (spots) => [
          for (final (index, spot) in spots.indexed)
            index == 0 ? _tooltipItem(_points[spot.spotIndex]) : null,
        ],
      );

  static LineTooltipItem _tooltipItem(NetWorthTrendPoint point) =>
      LineTooltipItem(
        '${MonthFormat.long.format(point.month)}\n',
        AppTypography.bodySmall,
        textAlign: TextAlign.left,
        children: [
          _line(NetWorthTexts.netWorth, point.netWorth, newLine: true),
          _line(NetWorthTexts.totalAssets, point.totalAssets, newLine: true),
          _line(NetWorthTexts.totalLiabilities, point.totalLiabilities),
        ],
      );

  static TextSpan _line(String label, Money amount, {bool newLine = false}) =>
      TextSpan(
        text:
            '$label ${CurrencyFormatter.format(amount)}${newLine ? '\n' : ''}',
        style: ChartStyle.tooltipValue,
      );

  FlTitlesData _titles() => FlTitlesData(
        topTitles: const AxisTitles(),
        rightTitles: const AxisTitles(),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: FullHistoryChart.axisWidth,
            interval: scale.interval,
            getTitlesWidget: ChartStyle.millionsLabel,
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            reservedSize: FullHistoryChart.bottomAxisHeight,
            getTitlesWidget: _xLabel,
          ),
        ),
      );

  /// Every [labelEvery] months counted back from the latest one.
  Widget _xLabel(double value, TitleMeta meta) {
    if ((scale.maxX - value).round() % labelEvery != 0) {
      return const SizedBox.shrink();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      fitInside: SideTitleFitInsideData.fromTitleMeta(meta),
      child: Text(
        MonthFormat.axis.format(scale.monthAt(value)),
        style: AppTypography.bodySmall,
      ),
    );
  }
}
