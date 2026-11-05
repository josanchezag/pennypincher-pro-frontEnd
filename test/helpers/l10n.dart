import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/l10n/locale_store.dart';
import 'package:pennypincher_pro/core/theme/app_theme.dart';
import 'package:pennypincher_pro/core/utils/app_currency.dart';
import 'package:pennypincher_pro/core/utils/money_formatter.dart';

/// Language the tests run in by default.
const Locale testLocale = AppLocales.english;

/// English texts, to find widgets by what they say.
final AppLocalizations l10n = lookupAppLocalizations(testLocale);

/// Spanish texts, for the tests that check the default language.
final AppLocalizations l10nEs = lookupAppLocalizations(AppLocales.spanish);

/// How the screens write amounts in the tests: Colombian pesos, the default
/// currency, in [testLocale].
final MoneyFormatter testMoney =
    MoneyFormatter.of(AppCurrency.fallback, testLocale.languageCode);

/// A [MaterialApp] with the app theme and localizations around [home].
Widget localizedApp({required Widget home, Locale locale = testLocale}) =>
    MaterialApp(
      theme: AppTheme.dark,
      locale: locale,
      supportedLocales: AppLocales.supported,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: home,
    );

/// [LocaleStore] kept in memory, optionally starting with [languageCode].
class MemoryLocaleStore implements LocaleStore {
  MemoryLocaleStore([this.languageCode]);

  String? languageCode;

  @override
  String? read() => languageCode;

  @override
  void write(String languageCode) => this.languageCode = languageCode;
}
