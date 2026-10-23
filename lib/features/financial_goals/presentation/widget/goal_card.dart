import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/financial_goal_entity.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/goals_texts.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/goal_figures.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/goal_level_badge.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/halfway_celebration.dart';

/// Card of one goal: name and level, progress toward the target and the
/// plan that gets there. Tapping it edits the goal. While [celebrate], it
/// plays the halfway celebration once and then calls [onCelebrated].
class GoalCard extends StatelessWidget {
  const GoalCard({
    required this.goal,
    required this.onTap,
    this.onSeeProjection,
    this.celebrate = false,
    this.onCelebrated,
    super.key,
  });

  static const Key seeProjectionKey = Key('goal-card-see-projection');

  static const int nameMaxLines = 2;

  final FinancialGoal goal;
  final VoidCallback? onTap;

  /// Opens the projection chart of the goal.
  final VoidCallback? onSeeProjection;
  final bool celebrate;
  final VoidCallback? onCelebrated;

  @override
  Widget build(BuildContext context) {
    return HalfwayCelebration(
      play: celebrate,
      onFinished: onCelebrated ?? () {},
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Header(goal: goal),
                const SizedBox(height: AppSpacing.md),
                GoalProgressSection(goal: goal),
                const Divider(height: AppSpacing.lg),
                GoalPlanSection(goal: goal),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    key: seeProjectionKey,
                    onPressed: onSeeProjection,
                    icon: const Icon(Icons.show_chart),
                    label: const Text(GoalsTexts.seeProjection),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.goal});

  final FinancialGoal goal;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          goal.name,
          style: AppTypography.heading3,
          maxLines: GoalCard.nameMaxLines,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.xs),
        GoalLevelBadge(level: goal.level),
        const SizedBox(height: AppSpacing.xxs),
        Text(goal.levelDescription, style: AppTypography.bodySmall),
      ],
    );
  }
}
