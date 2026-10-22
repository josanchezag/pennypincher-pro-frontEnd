import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/crud/presentation/crud_screen_config.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// Controls, validation and fields of the item form, with the same limits
/// as the backend: a trimmed name of up to [ItemDraft.nameMaxLength]
/// characters and an amount from zero up to [Money.maxCents].
abstract final class ItemFormFields {
  static const String name = 'name';
  static const String amount = 'amount';
  static const String category = 'category';
  static const String amountInvalidError = 'amountInvalid';

  /// Digits plus the dot and comma separators.
  static final TextInputFormatter amountCharacters =
      FilteringTextInputFormatter.allow(RegExp('[0-9.,]'));

  static FormGroup group<C extends Enum>(CategorizedItem<C>? initial) =>
      FormGroup({
        name: FormControl<String>(
          value: initial?.name,
          validators: [
            Validators.required,
            Validators.maxLength(ItemDraft.nameMaxLength),
          ],
        ),
        amount: FormControl<String>(
          value: initial?.amount.toInputString(),
          validators: [Validators.required, Validators.delegate(_amount)],
        ),
        category: FormControl<C>(
          value: initial?.category,
          validators: [Validators.required],
        ),
      });

  static List<Widget> build<C extends Enum>(CrudScreenConfig<C> config) => [
        const _NameField(),
        const SizedBox(height: AppSpacing.md),
        _AmountField(label: config.amountLabel),
        const SizedBox(height: AppSpacing.md),
        _CategoryField<C>(config: config),
      ];

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
      maxLength: ItemDraft.nameMaxLength,
      decoration: const InputDecoration(labelText: CrudTexts.nameLabel),
      validationMessages: {
        ValidationMessage.required: (_) => CrudTexts.nameRequired,
        ValidationMessage.maxLength: (_) => CrudTexts.nameTooLong,
      },
    );
  }
}

class _AmountField extends StatelessWidget {
  const _AmountField({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<String>(
      formControlName: ItemFormFields.amount,
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
  const _CategoryField({required this.config});

  final CrudScreenConfig<C> config;

  @override
  Widget build(BuildContext context) {
    return ReactiveDropdownField<C>(
      formControlName: ItemFormFields.category,
      decoration: const InputDecoration(labelText: CrudTexts.categoryLabel),
      items: [
        for (final category in config.categories)
          DropdownMenuItem(
            value: category,
            child: Text(config.labelOf(category)),
          ),
      ],
      validationMessages: {
        ValidationMessage.required: (_) => CrudTexts.categoryRequired,
      },
    );
  }
}
