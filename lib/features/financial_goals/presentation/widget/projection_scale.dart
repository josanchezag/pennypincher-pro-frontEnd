import 'dart:math' as math;

import 'package:pennypincher_pro/core/utils/chart_axis.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_projection_entity.dart';

/// Axes of the projection chart: x in years from now and y in pesos, from
/// zero (or the lowest value when it is negative) to one step above the
/// highest of the projected values and the target.
class ProjectionScale {
  const ProjectionScale._({
    required this.maxX,
    required this.xInterval,
    required this.minY,
    required this.maxY,
    required this.yInterval,
  });

  factory ProjectionScale.of(GoalProjection projection) {
    final values = [
      for (final point in projection.dataPoints) point.projectedValue.pesos,
      projection.targetAmount.pesos,
    ];
    final low = math.min(0, values.reduce(math.min)).toDouble();
    final high = values.reduce(math.max);
    final yInterval = ChartAxis.niceInterval(high - low);
    final lastMonth =
        projection.dataPoints.isEmpty ? 0 : projection.dataPoints.last.month;
    final maxX = math.max(yearsOf(lastMonth), minYears);
    return ProjectionScale._(
      maxX: maxX,
      xInterval: math.max(ChartAxis.niceInterval(maxX, steps: xSteps), 1),
      minY: (low / yInterval).floorToDouble() * yInterval,
      maxY: (high / yInterval).floorToDouble() * yInterval + yInterval,
      yInterval: yInterval,
    );
  }

  static const int monthsPerYear = 12;
  static const int xSteps = 5;
  static const double minYears = 1;

  final double maxX;

  /// Years between two labels of the x axis; at least one.
  final double xInterval;
  final double minY;
  final double maxY;
  final double yInterval;

  static double yearsOf(int month) => month / monthsPerYear;
}
