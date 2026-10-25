import 'dart:math' as math;

import 'package:pennypincher_pro/core/utils/chart_axis.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/monthly_comparison_entity.dart';

/// Shared y range of the comparison bars and the cash flow line, from
/// zero or the lowest cash flow up to the highest amount.
class BudgetComparisonScale {
  const BudgetComparisonScale._({
    required this.minY,
    required this.maxY,
    required this.interval,
  });

  factory BudgetComparisonScale.of(List<MonthComparison> months) {
    final values = [
      0.0,
      for (final month in months)
        if (month.figures case final figures?) ...[
          figures.totalIncome.pesos,
          figures.totalExpenses.pesos,
          figures.cashFlow.pesos,
        ],
    ];
    final low = values.reduce(math.min);
    final high = values.reduce(math.max);
    final interval = ChartAxis.niceInterval(high - low);
    return BudgetComparisonScale._(
      minY: (low / interval).floorToDouble() * interval,
      maxY: math.max((high / interval).ceilToDouble() * interval, interval),
      interval: interval,
    );
  }

  final double minY;
  final double maxY;
  final double interval;

  /// Bar groups laid out with space around them are centered at
  /// `(i + 0.5) / count` of the width, so a line chart from `-0.5` to
  /// `count - 0.5` puts the point of month `i` at `x = i`, over its bars.
  static const double groupHalfWidth = 0.5;
}
