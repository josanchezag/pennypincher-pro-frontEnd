import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/time/month_format.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/utils/money_formatter.dart';
import 'package:pennypincher_pro/core/utils/percent_formatter.dart';
import 'package:pennypincher_pro/core/utils/percent_input.dart';
import 'package:pennypincher_pro/core/widgets/labeled_figure.dart';
import 'package:pennypincher_pro/core/widgets/money_format_scope.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/financial_goal_entity.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_projection_entity.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/reference_return.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/goal_styles.dart';
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

  /// `10%` from a fraction of one, as the reference rate is written.
  static String referenceRate(double fraction) =>
      '${PercentInput.format(PercentInput.basisPointsOf(fraction))}%';

  static const String _english = 'en';
  static final NumberFormat _spanishFactor = NumberFormat('#,##0.##', 'es_CO');
  static final NumberFormat _englishFactor = NumberFormat('#,##0.##', 'en_US');

  /// Income factor in the language of [l10n]: `0,6` or `0.6`, `1`, `2`.
  static String factor(AppLocalizations l10n, double factor) =>
      (Intl.shortLocale(l10n.localeName) == _english
              ? _englishFactor
              : _spanishFactor)
          .format(factor);

  /// `16 years`, or that the goal has no term.
  static String term(AppLocalizations l10n, int? years) =>
      years == null ? l10n.goalsNoTerm : l10n.goalsYears(years, '$years');

  /// Where the desired income of [goal] comes from, or null for a manual
  /// goal.
  static String? incomeSource(AppLocalizations l10n, FinancialGoal goal) =>
      goal.incomeMode.sourceLabel(l10n, factor(l10n, goal.incomeFactor ?? 1));

  /// "At 10% a year it would yield $X a month ($Y a year)".
  static String referenceReturn(
    AppLocalizations l10n,
    MoneyFormatter money,
    ReferenceReturn value,
  ) =>
      l10n.goalsReferenceReturn(
        referenceRate(value.annualRate),
        money.format(value.monthlyAmount),
        money.format(value.annualAmount),
      );

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

/// The desired monthly income of a goal that derives from an income,
/// with where it comes from: the current income times a factor, or the
/// income the user wants. Manual goals have none, so nothing is shown.
class GoalIncomeSection extends StatelessWidget {
  const GoalIncomeSection({required this.goal, super.key});

  static const Key sourceKey = Key('goal-income-source');

  final FinancialGoal goal;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final source = GoalFormat.incomeSource(l10n, goal);
    if (source == null) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabeledFigure(
          label: l10n.goalsDesiredIncome,
          value: GoalFormat.amount(context.money, goal.desiredMonthlyIncome),
        ),
        Text(
          source,
          key: sourceKey,
          style: AppTypography.bodySmall.copyWith(color: goal.level.color),
        ),
      ],
    );
  }
}

/// Projected date, monthly investment, return rate and term of a goal.
/// The investment of a goal that derives from an income is the one it
/// requires; a manual goal with a term also shows the investment its term
/// requires next to the one the user set.
class GoalPlanSection extends StatelessWidget {
  const GoalPlanSection({required this.goal, super.key});

  final FinancialGoal goal;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final money = context.money;
    final fromIncome = goal.incomeMode.derivesFromIncome;
    final required = goal.requiredMonthlyInvestment;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Pair(
          first: LabeledFigure(
            label: l10n.goalsProjectedDate,
            value: GoalFormat.achievement(l10n, goal.projection),
          ),
          second: LabeledFigure(
            label: l10n.goalsTerm,
            value: GoalFormat.term(l10n, goal.targetYears),
          ),
        ),
        _Pair(
          first: LabeledFigure(
            label: fromIncome
                ? l10n.goalsRequiredInvestmentShort
                : l10n.goalsMonthlyInvestment,
            value: GoalFormat.amount(money, goal.monthlyInvestment),
          ),
          second: LabeledFigure(
            label: l10n.goalsReturnRate,
            value: GoalFormat.rate(goal.expectedAnnualReturn),
          ),
        ),
        if (!fromIncome && required != null)
          LabeledFigure(
            label: l10n.goalsRequiredInvestment,
            value: GoalFormat.amount(money, required),
          ),
      ],
    );
  }
}

/// Two figures side by side, each taking half of the width.
class _Pair extends StatelessWidget {
  const _Pair({required this.first, required this.second});

  final Widget first;
  final Widget second;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: first),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: second),
      ],
    );
  }
}

/// What the target of a goal would yield at 10 % effective annual, a
/// month and a year, shown for every goal.
class GoalReferenceReturnLine extends StatelessWidget {
  const GoalReferenceReturnLine({required this.value, super.key});

  static const Key textKey = Key('goal-reference-return');

  final ReferenceReturn value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ExcludeSemantics(
          child: Icon(
            Icons.savings_outlined,
            size: AppTypography.bodyLargeSize,
            color: AppColors.success,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            GoalFormat.referenceReturn(context.l10n, context.money, value),
            key: textKey,
            style:
                AppTypography.bodySmall.copyWith(color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}
