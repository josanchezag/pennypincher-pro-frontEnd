import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/time/month_format.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_projection_entity.dart';

/// One sentence under the projection chart: when the goal is reached at
/// the current pace, that it is already reached, or that it is out of
/// reach.
class ProjectionSummary extends StatelessWidget {
  const ProjectionSummary({required this.projection, super.key});

  static final NumberFormat _years = NumberFormat('#,##0.##', 'es_CO');

  final GoalProjection projection;

  /// The sentence for [projection].
  static String textOf(AppLocalizations l10n, GoalProjection projection) {
    final name = projection.name;
    final years = projection.projectedYearsToGoal;
    final date = projection.projectedAchievementDate;
    if (projection.alreadyReached) {
      return l10n.goalsAlreadyReached(name);
    }
    if (!projection.reachable || years == null || date == null) {
      return l10n.goalsNotReachableSummary(
        name,
        GoalProjection.maxHorizonYears,
      );
    }
    return l10n.goalsSummaryReach(
      name,
      l10n.goalsYears(years, _years.format(years)),
      MonthFormat.long.format(date),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Text(
        textOf(context.l10n, projection),
        style: AppTypography.bodyLarge,
      ),
    );
  }
}
