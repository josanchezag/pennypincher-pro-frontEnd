import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/widgets/money_field.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// What a [BudgetValueDialog] resolves to when saved: the new [value], or
/// `null` when the field was emptied to clear it.
typedef BudgetValueResult<T> = ({T? value});

/// Small dialog that edits one optional value of the budget. It resolves to
/// the saved value (`null` inside when emptied, which clears it), or to
/// `null` when cancelled. [BudgetValueDialog.text] edits it as plain text,
/// [BudgetValueDialog.money] as an amount formatted as it is typed.
class BudgetValueDialog<T extends Object> extends StatefulWidget {
  const BudgetValueDialog._({
    required this.label,
    required this.initialValue,
    required this.isValid,
    required this.errorMessage,
    required Widget Function(_BudgetValueDialogState<T> state) fieldBuilder,
    super.key,
  }) : _fieldBuilder = fieldBuilder;

  static const String field = 'value';
  static const String invalidError = 'invalid';
  static const Key fieldKey = Key('budget-value-field');
  static const Key saveKey = Key('budget-value-save');

  /// Lines the helper and error texts may wrap to before being cut.
  static const int maxMessageLines = 2;

  final String label;
  final T? initialValue;

  /// Whether a value is acceptable; an empty field always is.
  final bool Function(T value) isValid;
  final String errorMessage;
  final Widget Function(_BudgetValueDialogState<T> state) _fieldBuilder;

  /// Edits text keeping only [allowedCharacters]; empty text clears it.
  static Future<BudgetValueResult<String>?> text(
    BuildContext context, {
    required String label,
    required String initialText,
    required bool Function(String text) isValid,
    required String errorMessage,
    required TextInputFormatter allowedCharacters,
  }) =>
      _show(
        context,
        BudgetValueDialog<String>._(
          label: label,
          initialValue: initialText.isEmpty ? null : initialText,
          isValid: (text) => text.trim().isEmpty || isValid(text.trim()),
          errorMessage: errorMessage,
          fieldBuilder: (state) => state._textField(allowedCharacters),
        ),
      );

  /// Edits the TRM, an amount in pesos with cents (see
  /// [MoneyField.exchangeRate]).
  static Future<BudgetValueResult<Money>?> exchangeRate(
    BuildContext context, {
    required String label,
    required Money? initialValue,
    required bool Function(Money rate) isValid,
    required String errorMessage,
  }) =>
      _show(
        context,
        BudgetValueDialog<Money>._(
          label: label,
          initialValue: initialValue,
          isValid: isValid,
          errorMessage: errorMessage,
          fieldBuilder: (state) => state._moneyField(),
        ),
      );

  static Future<BudgetValueResult<V>?> _show<V extends Object>(
    BuildContext context,
    BudgetValueDialog<V> dialog,
  ) =>
      showDialog<BudgetValueResult<V>>(
        context: context,
        builder: (_) => dialog,
      );

  @override
  State<BudgetValueDialog<T>> createState() => _BudgetValueDialogState<T>();
}

class _BudgetValueDialogState<T extends Object>
    extends State<BudgetValueDialog<T>> {
  late final FormGroup _form = FormGroup({
    BudgetValueDialog.field: FormControl<T>(
      value: widget.initialValue,
      validators: [Validators.delegate(_validate)],
    ),
  });

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  Map<String, dynamic>? _validate(AbstractControl<dynamic> control) {
    final value = control.value;
    return value is! T || widget.isValid(value)
        ? null
        : {BudgetValueDialog.invalidError: true};
  }

  void _save() {
    if (!_form.valid) {
      _form.markAllAsTouched();
      return;
    }
    final value = _form.control(BudgetValueDialog.field).value as T?;
    final cleared = value is String && value.trim().isEmpty;
    final saved = value is String ? value.trim() as T : value;
    Navigator.of(context).pop((value: cleared ? null : saved));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.budgetEditValue(widget.label)),
      content:
          ReactiveForm(formGroup: _form, child: widget._fieldBuilder(this)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.commonCancel),
        ),
        FilledButton(
          key: BudgetValueDialog.saveKey,
          onPressed: _save,
          child: Text(context.l10n.commonSave),
        ),
      ],
    );
  }

  Map<String, ValidationMessageFunction> get _messages => {
        BudgetValueDialog.invalidError: (_) => widget.errorMessage,
      };

  Widget _textField(TextInputFormatter allowedCharacters) =>
      ReactiveTextField<T>(
        key: BudgetValueDialog.fieldKey,
        formControlName: BudgetValueDialog.field,
        autofocus: true,
        keyboardType: TextInputType.number,
        inputFormatters: [allowedCharacters],
        onSubmitted: (_) => _save(),
        decoration: InputDecoration(
          labelText: widget.label,
          helperText: context.l10n.budgetClearHint,
          helperMaxLines: BudgetValueDialog.maxMessageLines,
          errorMaxLines: BudgetValueDialog.maxMessageLines,
        ),
        validationMessages: _messages,
      );

  Widget _moneyField() => MoneyField(
        fieldKey: BudgetValueDialog.fieldKey,
        formControlName: BudgetValueDialog.field,
        label: widget.label,
        exchangeRate: true,
        autofocus: true,
        onSubmitted: _save,
        helperText: context.l10n.budgetClearHint,
        messageMaxLines: BudgetValueDialog.maxMessageLines,
        validationMessages: _messages,
      );
}
