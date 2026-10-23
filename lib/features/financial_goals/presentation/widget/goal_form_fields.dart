import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pennypincher_pro/core/utils/percent_input.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/financial_goal_entity.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/goals_texts.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// The goal fields the generic item fields do not cover: the expected
/// return, typed as a percentage, and the optional target years.
abstract final class GoalFormFields {
  static const String returnInvalidError = 'returnInvalid';
  static const String targetYearsInvalidError = 'targetYearsInvalid';
  static const int _maxReturnBasisPoints = PercentInput.basisPointsPerUnit;

  static final TextInputFormatter percentCharacters =
      FilteringTextInputFormatter.allow(RegExp('[0-9.,]'));

  /// Required return in percent, prefilled from a [fraction] of one.
  static FormControl<String> returnControl(double? fraction) => FormControl(
        value: fraction == null
            ? null
            : PercentInput.format(PercentInput.basisPointsOf(fraction)),
        validators: [Validators.required, Validators.delegate(_return)],
      );

  static FormControl<String> targetYearsControl(int? initial) => FormControl(
        value: initial?.toString(),
        validators: [Validators.delegate(_targetYears)],
      );

  /// Fraction of one typed in the valid control [controlName] of [form].
  static double returnOf(FormGroup form, String controlName) =>
      PercentInput.fractionOf(_basisPoints(form.control(controlName).value)!);

  /// Target years of the valid control [controlName], null when empty.
  static int? targetYearsOf(FormGroup form, String controlName) {
    final text = (form.control(controlName).value as String?)?.trim() ?? '';
    return text.isEmpty ? null : int.parse(text);
  }

  static Widget returnField(String controlName) => _NumberField(
        controlName: controlName,
        label: GoalsTexts.expectedAnnualReturn,
        helper: GoalsTexts.returnHelper,
        suffix: GoalsTexts.percentSuffix,
        allowed: percentCharacters,
        decimal: true,
        messages: {
          ValidationMessage.required: (_) => GoalsTexts.returnRequired,
          returnInvalidError: (_) => GoalsTexts.returnInvalid,
        },
      );

  static Widget targetYearsField(String controlName) => _NumberField(
        controlName: controlName,
        label: GoalsTexts.targetYears,
        helper: GoalsTexts.targetYearsHelper,
        suffix: GoalsTexts.yearsSuffix,
        allowed: FilteringTextInputFormatter.digitsOnly,
        decimal: false,
        messages: {
          targetYearsInvalidError: (_) => GoalsTexts.targetYearsInvalid,
        },
      );

  static int? _basisPoints(Object? value) =>
      value is String ? PercentInput.tryParseBasisPoints(value) : null;

  static Map<String, dynamic>? _return(AbstractControl<dynamic> control) {
    final text = control.value;
    if (text is! String || text.trim().isEmpty) {
      return null;
    }
    final basisPoints = _basisPoints(text);
    final valid = basisPoints != null &&
        basisPoints > 0 &&
        basisPoints <= _maxReturnBasisPoints;
    return valid ? null : {returnInvalidError: true};
  }

  static Map<String, dynamic>? _targetYears(AbstractControl<dynamic> control) {
    final text = control.value;
    if (text is! String || text.trim().isEmpty) {
      return null;
    }
    final years = int.tryParse(text.trim());
    final valid = years != null &&
        years >= GoalDraft.minTargetYears &&
        years <= GoalDraft.maxTargetYears;
    return valid ? null : {targetYearsInvalidError: true};
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({
    required this.controlName,
    required this.label,
    required this.helper,
    required this.suffix,
    required this.allowed,
    required this.decimal,
    required this.messages,
  });

  final String controlName;
  final String label;
  final String helper;
  final String suffix;
  final TextInputFormatter allowed;
  final bool decimal;
  final Map<String, ValidationMessageFunction> messages;

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<String>(
      formControlName: controlName,
      keyboardType: TextInputType.numberWithOptions(decimal: decimal),
      inputFormatters: [allowed],
      decoration: InputDecoration(
        labelText: label,
        helperText: helper,
        suffixText: suffix,
      ),
      validationMessages: messages,
    );
  }
}
