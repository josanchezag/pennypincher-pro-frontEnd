import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/utils/app_currency.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/widgets/money_format_scope.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/monthly_budget_entity.dart';
import 'package:pennypincher_pro/features/budget/presentation/widget/budget_section_card.dart';
import 'package:pennypincher_pro/features/budget/presentation/widget/budget_value_dialog.dart';

/// Exchange rate (TRM) and work days of the month, each with a pencil
/// button that edits it in a small dialog. [onChanged] receives both
/// values, since the backend replaces them together. The TRM is in
/// Colombian pesos per US dollar whatever the user's currency, so it is
/// always written as pesos, and it is hidden for currencies it does not
/// concern ([AppCurrency.hasExchangeRate]); a hidden TRM is still sent
/// back unchanged.
class BudgetDetailsCard extends StatelessWidget {
  const BudgetDetailsCard({
    required this.settings,
    required this.enabled,
    required this.onChanged,
    super.key,
  });

  static const Key exchangeRateEditKey = Key('edit-exchange-rate');
  static const Key workDaysEditKey = Key('edit-work-days');

  /// Example rate of the error message.
  static const Money _exampleRate = Money.fromCents(395025);

  final BudgetSettings settings;
  final bool enabled;
  final ValueChanged<BudgetSettings> onChanged;

  @override
  Widget build(BuildContext context) {
    final rate = settings.exchangeRate;
    final days = settings.workDays;
    final money = context.money;
    return BudgetSectionCard(
      title: context.l10n.budgetDetailsTitle,
      children: [
        if (money.currency.hasExchangeRate)
          _EditableValue(
            editKey: exchangeRateEditKey,
            label: context.l10n.budgetExchangeRate,
            value: rate == null ? null : money.formatExchangeRate(rate),
            onEdit: enabled ? () => _editExchangeRate(context) : null,
          ),
        _EditableValue(
          editKey: workDaysEditKey,
          label: context.l10n.budgetWorkDays,
          value: days?.toString(),
          onEdit: enabled ? () => _editWorkDays(context) : null,
        ),
      ],
    );
  }

  Future<void> _editExchangeRate(BuildContext context) async {
    final example = context.money.formatExchangeRate(_exampleRate);
    final result = await BudgetValueDialog.exchangeRate(
      context,
      label: context.l10n.budgetExchangeRate,
      initialValue: settings.exchangeRate,
      isValid: (rate) => !rate.isZero,
      errorMessage: context.l10n.budgetExchangeRateInvalid(example),
    );
    if (result != null) {
      onChanged(settings.copyWith(exchangeRate: result.value));
    }
  }

  Future<void> _editWorkDays(BuildContext context) async {
    final result = await BudgetValueDialog.text(
      context,
      label: context.l10n.budgetWorkDays,
      initialText: settings.workDays?.toString() ?? '',
      isValid: (text) => _parseDays(text) != null,
      errorMessage:
          context.l10n.budgetWorkDaysInvalid(BudgetLimits.maxWorkDays),
      allowedCharacters: FilteringTextInputFormatter.digitsOnly,
    );
    if (result != null) {
      final text = result.value;
      onChanged(
        settings.copyWith(workDays: text == null ? null : _parseDays(text)),
      );
    }
  }

  /// Work days from 0 to [BudgetLimits.maxWorkDays], or `null`.
  static int? _parseDays(String text) {
    final days = int.tryParse(text);
    return days == null || days > BudgetLimits.maxWorkDays ? null : days;
  }
}

class _EditableValue extends StatelessWidget {
  const _EditableValue({
    required this.editKey,
    required this.label,
    required this.value,
    required this.onEdit,
  });

  final Key editKey;
  final String label;
  final String? value;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final shown = value ?? context.l10n.budgetNotSet;
    return Row(
      children: [
        Expanded(child: Text(label, style: AppTypography.bodyMedium)),
        Text(
          shown,
          style: value == null
              ? AppTypography.bodyMedium
              : AppTypography.monoMedium,
        ),
        IconButton(
          key: editKey,
          tooltip: context.l10n.budgetEditValue(label),
          icon: const Icon(Icons.edit_outlined),
          onPressed: onEdit,
        ),
      ],
    );
  }
}
