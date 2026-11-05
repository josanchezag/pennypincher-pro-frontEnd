import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pennypincher_pro/core/crud/domain/crud_item.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/widgets/money_format_scope.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// Controls and fields the item forms are made of, with the same limits as
/// the backend: a trimmed name of up to [CrudItem.nameMaxLength]
/// characters and amounts from zero up to [Money.maxCents].
abstract final class ItemFormFields {
  static const String name = 'name';
  static const String amountInvalidError = 'amountInvalid';
  static const String amountNotPositiveError = 'amountNotPositive';

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

  /// Required amount above zero, prefilled with [initial].
  static FormControl<String> positiveAmountControl(Money? initial) =>
      FormControl(
        value: initial?.toInputString(),
        validators: [
          Validators.required,
          Validators.delegate(_amount),
          Validators.delegate(_positive),
        ],
      );

  /// Amount that may be left empty, prefilled with [initial].
  static FormControl<String> optionalAmountControl(Money? initial) =>
      FormControl(
        value: initial?.toInputString(),
        validators: [Validators.delegate(_amount)],
      );

  static FormControl<C> categoryControl<C extends Enum>(C? initial) =>
      FormControl(value: initial, validators: [Validators.required]);

  static Widget nameField() => const _NameField();

  /// Amount typed in the Colombian format; when [optional] it may be left
  /// empty and its hint says so.
  static Widget amountField(
    String controlName,
    String label, {
    bool optional = false,
  }) =>
      _AmountField(
        controlName: controlName,
        label: label,
        optional: optional,
      );

  /// Drop-down with every category of [labels], in its order, labelled
  /// [label] and asking for a choice with [requiredMessage]; both default
  /// to the texts of an item category.
  static Widget categoryField<C extends Enum>(
    String controlName,
    Map<C, String> labels, {
    String? label,
    String? requiredMessage,
  }) =>
      _CategoryField<C>(
        controlName: controlName,
        labels: labels,
        label: label,
        requiredMessage: requiredMessage,
      );

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
      optionalAmountOf(form, controlName)!;

  /// Amount of the control [controlName] of a valid [form], or null when it
  /// was left empty.
  static Money? optionalAmountOf(FormGroup form, String controlName) {
    final text = form.control(controlName).value as String?;
    return text == null || text.trim().isEmpty
        ? null
        : Money.tryParseInput(text);
  }

  static Map<String, dynamic>? _positive(AbstractControl<dynamic> control) {
    final text = control.value;
    final amount = text is String ? Money.tryParseInput(text) : null;
    return amount != null && amount.isZero
        ? {amountNotPositiveError: true}
        : null;
  }

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
      decoration: InputDecoration(labelText: context.l10n.crudNameLabel),
      validationMessages: {
        ValidationMessage.required: (_) => context.l10n.crudNameRequired,
        ValidationMessage.maxLength: (_) =>
            context.l10n.crudNameTooLong(CrudItem.nameMaxLength),
      },
    );
  }
}

class _AmountField extends StatelessWidget {
  const _AmountField({
    required this.controlName,
    required this.label,
    required this.optional,
  });

  final String controlName;
  final String label;

  /// Whether the amount may be left empty; its hint then says so.
  final bool optional;

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<String>(
      formControlName: controlName,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [ItemFormFields.amountCharacters],
      decoration: InputDecoration(
        labelText: label,
        prefixText: '${context.money.inputPrefix} ',
        helperText: optional
            ? context.l10n.crudOptionalAmountHelper
            : context.l10n.crudAmountHelper,
      ),
      validationMessages: {
        ValidationMessage.required: (_) => context.l10n.crudAmountRequired,
        ItemFormFields.amountInvalidError: (_) =>
            context.l10n.crudAmountInvalid,
        ItemFormFields.amountNotPositiveError: (_) =>
            context.l10n.crudAmountNotPositive,
      },
    );
  }
}

class _CategoryField<C extends Enum> extends StatelessWidget {
  const _CategoryField({
    required this.controlName,
    required this.labels,
    required this.label,
    required this.requiredMessage,
  });

  final String controlName;
  final Map<C, String> labels;
  final String? label;
  final String? requiredMessage;

  @override
  Widget build(BuildContext context) {
    return ReactiveDropdownField<C>(
      formControlName: controlName,
      decoration: InputDecoration(
        labelText: label ?? context.l10n.crudCategoryLabel,
      ),
      items: [
        for (final MapEntry(key: category, value: text) in labels.entries)
          DropdownMenuItem(value: category, child: Text(text)),
      ],
      validationMessages: {
        ValidationMessage.required: (_) =>
            requiredMessage ?? context.l10n.crudCategoryRequired,
      },
    );
  }
}
