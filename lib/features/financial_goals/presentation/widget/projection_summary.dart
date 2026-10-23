import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_projection_entity.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/goals_texts.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/goal_figures.dart';

/// One sentence under the projection chart: when the goal is reached at
/// the current pace, that it is already reached, or that it is out of
/// reach.
class ProjectionSummary extends StatelessWidget {
  const ProjectionSummary({required this.projection, super.key});

  static final NumberFormat _years = NumberFormat('#,##0.##', 'es_CO');

  final GoalProjection projection;

  /// The sentence for [projection].
  static String textOf(GoalProjection projection) {
    final name = projection.name;
    final years = projection.projectedYearsToGoal;
    final date = projection.projectedAchievementDate;
    if (projection.alreadyReached) {
      return '${GoalsTexts.alreadyReachedPrefix} $name'
          '${GoalsTexts.alreadyReachedSuffix}';
    }
    if (!projection.reachable || years == null || date == null) {
      return '${GoalsTexts.notReachablePrefix} $name'
          '${GoalsTexts.notReachableSuffix}';
    }
    return '${GoalsTexts.summaryPrefix} $name ${GoalsTexts.summaryIn} '
        '${_yearsText(years)} ${GoalsTexts.summaryOn} '
        '${GoalFormat.month.format(date)}';
  }

  static String _yearsText(double years) {
    final unit = years == 1 ? GoalsTexts.year : GoalsTexts.yearsSuffix;
    return '${_years.format(years)} $unit';
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Text(textOf(projection), style: AppTypography.bodyLarge),
    );
  }
}
