import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/core/crud/presentation/layout/item_form.dart';
import 'package:pennypincher_pro/core/crud/presentation/widget/item_form_fields.dart';
import 'package:pennypincher_pro/core/crud/presentation/widget/item_form_sheet.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/financial_goal_entity.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_level.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/goal_styles.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/goals_texts.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/goal_form_fields.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// Form of a goal: name, level, target, monthly investment, expected
/// return in percent and the optional target years.
class GoalForm extends ItemForm<FinancialGoal, GoalDraft> {
  const GoalForm();

  static const String level = 'level';
  static const String targetAmount = 'targetAmount';
  static const String monthlyInvestment = 'monthlyInvestment';
  static const String expectedReturn = 'expectedAnnualReturn';
  static const String targetYears = 'targetYears';

  static final Map<GoalLevel, String> levelLabels = {
    for (final level in GoalLevel.values) level: level.label,
  };

  @override
  FormGroup formGroup(FinancialGoal? initial) => FormGroup({
        ItemFormFields.name: ItemFormFields.nameControl(initial?.name),
        level: ItemFormFields.categoryControl<GoalLevel>(initial?.level),
        targetAmount:
            ItemFormFields.positiveAmountControl(initial?.targetAmount),
        monthlyInvestment:
            ItemFormFields.amountControl(initial?.monthlyInvestment),
        expectedReturn:
            GoalFormFields.returnControl(initial?.expectedAnnualReturn),
        targetYears: GoalFormFields.targetYearsControl(initial?.targetYears),
      });

  @override
  List<Widget> formFields() => [
        ItemFormFields.nameField(),
        ItemFormFields.categoryField<GoalLevel>(
          level,
          levelLabels,
          label: GoalsTexts.level,
          requiredMessage: GoalsTexts.levelRequired,
        ),
        ItemFormFields.amountField(targetAmount, GoalsTexts.target),
        ItemFormFields.amountField(
          monthlyInvestment,
          GoalsTexts.monthlyInvestment,
        ),
        GoalFormFields.returnField(expectedReturn),
        GoalFormFields.targetYearsField(targetYears),
      ];

  @override
  GoalDraft draftOf(FormGroup form) => GoalDraft(
        name: ItemFormFields.nameOf(form),
        level: form.control(level).value as GoalLevel,
        targetAmount: ItemFormFields.amountOf(form, targetAmount),
        monthlyInvestment: ItemFormFields.amountOf(form, monthlyInvestment),
        expectedAnnualReturn: GoalFormFields.returnOf(form, expectedReturn),
        targetYears: GoalFormFields.targetYearsOf(form, targetYears),
      );
}

/// Bottom sheet that adds a goal, or edits [goal] with a delete button.
abstract final class GoalFormSheet {
  static const GoalForm form = GoalForm();

  /// Resolves to true when the user asked to delete [goal].
  static Future<bool> show(
    BuildContext context, {
    required CrudBloc<FinancialGoal, GoalDraft> bloc,
    FinancialGoal? goal,
  }) =>
      ItemFormSheet.show<FinancialGoal, GoalDraft>(
        context,
        form: form,
        title: goal == null ? GoalsTexts.addGoal : GoalsTexts.editGoal,
        bloc: bloc,
        initial: goal,
        deleteLabel: GoalsTexts.deleteGoal,
      );
}
