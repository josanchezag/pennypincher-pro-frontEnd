import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_level.dart';

part 'goal_projection_entity.freezed.dart';

/// Progress of a goal against the current net worth and when the monthly
/// investment, compounded at the expected return, reaches its target.
@freezed
class GoalProjection with _$GoalProjection {
  const factory GoalProjection({
    required String goalId,
    required String name,
    required GoalLevel level,
    required Money targetAmount,
    required Money currentNetWorth,
    required Money progressAmount,

    /// From 0 to 100, with two decimals.
    required double progressPercentage,
    required Money remainingAmount,
    required Money monthlyInvestment,
    required double expectedAnnualReturn,
    required bool reachable,
    required List<ProjectionPoint> dataPoints,
    int? targetYears,

    /// Null when the target is not reachable within the projected horizon.
    int? projectedMonthsToGoal,
    double? projectedYearsToGoal,

    /// First day of the month the target is reached.
    DateTime? projectedAchievementDate,
  }) = _GoalProjection;

  const GoalProjection._();

  /// Longest horizon the backend projects, in years.
  static const int maxHorizonYears = 50;

  /// Whether the current net worth already covers the target.
  bool get alreadyReached => reachable && projectedMonthsToGoal == 0;
}

/// Projected net worth [month] months from now, on [date] (day 01).
@freezed
class ProjectionPoint with _$ProjectionPoint {
  const factory ProjectionPoint({
    required int month,
    required DateTime date,
    required Money projectedValue,
  }) = _ProjectionPoint;
}
