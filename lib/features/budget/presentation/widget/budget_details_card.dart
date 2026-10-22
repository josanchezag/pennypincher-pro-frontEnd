import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/utils/currency_formatter.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/monthly_budget_entity.dart';
import 'package:pennypincher_pro/features/budget/presentation/budget_texts.dart';
import 'package:pennypincher_pro/features/budget/presentation/widget/budget_section_card.dart';
import 'package:pennypincher_pro/features/budget/presentation/widget/budget_value_dialog.dart';

/// Exchange rate (TRM) and work days of the month, each with a pencil
/// button that edits it in a small dialog. [onChanged] receives both
/// values, since the backend replaces them together.
class BudgetDetailsCard extends StatelessWidget {
  const BudgetDetailsCard({
    required this.settings,
    required this.enabled,
    required this.onChanged,
    super.key,
  });

  static const Key exchangeRateEditKey = Key('edit-exchange-rate');
  static const Key workDaysEditKey = Key('edit-work-days');

  static final TextInputFormatter _rateCharacters =
      FilteringTextInputFormatter.allow(RegExp('[0-9.,]'));

  final BudgetSettings settings;
  final bool enabled;
  final ValueChanged<BudgetSettings> onChanged;

  @override
  Widget build(BuildContext context) {
    final rate = settings.exchangeRate;
    final days = settings.workDays;
    return BudgetSectionCard(
      title: BudgetTexts.detailsTitle,
      children: [
        _EditableValue(
          editKey: exchangeRateEditKey,
          label: BudgetTexts.exchangeRate,
          value: rate == null ? null : CurrencyFormatter.formatWithCents(rate),
          onEdit: enabled ? () => _editExchangeRate(context) : null,
        ),
        _EditableValue(
          editKey: workDaysEditKey,
          label: BudgetTexts.workDays,
          value: days?.toString(),
          onEdit: enabled ? () => _editWorkDays(context) : null,
        ),
      ],
    );
  }

  Future<void> _editExchangeRate(BuildContext context) async {
    final text = await BudgetValueDialog.show(
      context,
      label: BudgetTexts.exchangeRate,
      initialText: settings.exchangeRate?.toInputString() ?? '',
      isValid: (text) => _parseRate(text) != null,
      errorMessage: BudgetTexts.exchangeRateInvalid,
      allowedCharacters: _rateCharacters,
    );
    if (text != null) {
      onChanged(settings.copyWith(exchangeRate: _parseRate(text)));
    }
  }

  Future<void> _editWorkDays(BuildContext context) async {
    final text = await BudgetValueDialog.show(
      context,
      label: BudgetTexts.workDays,
      initialText: settings.workDays?.toString() ?? '',
      isValid: (text) => _parseDays(text) != null,
      errorMessage: BudgetTexts.workDaysInvalid,
      allowedCharacters: FilteringTextInputFormatter.digitsOnly,
    );
    if (text != null) {
      onChanged(settings.copyWith(workDays: _parseDays(text)));
    }
  }

  /// A rate greater than zero, or `null` for anything else.
  static Money? _parseRate(String text) {
    final rate = Money.tryParseInput(text);
    return rate == null || rate.isZero ? null : rate;
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
    final shown = value ?? BudgetTexts.notSet;
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
          tooltip: '${BudgetTexts.editPrefix} $label',
          icon: const Icon(Icons.edit_outlined),
          onPressed: onEdit,
        ),
      ],
    );
  }
}
