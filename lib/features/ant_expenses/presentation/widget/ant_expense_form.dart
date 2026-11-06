import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/crud/presentation/layout/item_form.dart';
import 'package:pennypincher_pro/core/crud/presentation/widget/item_form_fields.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/time/day_format.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/widgets/money_field.dart';
import 'package:pennypincher_pro/core/widgets/money_format_scope.dart';
import 'package:pennypincher_pro/features/ant_expenses/domain/entity/ant_expense_entity.dart';
import 'package:pennypincher_pro/features/ant_expenses/domain/entity/ant_expense_report_entity.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/ant_expense_categories.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// Form of an ant expense, made to be filled in a few seconds: the amount
/// (focused on open), the category as chips, an optional description and
/// the day, today unless changed. A new expense starts in [category] when
/// one is given, as the quick add chips do.
class AntExpenseForm extends ItemForm<AntExpense, AntExpenseDraft> {
  const AntExpenseForm({required this.today, this.category});

  static const String amount = 'amount';
  static const String categoryField = 'category';
  static const String description = 'description';
  static const String spentOn = 'spentOn';

  static const Key amountKey = Key('ant-expense-amount');
  static const Key descriptionKey = Key('ant-expense-description');
  static const Key dateKey = Key('ant-expense-date');

  /// The device's local day, the latest one a new expense can have.
  final DateTime today;
  final AntExpenseCategory? category;

  @override
  FormGroup formGroup(AntExpense? initial) => FormGroup({
        amount: ItemFormFields.positiveAmountControl(initial?.amount),
        categoryField: ItemFormFields.categoryControl<AntExpenseCategory>(
          initial?.category ?? category,
        ),
        description: FormControl<String>(
          value: initial?.description,
          validators: [Validators.maxLength(AntExpense.descriptionMaxLength)],
        ),
        spentOn: FormControl<DateTime>(
          value: initial?.spentOn ?? DayFormat.dayOf(today),
          validators: [Validators.required],
        ),
      });

  @override
  List<Widget> formFields(AppLocalizations l10n) => [
        const _AmountField(),
        const _CategoryChips(),
        _DescriptionField(),
        _DateField(today: DayFormat.dayOf(today)),
      ];

  @override
  AntExpenseDraft draftOf(FormGroup form) {
    final text = (form.control(description).value as String?)?.trim();
    return AntExpenseDraft(
      amount: ItemFormFields.amountOf(form, amount),
      category: form.control(categoryField).value as AntExpenseCategory,
      spentOn: form.control(spentOn).value as DateTime,
      description: text == null || text.isEmpty ? null : text,
    );
  }

  /// Example amount of the field hint: a coffee, with cents in currencies
  /// that have them.
  static const Money _example = Money.fromUnits(3500);
  static const Money _exampleWithCents = Money.fromCents(350);
}

class _AmountField extends StatelessWidget {
  const _AmountField();

  @override
  Widget build(BuildContext context) {
    final money = context.money;
    final example = money.format(
      money.currency.decimalDigits > 0
          ? AntExpenseForm._exampleWithCents
          : AntExpenseForm._example,
    );
    return MoneyField(
      fieldKey: AntExpenseForm.amountKey,
      formControlName: AntExpenseForm.amount,
      label: context.l10n.antAmountLabel,
      autofocus: true,
      helperText: context.l10n.crudAmountHelper(example),
      validationMessages: {
        ValidationMessage.required: (_) => context.l10n.crudAmountRequired,
        ItemFormFields.amountNotPositiveError: (_) =>
            context.l10n.crudAmountNotPositive,
      },
    );
  }
}

/// Every category as a chip with its icon; one must be chosen.
class _CategoryChips extends StatelessWidget {
  const _CategoryChips();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ReactiveFormField<AntExpenseCategory, AntExpenseCategory>(
      formControlName: AntExpenseForm.categoryField,
      validationMessages: {
        ValidationMessage.required: (_) => l10n.crudCategoryRequired,
      },
      builder: (field) => Semantics(
        container: true,
        label: l10n.crudCategoryLabel,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: l10n.crudCategoryLabel,
            errorText: field.errorText,
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                for (final category in AntExpenseCategory.values)
                  AntCategoryChip(
                    category: category,
                    selected: field.value == category,
                    onSelected: () {
                      field.didChange(category);
                      field.control.markAsTouched();
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Chip of one category with its icon, brand blue when [selected].
class AntCategoryChip extends StatelessWidget {
  const AntCategoryChip({
    required this.category,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final AntExpenseCategory category;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.textOnBrand : AppColors.textPrimary;
    return ChoiceChip(
      avatar: Icon(category.icon, size: AppSpacing.md, color: color),
      label: Text(category.label(context.l10n)),
      selected: selected,
      showCheckmark: false,
      selectedColor: AppColors.brandPrimary,
      labelStyle: AppTypography.bodyMedium.copyWith(color: color),
      onSelected: (_) => onSelected(),
    );
  }
}

class _DescriptionField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<String>(
      key: AntExpenseForm.descriptionKey,
      formControlName: AntExpenseForm.description,
      textCapitalization: TextCapitalization.sentences,
      maxLength: AntExpense.descriptionMaxLength,
      decoration: InputDecoration(
        labelText: context.l10n.antDescriptionLabel,
        hintText: context.l10n.antDescriptionHint,
      ),
      validationMessages: {
        ValidationMessage.maxLength: (_) =>
            context.l10n.crudNameTooLong(AntExpense.descriptionMaxLength),
      },
    );
  }
}

/// Day of the purchase, picked from a calendar that ends today (or at the
/// stored day, if a clock east of UTC saved it a day ahead).
class _DateField extends StatelessWidget {
  const _DateField({required this.today});

  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ReactiveFormField<DateTime, DateTime>(
      formControlName: AntExpenseForm.spentOn,
      builder: (field) {
        final day = field.value ?? today;
        final text = AntDayLabel.of(l10n, day, today);
        return Semantics(
          button: true,
          label: '${l10n.antDateLabel}, $text',
          hint: l10n.antChangeDate,
          excludeSemantics: true,
          child: InkWell(
            key: AntExpenseForm.dateKey,
            onTap: () => _pick(context, field, day),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: l10n.antDateLabel,
                suffixIcon: const Icon(Icons.calendar_today_outlined),
              ),
              child: Text(text, style: AppTypography.bodyLarge),
            ),
          ),
        );
      },
    );
  }

  Future<void> _pick(
    BuildContext context,
    ReactiveFormFieldState<DateTime, DateTime> field,
    DateTime day,
  ) async {
    final last = day.isAfter(today) ? day : today;
    final picked = await showDatePicker(
      context: context,
      initialDate: day,
      firstDate: AntExpenseLimits.firstDay,
      lastDate: last,
    );
    if (picked != null) {
      field.didChange(DayFormat.dayOf(picked));
    }
  }
}

/// `Today`, `Yesterday` or the day written out (`Thursday, November 5`).
abstract final class AntDayLabel {
  static String of(AppLocalizations l10n, DateTime day, DateTime today) {
    if (DayFormat.sameDay(day, today)) {
      return l10n.antToday;
    }
    if (DayFormat.sameDay(day, DayFormat.previousDay(today))) {
      return l10n.antYesterday;
    }
    final text = DayFormat.weekday.format(day);
    final withYear = day.year == today.year ? text : '$text ${day.year}';
    return withYear[0].toUpperCase() + withYear.substring(1);
  }
}
