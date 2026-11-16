import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/widgets/labeled_figure.dart';
import 'package:pennypincher_pro/core/widgets/money_format_scope.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_income_plan.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_level.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_plan_basis.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/goal_figures.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/goal_form_fields.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/goal_form_sheet.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// Live preview of the goal being edited: its desired income in the
/// income modes, target, required monthly investment and what the target
/// would yield at 10 % effective annual, computed here with the formulas
/// of the backend (see [GoalIncomePlan]) from [basis] and the form. Once
/// saved, the goal shows the figures the backend answers with.
class GoalPlanPreview extends StatelessWidget {
  const GoalPlanPreview({required this.basis, super.key});

  static const Key targetKey = Key('goal-preview-target');
  static const Key requiredKey = Key('goal-preview-required');
  static const Key desiredKey = Key('goal-preview-desired');

  final GoalPlanBasis basis;

  /// Figures of the goal as [form] holds it.
  GoalPlanFigures figuresOf(FormGroup form) {
    final mode = GoalForm.modeOf(form);
    return GoalIncomePlan.figures(
      mode: mode,
      level: form.control(GoalForm.level).value as GoalLevel?,
      monthlyIncome: basis.monthlyIncome,
      typedDesiredIncome: _amount(form, GoalForm.desiredIncome),
      manualTarget: _amount(form, GoalForm.targetAmount),
      currentNetWorth: basis.currentNetWorth,
      annualReturn: GoalFormFields.tryReturnOf(form, GoalForm.expectedReturn),
      targetYears: GoalFormFields.tryTargetYearsOf(form, GoalForm.targetYears),
    );
  }

  static Money? _amount(FormGroup form, String name) {
    final control = form.control(name);
    return control.valid ? control.value as Money? : null;
  }

  @override
  Widget build(BuildContext context) {
    return ReactiveFormConsumer(
      builder: (context, form, _) {
        final l10n = context.l10n;
        final money = context.money;
        final figures = figuresOf(form);
        final desired = figures.desiredMonthlyIncome;
        final reference = figures.referenceReturn;
        return DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderDefault),
            borderRadius: const BorderRadius.all(
              Radius.circular(AppSpacing.radiusCard),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.goalsPreviewTitle, style: AppTypography.heading3),
                const SizedBox(height: AppSpacing.xs),
                if (GoalForm.modeOf(form).derivesFromIncome)
                  LabeledFigure(
                    key: desiredKey,
                    label: l10n.goalsDesiredIncome,
                    value: GoalFormat.amount(money, desired),
                  ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: LabeledFigure(
                        key: targetKey,
                        label: l10n.goalsTarget,
                        value: GoalFormat.amount(money, figures.target),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: LabeledFigure(
                        key: requiredKey,
                        label: l10n.goalsRequiredInvestmentShort,
                        value: GoalFormat.amount(
                          money,
                          figures.requiredMonthlyInvestment,
                        ),
                      ),
                    ),
                  ],
                ),
                if (reference != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  GoalReferenceReturnLine(value: reference),
                ],
                const SizedBox(height: AppSpacing.xs),
                Text(l10n.goalsPreviewNote, style: AppTypography.bodySmall),
              ],
            ),
          ),
        );
      },
    );
  }
}
