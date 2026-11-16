import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/core/crud/presentation/layout/item_form.dart';
import 'package:pennypincher_pro/core/crud/presentation/widget/item_form_fields.dart';
import 'package:pennypincher_pro/core/crud/presentation/widget/item_form_sheet.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/utils/percent_input.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/financial_goal_entity.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_income_mode.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_income_plan.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_level.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_plan_basis.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/goal_styles.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/goal_form_fields.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/goal_mode_fields.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/goal_plan_preview.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// Form of a goal: name, level, where its income comes from (the
/// [GoalIncomeMode]), the fields of that mode, expected return in percent,
/// target years and a live preview of the plan.
///
/// * Current income: the income [basis] and the level factor, read-only.
/// * Desired income: the monthly income the user wants.
/// * Manual: the target and the monthly investment, as before.
///
/// In both income modes the target years are required (16 by default) and
/// an empty return starts at the reference 10 %. The fields of the other
/// modes are disabled, so they are neither validated nor sent.
class GoalForm extends ItemForm<FinancialGoal, GoalDraft> {
  const GoalForm({this.basis = GoalPlanBasis.unknown, this.initialMode});

  static const String level = 'level';
  static const String incomeMode = 'incomeMode';
  static const String desiredIncome = 'desiredMonthlyIncome';
  static const String targetAmount = 'targetAmount';
  static const String monthlyInvestment = 'monthlyInvestment';
  static const String expectedReturn = 'expectedAnnualReturn';
  static const String targetYears = 'targetYears';

  /// Income and net worth the preview starts from.
  final GoalPlanBasis basis;

  /// Mode the form opens in instead of the goal's own, such as the current
  /// income mode when a manual goal is based on the income.
  final GoalIncomeMode? initialMode;

  static Map<GoalLevel, String> levelLabels(AppLocalizations l10n) => {
        for (final level in GoalLevel.values) level: level.label(l10n),
      };

  /// Mode of a new goal: the current income one when the income is known
  /// to be above zero, otherwise manual.
  GoalIncomeMode modeFor(FinancialGoal? initial) =>
      initialMode ??
      initial?.incomeMode ??
      (_knowsIncome ? GoalIncomeMode.currentIncome : GoalIncomeMode.manual);

  bool get _knowsIncome => !(basis.monthlyIncome?.isZero ?? true);

  @override
  FormGroup formGroup(FinancialGoal? initial) {
    final form = FormGroup({
      ItemFormFields.name: ItemFormFields.nameControl(initial?.name),
      level: ItemFormFields.categoryControl<GoalLevel>(initial?.level),
      incomeMode: FormControl<GoalIncomeMode>(value: modeFor(initial)),
      desiredIncome:
          ItemFormFields.positiveAmountControl(initial?.desiredMonthlyIncome),
      targetAmount: ItemFormFields.positiveAmountControl(initial?.targetAmount),
      monthlyInvestment:
          ItemFormFields.amountControl(initial?.monthlyInvestment),
      expectedReturn:
          GoalFormFields.returnControl(initial?.expectedAnnualReturn),
      targetYears: GoalFormFields.targetYearsControl(initial?.targetYears),
    });
    _applyMode(form);
    form.control(incomeMode).valueChanges.listen((_) => _applyMode(form));
    return form;
  }

  /// Enables the fields of the selected mode and fills the defaults of an
  /// income mode.
  void _applyMode(FormGroup form) {
    final mode = modeOf(form);
    void enable(String name, {required bool when}) {
      final control = form.control(name);
      when ? control.markAsEnabled() : control.markAsDisabled();
    }

    enable(desiredIncome, when: mode == GoalIncomeMode.desiredIncome);
    enable(targetAmount, when: mode == GoalIncomeMode.manual);
    enable(monthlyInvestment, when: mode == GoalIncomeMode.manual);
    if (mode == GoalIncomeMode.desiredIncome) {
      _prefill(form.control(desiredIncome), _incomeOfCurrentMode(form));
    }
    final years = form.control(targetYears);
    GoalFormFields.requireTargetYears(years, required: mode.derivesFromIncome);
    if (mode.derivesFromIncome) {
      _prefill(years, '${GoalIncomePlan.defaultTargetYears}');
      _prefill(
        form.control(expectedReturn),
        PercentInput.format(
          PercentInput.basisPointsOf(GoalIncomePlan.referenceAnnualRate),
        ),
      );
    }
  }

  static void _prefill(AbstractControl<dynamic> control, Object? value) {
    final current = control.value;
    final empty = current == null || (current is String && current.isEmpty);
    if (empty && value != null) {
      control.value = value;
    }
  }

  /// The desired income the current income mode gives, offered as the
  /// start of a typed one; null while unknown or zero.
  Money? _incomeOfCurrentMode(FormGroup form) {
    final income = GoalIncomePlan.figures(
      mode: GoalIncomeMode.currentIncome,
      level: form.control(level).value as GoalLevel?,
      monthlyIncome: basis.monthlyIncome,
    ).desiredMonthlyIncome;
    return income == null || income.isZero ? null : income;
  }

  static GoalIncomeMode modeOf(FormGroup form) =>
      form.control(incomeMode).value as GoalIncomeMode? ??
      GoalIncomeMode.manual;

  @override
  List<Widget> formFields(AppLocalizations l10n) => [
        ItemFormFields.nameField(),
        ItemFormFields.categoryField<GoalLevel>(
          level,
          levelLabels(l10n),
          label: l10n.goalsLevel,
          requiredMessage: l10n.goalsLevelRequired,
        ),
        GoalModeFields(basis: basis),
        GoalFormFields.returnField(l10n, expectedReturn),
        GoalFormFields.targetYearsField(
          targetYears,
          modeControlName: incomeMode,
        ),
        GoalPlanPreview(basis: basis),
      ];

  @override
  GoalDraft draftOf(FormGroup form) {
    final mode = modeOf(form);
    final manual = mode == GoalIncomeMode.manual;
    return GoalDraft(
      name: ItemFormFields.nameOf(form),
      level: form.control(level).value as GoalLevel,
      incomeMode: mode,
      desiredMonthlyIncome: mode == GoalIncomeMode.desiredIncome
          ? ItemFormFields.amountOf(form, desiredIncome)
          : null,
      targetAmount: manual ? ItemFormFields.amountOf(form, targetAmount) : null,
      monthlyInvestment:
          manual ? ItemFormFields.amountOf(form, monthlyInvestment) : null,
      expectedAnnualReturn: GoalFormFields.returnOf(form, expectedReturn),
      targetYears: GoalFormFields.targetYearsOf(form, targetYears),
    );
  }
}

/// Bottom sheet that adds a goal, or edits [goal] with a delete button.
abstract final class GoalFormSheet {
  /// Resolves to true when the user asked to delete [goal]. The preview
  /// starts from [basis]; [mode] opens the form in that mode instead of
  /// the goal's own.
  static Future<bool> show(
    BuildContext context, {
    required CrudBloc<FinancialGoal, GoalDraft> bloc,
    FinancialGoal? goal,
    GoalPlanBasis basis = GoalPlanBasis.unknown,
    GoalIncomeMode? mode,
  }) =>
      ItemFormSheet.show<FinancialGoal, GoalDraft>(
        context,
        form: GoalForm(basis: basis, initialMode: mode),
        title: goal == null
            ? context.l10n.goalsAddGoal
            : context.l10n.goalsEditGoal,
        bloc: bloc,
        initial: goal,
        deleteLabel: context.l10n.goalsDeleteGoal,
      );
}
