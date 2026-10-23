import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/utils/currency_formatter.dart';

/// Look shared by the money charts: grid, tooltip and axis labels.
abstract final class ChartStyle {
  static const FlLine gridLine =
      FlLine(color: AppColors.borderMuted, strokeWidth: 1);

  /// Text of a tooltip line with an amount.
  static final TextStyle tooltipValue =
      AppTypography.monoSmall.copyWith(color: AppColors.textPrimary);

  /// Horizontal grid lines every [interval].
  static FlGridData horizontalGrid(double interval) => FlGridData(
        drawVerticalLine: false,
        horizontalInterval: interval,
        getDrawingHorizontalLine: (_) => gridLine,
      );

  /// Background of every tooltip, whatever was touched.
  static Color tooltipColor(Object? touched) => AppColors.backgroundModal;

  /// Amount of the y axis, in millions from one million up.
  static Widget millionsLabel(double value, TitleMeta meta) => SideTitleWidget(
        axisSide: meta.axisSide,
        child: Text(
          CurrencyFormatter.formatCompact(value),
          style: AppTypography.monoSmall,
        ),
      );
}
