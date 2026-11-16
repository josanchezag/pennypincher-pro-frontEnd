import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/financial_goal_entity.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/goal_styles.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/goal_figures.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/goal_level_badge.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/halfway_celebration.dart';

/// Card of one goal: name and level, the desired monthly income of a goal
/// that derives from an income, progress toward the target, the plan that
/// gets there and what the target would yield at 10 % effective annual.
/// Tapping it edits the goal; a manual goal also offers to base it on the
/// user's income with [onBaseOnIncome]. While [celebrate], it plays the
/// halfway celebration once and then calls [onCelebrated].
class GoalCard extends StatelessWidget {
  const GoalCard({
    required this.goal,
    required this.onTap,
    this.onSeeProjection,
    this.onBaseOnIncome,
    this.celebrate = false,
    this.onCelebrated,
    super.key,
  });

  static const Key seeProjectionKey = Key('goal-card-see-projection');
  static const Key baseOnIncomeKey = Key('goal-card-base-on-income');

  static const int nameMaxLines = 2;

  final FinancialGoal goal;
  final VoidCallback? onTap;

  /// Opens the projection chart of the goal.
  final VoidCallback? onSeeProjection;

  /// Opens the edit sheet in the current income mode; offered on manual
  /// goals only.
  final VoidCallback? onBaseOnIncome;
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
                if (goal.incomeMode.derivesFromIncome) ...[
                  const SizedBox(height: AppSpacing.sm),
                  GoalIncomeSection(goal: goal),
                ],
                const SizedBox(height: AppSpacing.md),
                GoalProgressSection(goal: goal),
                const Divider(height: AppSpacing.lg),
                GoalPlanSection(goal: goal),
                const SizedBox(height: AppSpacing.xs),
                GoalReferenceReturnLine(value: goal.effectiveReferenceReturn),
                _Actions(
                  onSeeProjection: onSeeProjection,
                  onBaseOnIncome:
                      goal.incomeMode.derivesFromIncome ? null : onBaseOnIncome,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The buttons at the foot of the card, kept to the right and wrapped
/// onto a second line when the card is narrow.
class _Actions extends StatelessWidget {
  const _Actions({required this.onSeeProjection, this.onBaseOnIncome});

  final VoidCallback? onSeeProjection;
  final VoidCallback? onBaseOnIncome;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.end,
      children: [
        if (onBaseOnIncome case final onPressed?)
          TextButton.icon(
            key: GoalCard.baseOnIncomeKey,
            onPressed: onPressed,
            icon: const Icon(Icons.payments_outlined),
            label: Text(context.l10n.goalsBaseOnIncome),
          ),
        TextButton.icon(
          key: GoalCard.seeProjectionKey,
          onPressed: onSeeProjection,
          icon: const Icon(Icons.show_chart),
          label: Text(context.l10n.goalsSeeProjection),
        ),
      ],
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
        Text(
          goal.level.description(context.l10n),
          style: AppTypography.bodySmall,
        ),
      ],
    );
  }
}
