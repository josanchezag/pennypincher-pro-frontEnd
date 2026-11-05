import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/time/month_format.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/utils/money_formatter.dart';
import 'package:pennypincher_pro/core/utils/percent_formatter.dart';
import 'package:pennypincher_pro/core/widgets/labeled_figure.dart';
import 'package:pennypincher_pro/core/widgets/money_format_scope.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/financial_goal_entity.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_projection_entity.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/circular_progress_indicator_widget.dart';

/// Formatted values of a goal card.
abstract final class GoalFormat {
  static const int _percent = 100;

  /// `$ 605.000.000` in the user's currency, or a dash when unknown.
  static String amount(MoneyFormatter money, Money? amount) =>
      amount == null ? PercentFormatter.none : money.format(amount);

  /// `11,0 %` from a fraction of one.
  static String rate(double fraction) =>
      PercentFormatter.format(fraction * _percent);

  /// Month the target is reached, or why there is none.
  static String achievement(
    AppLocalizations l10n,
    GoalProjection? projection,
  ) {
    final date = projection?.projectedAchievementDate;
    return switch (projection) {
      null => PercentFormatter.none,
      GoalProjection(alreadyReached: true) => l10n.goalsReached,
      GoalProjection(reachable: false) =>
        l10n.goalsNotReachable(GoalProjection.maxHorizonYears),
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
    final l10n = context.l10n;
    final money = context.money;
    return Row(
      children: [
        GoalCircularProgress(percent: goal.progressPercentage),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabeledFigure(
                label: l10n.goalsTarget,
                value: GoalFormat.amount(money, goal.targetAmount),
              ),
              LabeledFigure(
                label: l10n.goalsCurrentNetWorth,
                value: GoalFormat.amount(money, projection?.currentNetWorth),
              ),
              LabeledFigure(
                label: l10n.goalsRemaining,
                value: GoalFormat.amount(money, projection?.remainingAmount),
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
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabeledFigure(
          label: l10n.goalsProjectedDate,
          value: GoalFormat.achievement(l10n, goal.projection),
        ),
        Row(
          children: [
            Expanded(
              child: LabeledFigure(
                label: l10n.goalsMonthlyInvestment,
                value: GoalFormat.amount(context.money, goal.monthlyInvestment),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: LabeledFigure(
                label: l10n.goalsReturnRate,
                value: GoalFormat.rate(goal.expectedAnnualReturn),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
