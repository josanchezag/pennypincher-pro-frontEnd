import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/time/day_format.dart';
import 'package:pennypincher_pro/core/utils/app_currency.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/widgets/money_format_scope.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/monthly_budget_entity.dart';
import 'package:pennypincher_pro/features/budget/presentation/bloc/monthly_budget_bloc.dart';
import 'package:pennypincher_pro/features/budget/presentation/widget/budget_section_card.dart';
import 'package:pennypincher_pro/features/budget/presentation/widget/budget_value_dialog.dart';

/// Exchange rate (TRM) and work days of the month, each with a pencil
/// button that edits it in a small dialog. [onChanged] receives both
/// values, since the backend replaces them together. The TRM is in
/// Colombian pesos per US dollar whatever the user's currency, so it is
/// always written as pesos, and it is hidden for currencies it does not
/// concern ([AppCurrency.hasExchangeRate]); a hidden TRM is still sent
/// back unchanged.
///
/// [exchangeRateMode] tells how the TRM is kept: in the current month it
/// is today's TRM ([rateDate]), saved automatically, so it has no pencil
/// and a caption says so; when today's TRM is not available it keeps its
/// pencil and a note says why. [eurCop], today's EUR/COP close, is shown
/// read only below it for every currency.
class BudgetDetailsCard extends StatelessWidget {
  const BudgetDetailsCard({
    required this.settings,
    required this.enabled,
    required this.onChanged,
    this.exchangeRateMode = ExchangeRateMode.manual,
    this.rateDate,
    this.eurCop,
    super.key,
  });

  static const Key exchangeRateEditKey = Key('edit-exchange-rate');
  static const Key workDaysEditKey = Key('edit-work-days');
  static const Key exchangeRateCaptionKey = Key('exchange-rate-caption');
  static const Key eurCopKey = Key('eur-cop-rate');

  /// Example rate of the error message.
  static const Money _exampleRate = Money.fromCents(395025);

  final BudgetSettings settings;
  final bool enabled;
  final ValueChanged<BudgetSettings> onChanged;
  final ExchangeRateMode exchangeRateMode;
  final DateTime? rateDate;
  final Money? eurCop;

  @override
  Widget build(BuildContext context) {
    final rate = settings.exchangeRate;
    final days = settings.workDays;
    final money = context.money;
    final euro = eurCop;
    final caption = _exchangeRateCaption(context);
    return BudgetSectionCard(
      title: context.l10n.budgetDetailsTitle,
      children: [
        if (money.currency.hasExchangeRate) ...[
          _EditableValue(
            editKey: exchangeRateEditKey,
            label: context.l10n.budgetExchangeRate,
            value: rate == null ? null : money.formatExchangeRate(rate),
            editable: exchangeRateMode.isEditable,
            onEdit: enabled ? () => _editExchangeRate(context) : null,
          ),
          if (caption != null) caption,
        ],
        if (euro != null)
          _EditableValue(
            valueKey: eurCopKey,
            label: context.l10n.budgetEurCopClose,
            value: money.formatExchangeRate(euro),
            editable: false,
            onEdit: null,
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

  /// Line below the TRM saying where it comes from, if it needs one.
  Widget? _exchangeRateCaption(BuildContext context) {
    final l10n = context.l10n;
    final date = rateDate;
    final text = switch (exchangeRateMode) {
      ExchangeRateMode.automatic when date != null =>
        l10n.budgetExchangeRateAutomatic(DayFormat.medium.format(date)),
      ExchangeRateMode.unavailable => l10n.budgetExchangeRateUnavailable,
      ExchangeRateMode.saveFailed => l10n.budgetExchangeRateSaveFailed,
      _ => null,
    };
    if (text == null) {
      return null;
    }
    final automatic = exchangeRateMode == ExchangeRateMode.automatic;
    return Padding(
      key: exchangeRateCaptionKey,
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            automatic ? Icons.sync : Icons.info_outline,
            size: AppTypography.bodySmallSize,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: AppSpacing.xxs),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodySmall
                  .copyWith(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
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
    required this.label,
    required this.value,
    required this.onEdit,
    this.editKey,
    this.valueKey,
    this.editable = true,
  });

  /// Keys of the pencil and of the value.
  final Key? editKey;
  final Key? valueKey;
  final String label;
  final String? value;
  final VoidCallback? onEdit;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    final shown = value ?? context.l10n.budgetNotSet;
    return Row(
      children: [
        Expanded(child: Text(label, style: AppTypography.bodyMedium)),
        Text(
          shown,
          key: valueKey,
          style: value == null
              ? AppTypography.bodyMedium
              : AppTypography.monoMedium,
        ),
        if (editable)
          IconButton(
            key: editKey,
            tooltip: context.l10n.budgetEditValue(label),
            icon: const Icon(Icons.edit_outlined),
            onPressed: onEdit,
          )
        else
          // Keeps the value aligned with those that have a pencil.
          const SizedBox(
            width: kMinInteractiveDimension,
            height: kMinInteractiveDimension,
          ),
      ],
    );
  }
}
