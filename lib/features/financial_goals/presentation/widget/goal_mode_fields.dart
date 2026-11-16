import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pennypincher_pro/core/crud/presentation/widget/item_form_fields.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/utils/percent_formatter.dart';
import 'package:pennypincher_pro/core/widgets/labeled_figure.dart';
import 'package:pennypincher_pro/core/widgets/money_format_scope.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_income_mode.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_income_plan.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_level.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_plan_basis.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/goal_styles.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/goal_figures.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/goal_form_sheet.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// The mode selector of the goal form and the fields of the selected mode:
/// the income [basis] and level factor (read-only) for the current income,
/// the income the user wants, or the target and monthly investment of a
/// manual goal.
class GoalModeFields extends StatelessWidget {
  const GoalModeFields({required this.basis, super.key});

  static Key modeKey(GoalIncomeMode mode) => Key('goal-mode-${mode.name}');

  final GoalPlanBasis basis;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ReactiveValueListenableBuilder<GoalIncomeMode>(
      formControlName: GoalForm.incomeMode,
      builder: (context, control, _) {
        final mode = control.value ?? GoalIncomeMode.manual;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.goalsModeLabel, style: AppTypography.bodyMedium),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                for (final option in GoalIncomeMode.values)
                  ChoiceChip(
                    key: modeKey(option),
                    label: Text(option.choiceLabel(l10n)),
                    selected: option == mode,
                    onSelected: (_) => control.value = option,
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(mode.help(l10n), style: AppTypography.bodySmall),
            const SizedBox(height: AppSpacing.md),
            ...ItemFormFields.spaced(
              switch (mode) {
                GoalIncomeMode.currentIncome => [
                    _CurrentIncomePanel(basis: basis),
                  ],
                GoalIncomeMode.desiredIncome => [
                    ItemFormFields.amountField(
                      GoalForm.desiredIncome,
                      l10n.goalsDesiredIncome,
                    ),
                  ],
                GoalIncomeMode.manual => [
                    ItemFormFields.amountField(
                      GoalForm.targetAmount,
                      l10n.goalsTarget,
                    ),
                    ItemFormFields.amountField(
                      GoalForm.monthlyInvestment,
                      l10n.goalsMonthlyInvestment,
                    ),
                  ],
              },
            ),
          ],
        );
      },
    );
  }
}

/// The current monthly income and the factor of the chosen level,
/// read-only, or why the income cannot be used.
class _CurrentIncomePanel extends StatelessWidget {
  const _CurrentIncomePanel({required this.basis});

  static const Key goToIncomeKey = Key('goal-mode-go-to-income');

  final GoalPlanBasis basis;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final income = basis.monthlyIncome;
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.backgroundTertiary,
        borderRadius: BorderRadius.all(Radius.circular(AppSpacing.radiusInput)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: switch (income) {
          null => Text(l10n.goalsIncomeUnknown, style: AppTypography.bodySmall),
          Money(isZero: true) => _MissingIncome(onGoToIncome: _goToIncome),
          _ => ReactiveValueListenableBuilder<GoalLevel>(
              formControlName: GoalForm.level,
              builder: (context, level, _) => Row(
                children: [
                  Expanded(
                    child: LabeledFigure(
                      label: l10n.goalsIncomeBasis,
                      value: context.money.format(income),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: LabeledFigure(
                      label: l10n.goalsIncomeFactor,
                      value: switch (level.value) {
                        final GoalLevel level =>
                          '×${GoalFormat.factor(l10n, GoalIncomePlan.incomeFactorOf(level))}',
                        null => PercentFormatter.none,
                      },
                    ),
                  ),
                ],
              ),
            ),
        },
      ),
    );
  }

  /// Closes the sheet and opens the income sources.
  void _goToIncome(BuildContext context) {
    final router = GoRouter.of(context);
    Navigator.of(context).pop();
    router.goNamed(AppRoute.budgetIncome.name);
  }
}

class _MissingIncome extends StatelessWidget {
  const _MissingIncome({required this.onGoToIncome});

  final void Function(BuildContext context) onGoToIncome;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.goalsIncomeMissing,
          style: AppTypography.bodySmall.copyWith(color: AppColors.warning),
        ),
        TextButton.icon(
          key: _CurrentIncomePanel.goToIncomeKey,
          onPressed: () => onGoToIncome(context),
          icon: const Icon(Icons.payments_outlined),
          label: Text(context.l10n.goalsGoToIncome),
        ),
      ],
    );
  }
}
