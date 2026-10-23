import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/theme/progress_band.dart';
import 'package:pennypincher_pro/core/utils/percent_formatter.dart';
import 'package:pennypincher_pro/core/widgets/progress_ring.dart';
import 'package:pennypincher_pro/features/dashboard/domain/entity/dashboard_summary_entity.dart';

/// Compact progress of one goal: a small ring, the goal name and the
/// percentage, colored by its [ProgressBand]. Opens the goals screen.
class GoalProgressChip extends StatelessWidget {
  const GoalProgressChip({required this.goal, super.key});

  static const double ringSize = AppSpacing.xl + AppSpacing.xs;
  static const double ringStrokeWidth = AppSpacing.xxs;
  static const int nameLines = 2;

  /// Height at the default text size, for a name on two lines.
  static const double height = 88;

  /// [height] scaled with the text, so horizontal lists fit their chips.
  static double extentOf(BuildContext context) =>
      MediaQuery.textScalerOf(context).scale(height);

  final GoalSummary goal;

  @override
  Widget build(BuildContext context) {
    final percent = goal.progressPercentage;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Semantics(
        button: true,
        child: InkWell(
          onTap: () => context.goNamed(AppRoute.goals.name),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Row(
              children: [
                ProgressRing(
                  percent: percent,
                  size: ringSize,
                  strokeWidth: ringStrokeWidth,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: _Texts(name: goal.name, percent: percent)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Texts extends StatelessWidget {
  const _Texts({required this.name, required this.percent});

  final String name;
  final double percent;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: AppTypography.bodyMedium.copyWith(
            color: AppTypography.bodyLarge.color,
          ),
          maxLines: GoalProgressChip.nameLines,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          PercentFormatter.formatOptional(ProgressBand.shown(percent)),
          style: AppTypography.monoMedium.copyWith(
            color: ProgressBand.colorOf(percent),
          ),
        ),
      ],
    );
  }
}
