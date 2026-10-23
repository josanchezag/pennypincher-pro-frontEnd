import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pennypincher_pro/core/crud/domain/crud_item.dart';
import 'package:pennypincher_pro/core/crud/presentation/crud_screen_config.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// Controls and fields the item forms are made of, with the same limits as
/// the backend: a trimmed name of up to [CrudItem.nameMaxLength]
/// characters and amounts from zero up to [Money.maxCents].
abstract final class ItemFormFields {
  static const String name = 'name';
  static const String amountInvalidError = 'amountInvalid';

  /// Digits plus the dot and comma separators.
  static final TextInputFormatter amountCharacters =
      FilteringTextInputFormatter.allow(RegExp('[0-9.,]'));

  static FormControl<String> nameControl(String? initial) => FormControl(
        value: initial,
        validators: [
          Validators.required,
          Validators.maxLength(CrudItem.nameMaxLength),
        ],
      );

  /// Required amount typed in the Colombian format, prefilled with
  /// [initial].
  static FormControl<String> amountControl(Money? initial) => FormControl(
        value: initial?.toInputString(),
        validators: [Validators.required, Validators.delegate(_amount)],
      );

  static FormControl<C> categoryControl<C extends Enum>(C? initial) =>
      FormControl(value: initial, validators: [Validators.required]);

  static Widget nameField() => const _NameField();

  static Widget amountField(String controlName, String label) =>
      _AmountField(controlName: controlName, label: label);

  /// Drop-down with every category of [labels], in its order.
  static Widget categoryField<C extends Enum>(
    String controlName,
    Map<C, String> labels,
  ) =>
      _CategoryField<C>(controlName: controlName, labels: labels);

  /// [fields] with the standard gap between them.
  static List<Widget> spaced(List<Widget> fields) => [
        for (final (index, field) in fields.indexed) ...[
          if (index > 0) const SizedBox(height: AppSpacing.md),
          field,
        ],
      ];

  /// Trimmed name of a valid [form].
  static String nameOf(FormGroup form) =>
      (form.control(name).value as String).trim();

  /// Amount of the control [controlName] of a valid [form].
  static Money amountOf(FormGroup form, String controlName) =>
      Money.tryParseInput(form.control(controlName).value as String)!;

  static Map<String, dynamic>? _amount(AbstractControl<dynamic> control) {
    final text = control.value;
    if (text is! String || text.trim().isEmpty) {
      return null;
    }
    return Money.tryParseInput(text) == null
        ? {amountInvalidError: true}
        : null;
  }
}

class _NameField extends StatelessWidget {
  const _NameField();

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<String>(
      formControlName: ItemFormFields.name,
      textCapitalization: TextCapitalization.sentences,
      maxLength: CrudItem.nameMaxLength,
      decoration: const InputDecoration(labelText: CrudTexts.nameLabel),
      validationMessages: {
        ValidationMessage.required: (_) => CrudTexts.nameRequired,
        ValidationMessage.maxLength: (_) => CrudTexts.nameTooLong,
      },
    );
  }
}

class _AmountField extends StatelessWidget {
  const _AmountField({required this.controlName, required this.label});

  final String controlName;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<String>(
      formControlName: controlName,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [ItemFormFields.amountCharacters],
      decoration: InputDecoration(
        labelText: label,
        prefixText: CrudTexts.amountPrefix,
        helperText: CrudTexts.amountHelper,
      ),
      validationMessages: {
        ValidationMessage.required: (_) => CrudTexts.amountRequired,
        ItemFormFields.amountInvalidError: (_) => CrudTexts.amountInvalid,
      },
    );
  }
}

class _CategoryField<C extends Enum> extends StatelessWidget {
  const _CategoryField({required this.controlName, required this.labels});

  final String controlName;
  final Map<C, String> labels;

  @override
  Widget build(BuildContext context) {
    return ReactiveDropdownField<C>(
      formControlName: controlName,
      decoration: const InputDecoration(labelText: CrudTexts.categoryLabel),
      items: [
        for (final MapEntry(key: category, value: label) in labels.entries)
          DropdownMenuItem(value: category, child: Text(label)),
      ],
      validationMessages: {
        ValidationMessage.required: (_) => CrudTexts.categoryRequired,
      },
    );
  }
}
