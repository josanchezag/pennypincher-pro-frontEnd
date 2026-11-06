import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/utils/app_currency.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/utils/money_formatter.dart';

/// One choice per currency, each with an example amount written the way
/// the app would show it in the interface language. [onSelected] is
/// `null` while a change is saved.
class CurrencyOptions extends StatelessWidget {
  const CurrencyOptions({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  /// Option of [currency], for tests and screen captures.
  static Key optionKey(AppCurrency currency) =>
      Key('settings-currency-${currency.code}');

  /// Amount of the examples: `$ 1.234.568`, `US$ 1.234.567,50`...
  static const Money example = Money.fromCents(123456750);

  final AppCurrency selected;
  final ValueChanged<AppCurrency>? onSelected;

  static String nameOf(AppLocalizations l10n, AppCurrency currency) =>
      switch (currency) {
        AppCurrency.cop => l10n.currencyCop,
        AppCurrency.usd => l10n.currencyUsd,
        AppCurrency.eur => l10n.currencyEur,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final language = Localizations.localeOf(context).languageCode;
    final onSelected = this.onSelected;
    return Column(
      children: [
        for (final currency in AppCurrency.values)
          RadioListTile<AppCurrency>(
            key: optionKey(currency),
            value: currency,
            groupValue: selected,
            contentPadding: EdgeInsets.zero,
            onChanged: onSelected == null
                ? null
                : (value) => value == null ? null : onSelected(value),
            title: Text(nameOf(l10n, currency), style: AppTypography.bodyLarge),
            subtitle: Text(
              l10n.settingsCurrencyExample(
                MoneyFormatter.of(currency, language).format(example),
              ),
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
      ],
    );
  }
}
