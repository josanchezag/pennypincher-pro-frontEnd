import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/utils/currency_formatter.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/utils/percent_formatter.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/financial_goal_entity.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_projection_entity.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/goals_texts.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/circular_progress_indicator_widget.dart';

/// Formatted values of a goal card.
abstract final class GoalFormat {
  static const int _percent = 100;
  static final DateFormat month = DateFormat('MMMM yyyy');

  /// `$ 605.000.000`, or a dash when unknown.
  static String amount(Money? amount) =>
      amount == null ? PercentFormatter.none : CurrencyFormatter.format(amount);

  /// `11,0 %` from a fraction of one.
  static String rate(double fraction) =>
      PercentFormatter.format(fraction * _percent);

  /// Month the target is reached, or why there is none.
  static String achievement(GoalProjection? projection) {
    final date = projection?.projectedAchievementDate;
    return switch (projection) {
      null => PercentFormatter.none,
      GoalProjection(alreadyReached: true) => GoalsTexts.goalReached,
      GoalProjection(reachable: false) => GoalsTexts.notReachable,
      _ => date == null ? PercentFormatter.none : month.format(date),
    };
  }
}

/// The progress ring next to the target, current net worth and remaining
/// amount of a goal.
class GoalProgressSection extends StatelessWidget {
  const GoalProgressSection({required this.goal, super.key});

  final FinancialGoal goal;

  @override
  Widget build(BuildContext context) {
    final projection = goal.projection;
    return Row(
      children: [
        GoalCircularProgress(percent: goal.progressPercentage),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GoalFigure(
                label: GoalsTexts.target,
                value: GoalFormat.amount(goal.targetAmount),
              ),
              GoalFigure(
                label: GoalsTexts.currentNetWorth,
                value: GoalFormat.amount(projection?.currentNetWorth),
              ),
              GoalFigure(
                label: GoalsTexts.remaining,
                value: GoalFormat.amount(projection?.remainingAmount),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Projected date, monthly investment and return rate of a goal.
class GoalPlanSection extends StatelessWidget {
  const GoalPlanSection({required this.goal, super.key});

  final FinancialGoal goal;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GoalFigure(
          label: GoalsTexts.projectedDate,
          value: GoalFormat.achievement(goal.projection),
        ),
        Row(
          children: [
            Expanded(
              child: GoalFigure(
                label: GoalsTexts.monthlyInvestment,
                value: GoalFormat.amount(goal.monthlyInvestment),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: GoalFigure(
                label: GoalsTexts.returnRate,
                value: GoalFormat.rate(goal.expectedAnnualReturn),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// A small upper-case [label] over its [value].
class GoalFigure extends StatelessWidget {
  const GoalFigure({required this.label, required this.value, super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: AppTypography.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(value, style: AppTypography.monoMedium),
          ),
        ],
      ),
    );
  }
}
