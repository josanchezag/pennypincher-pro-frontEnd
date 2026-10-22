import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pennypincher_pro/features/budget/presentation/budget_texts.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// Small dialog that edits one optional value of the budget as text. It
/// resolves to the trimmed text when saved (empty clears the value), or to
/// `null` when cancelled.
class BudgetValueDialog extends StatefulWidget {
  const BudgetValueDialog({
    required this.label,
    required this.initialText,
    required this.isValid,
    required this.errorMessage,
    required this.allowedCharacters,
    super.key,
  });

  static const String field = 'value';
  static const String invalidError = 'invalid';
  static const Key fieldKey = Key('budget-value-field');
  static const Key saveKey = Key('budget-value-save');

  /// Lines the helper and error texts may wrap to before being cut.
  static const int maxMessageLines = 2;

  final String label;
  final String initialText;

  /// Whether a non-empty text is acceptable.
  final bool Function(String text) isValid;
  final String errorMessage;
  final TextInputFormatter allowedCharacters;

  static Future<String?> show(
    BuildContext context, {
    required String label,
    required String initialText,
    required bool Function(String text) isValid,
    required String errorMessage,
    required TextInputFormatter allowedCharacters,
  }) =>
      showDialog<String>(
        context: context,
        builder: (_) => BudgetValueDialog(
          label: label,
          initialText: initialText,
          isValid: isValid,
          errorMessage: errorMessage,
          allowedCharacters: allowedCharacters,
        ),
      );

  @override
  State<BudgetValueDialog> createState() => _BudgetValueDialogState();
}

class _BudgetValueDialogState extends State<BudgetValueDialog> {
  late final FormGroup _form = FormGroup({
    BudgetValueDialog.field: FormControl<String>(
      value: widget.initialText,
      validators: [Validators.delegate(_validate)],
    ),
  });

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  Map<String, dynamic>? _validate(AbstractControl<dynamic> control) {
    final text = (control.value as String? ?? '').trim();
    return text.isEmpty || widget.isValid(text)
        ? null
        : {BudgetValueDialog.invalidError: true};
  }

  void _save() {
    if (!_form.valid) {
      _form.markAllAsTouched();
      return;
    }
    final text = _form.control(BudgetValueDialog.field).value as String?;
    Navigator.of(context).pop((text ?? '').trim());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${BudgetTexts.editPrefix} ${widget.label}'),
      content: ReactiveForm(formGroup: _form, child: _field()),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(BudgetTexts.cancel),
        ),
        FilledButton(
          key: BudgetValueDialog.saveKey,
          onPressed: _save,
          child: const Text(BudgetTexts.save),
        ),
      ],
    );
  }

  Widget _field() => ReactiveTextField<String>(
        key: BudgetValueDialog.fieldKey,
        formControlName: BudgetValueDialog.field,
        autofocus: true,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [widget.allowedCharacters],
        onSubmitted: (_) => _save(),
        decoration: InputDecoration(
          labelText: widget.label,
          helperText: BudgetTexts.clearHint,
          helperMaxLines: BudgetValueDialog.maxMessageLines,
          errorMaxLines: BudgetValueDialog.maxMessageLines,
        ),
        validationMessages: {
          BudgetValueDialog.invalidError: (_) => widget.errorMessage,
        },
      );
}
