import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/utils/currency_formatter.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_projection_entity.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/goals_texts.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/goal_figures.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/projection_scale.dart';

/// Line chart of the projected net worth of a goal, from the current net
/// worth over the years ahead, with the target as a dashed line, a marker
/// where the line reaches it and a tooltip per month.
class ProjectionChart extends StatelessWidget {
  const ProjectionChart({required this.projection, super.key});

  static const double height = 300;

  /// Narrowest y axis; it widens to fit labels such as `150.000M`.
  static const double minLeftAxisWidth = 56;

  /// Room between a y label and the plot, besides the label itself.
  static const double axisLabelPadding = AppSpacing.md;

  /// Wide enough for a value of 15 digits, such as `$ 1.021.304.980`, on
  /// one line.
  static const double tooltipWidth = 240;
  static const double bottomAxisHeight = 28;
  static const double axisNameHeight = 20;
  static const double lineWidth = 3;
  static const double markerRadius = 5;
  static const List<int> targetDash = [8, 4];

  final GoalProjection projection;

  /// Months to the target when it is reachable within the horizon.
  int? get crossingMonth =>
      projection.reachable ? projection.projectedMonthsToGoal : null;

  /// Width the widest y label of [scale] needs, scaled with the text.
  static double leftAxisWidthFor(ProjectionScale scale, TextScaler scaler) {
    var widest = 0.0;
    final labels = ((scale.maxY - scale.minY) / scale.yInterval).round();
    for (var step = 0; step <= labels; step++) {
      final painter = TextPainter(
        text: TextSpan(
          text: CurrencyFormatter.formatCompact(
            scale.minY + step * scale.yInterval,
          ),
          style: AppTypography.monoSmall,
        ),
        textDirection: TextDirection.ltr,
        textScaler: scaler,
      )..layout();
      widest = math.max(widest, painter.width);
      painter.dispose();
    }
    return math.max(minLeftAxisWidth, widest + axisLabelPadding);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: _description(),
      child: ExcludeSemantics(
        child: SizedBox(height: height, child: LineChart(_data(context))),
      ),
    );
  }

  LineChartData _data(BuildContext context) {
    final scale = ProjectionScale.of(projection);
    final axisWidth = leftAxisWidthFor(scale, MediaQuery.textScalerOf(context));
    return _ProjectionChartData(this, scale, axisWidth).build();
  }

  String _description() {
    final points = projection.dataPoints;
    final last = points.isEmpty ? null : points.last;
    return [
      '${GoalsTexts.chartDescriptionPrefix} ${projection.name}',
      '${GoalsTexts.targetLine} ${GoalFormat.amount(projection.targetAmount)}',
      if (last != null)
        '${GoalFormat.amount(last.projectedValue)} '
            '${GoalsTexts.summaryOn} ${GoalFormat.month.format(last.date)}',
    ].join(', ');
  }
}

/// fl_chart configuration of a [ProjectionChart].
class _ProjectionChartData {
  const _ProjectionChartData(this.chart, this.scale, this.leftAxisWidth);

  final ProjectionChart chart;
  final ProjectionScale scale;
  final double leftAxisWidth;

  GoalProjection get _projection => chart.projection;

  double? get _crossingX {
    final month = chart.crossingMonth;
    return month == null ? null : ProjectionScale.yearsOf(month);
  }

  LineChartData build() => LineChartData(
        minX: 0,
        maxX: scale.maxX,
        minY: scale.minY,
        maxY: scale.maxY,
        lineBarsData: [_line()],
        extraLinesData: ExtraLinesData(
          horizontalLines: [_targetLine()],
          verticalLines: [if (_crossingX case final x?) _crossingLine(x)],
        ),
        gridData: FlGridData(
          drawVerticalLine: false,
          horizontalInterval: scale.yInterval,
          getDrawingHorizontalLine: (_) =>
              const FlLine(color: AppColors.borderMuted, strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        lineTouchData: LineTouchData(touchTooltipData: _tooltip()),
        titlesData: _titles(),
      );

  LineChartBarData _line() => LineChartBarData(
        spots: [
          for (final point in _projection.dataPoints)
            FlSpot(
              ProjectionScale.yearsOf(point.month),
              point.projectedValue.pesos,
            ),
        ],
        color: AppColors.brandPrimary,
        barWidth: ProjectionChart.lineWidth,
        dotData: FlDotData(
          checkToShowDot: (spot, _) => spot.x == _crossingX,
          getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
            radius: ProjectionChart.markerRadius,
            color: AppColors.success,
          ),
        ),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.brandPrimary.withOpacity(_gradientOpacity),
              AppColors.brandPrimary.withOpacity(0),
            ],
          ),
        ),
      );

  static const double _gradientOpacity = 0.2;

  HorizontalLine _targetLine() => HorizontalLine(
        y: _projection.targetAmount.pesos,
        color: AppColors.accentGold,
        dashArray: ProjectionChart.targetDash,
        label: HorizontalLineLabel(
          show: true,
          style: AppTypography.label.copyWith(color: AppColors.accentGold),
          labelResolver: (_) => GoalsTexts.targetLine,
        ),
      );

  VerticalLine _crossingLine(double x) => VerticalLine(
        x: x,
        color: AppColors.success,
        label: VerticalLineLabel(
          show: true,
          alignment:
              x < scale.maxX / 2 ? Alignment.topRight : Alignment.topLeft,
          style: AppTypography.label.copyWith(color: AppColors.success),
          labelResolver: (_) =>
              GoalFormat.achievement(_projection).toUpperCase(),
        ),
      );

  LineTouchTooltipData _tooltip() => LineTouchTooltipData(
        getTooltipColor: (_) => AppColors.backgroundModal,
        fitInsideHorizontally: true,
        fitInsideVertically: true,
        maxContentWidth: ProjectionChart.tooltipWidth,
        getTooltipItems: (spots) => [
          for (final spot in spots) _tooltipItem(spot.spotIndex),
        ],
      );

  LineTooltipItem _tooltipItem(int index) {
    final point = _projection.dataPoints[index];
    return LineTooltipItem(
      '${CurrencyFormatter.format(point.projectedValue)}\n',
      AppTypography.monoMedium,
      children: [
        TextSpan(
          text: GoalFormat.month.format(point.date),
          style: AppTypography.bodySmall,
        ),
      ],
    );
  }

  FlTitlesData _titles() => FlTitlesData(
        topTitles: const AxisTitles(),
        rightTitles: const AxisTitles(),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: leftAxisWidth,
            interval: scale.yInterval,
            getTitlesWidget: _yLabel,
          ),
        ),
        bottomTitles: AxisTitles(
          axisNameSize: ProjectionChart.axisNameHeight,
          axisNameWidget: const Text(
            GoalsTexts.yearsFromNow,
            style: AppTypography.bodySmall,
          ),
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: ProjectionChart.bottomAxisHeight,
            interval: scale.xInterval,
            getTitlesWidget: _xLabel,
          ),
        ),
      );

  static Widget _yLabel(double value, TitleMeta meta) => SideTitleWidget(
        axisSide: meta.axisSide,
        child: Text(
          CurrencyFormatter.formatCompact(value),
          style: AppTypography.monoSmall,
        ),
      );

  /// Whole years only, so the end of the axis gets no extra label.
  Widget _xLabel(double value, TitleMeta meta) {
    final years = value / scale.xInterval;
    if ((years - years.round()).abs() > _labelTolerance) {
      return const SizedBox.shrink();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text('${value.round()}', style: AppTypography.bodySmall),
    );
  }

  static const double _labelTolerance = 0.001;
}
