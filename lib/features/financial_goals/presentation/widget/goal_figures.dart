import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/time/month_format.dart';
import 'package:pennypincher_pro/core/utils/currency_formatter.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/utils/percent_formatter.dart';
import 'package:pennypincher_pro/core/widgets/labeled_figure.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/financial_goal_entity.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_projection_entity.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/goals_texts.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/circular_progress_indicator_widget.dart';

/// Formatted values of a goal card.
abstract final class GoalFormat {
  static const int _percent = 100;

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
      _ => date == null ? PercentFormatter.none : MonthFormat.long.format(date),
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
              LabeledFigure(
                label: GoalsTexts.target,
                value: GoalFormat.amount(goal.targetAmount),
              ),
              LabeledFigure(
                label: GoalsTexts.currentNetWorth,
                value: GoalFormat.amount(projection?.currentNetWorth),
              ),
              LabeledFigure(
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
        LabeledFigure(
          label: GoalsTexts.projectedDate,
          value: GoalFormat.achievement(goal.projection),
        ),
        Row(
          children: [
            Expanded(
              child: LabeledFigure(
                label: GoalsTexts.monthlyInvestment,
                value: GoalFormat.amount(goal.monthlyInvestment),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: LabeledFigure(
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
