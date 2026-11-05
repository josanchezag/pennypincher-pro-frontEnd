import 'package:intl/intl.dart';
import 'package:pennypincher_pro/core/utils/app_currency.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/utils/money_input_format.dart';

/// Formats amounts for display in the user's [currency], with the digit
/// separators of the interface language: Spanish groups with dots and
/// writes a decimal comma (`1.234.567,50`), English the other way round
/// (`1,234,567.50`).
///
/// The symbol follows each language's habit: in Spanish, as written in
/// Colombia, `$` is the peso, so dollars are `US$`; in English `$` is the
/// dollar, so pesos are `COP`. Euros go after the number in Spanish and
/// before it in English. Pesos have no decimals; dollars and euros, two:
///
/// | | es | en |
/// |---|---|---|
/// | COP | `$ 1.234.568` | `COP 1,234,568` |
/// | USD | `US$ 1.234.567,50` | `$1,234,567.50` |
/// | EUR | `1.234.567,50 €` | `€1,234,567.50` |
///
/// Instances are shared: [MoneyFormatter.of] returns the same one for the
/// same settings. Widgets get theirs from `context.money`.
final class MoneyFormatter {
  MoneyFormatter._(this.currency, this.languageCode)
      : _style = _CurrencyStyle.of(currency, languageCode) {
    final locale = _numberLocaleOf(languageCode);
    _amount = _currencyFormat(_style, locale, currency.decimalDigits);
    _exchangeRate = _currencyFormat(
      _CurrencyStyle.of(AppCurrency.cop, languageCode),
      locale,
      exchangeRateDigits,
    );
    _millions = NumberFormat('#,##0.#', locale);
    _whole = NumberFormat('#,##0', locale);
    final symbols = _whole.symbols;
    inputFormat = _style.inputFormat(
      symbols.GROUP_SEP,
      symbols.DECIMAL_SEP,
      currency.decimalDigits,
    );
    exchangeRateInputFormat =
        _CurrencyStyle.of(AppCurrency.cop, languageCode).inputFormat(
      symbols.GROUP_SEP,
      symbols.DECIMAL_SEP,
      exchangeRateDigits,
    );
  }

  /// The formatter of [currency] in the interface language [languageCode]
  /// (`es` or `en`; any other code formats as Spanish).
  factory MoneyFormatter.of(AppCurrency currency, String languageCode) {
    final language = languageCode == english ? english : spanish;
    return _shared.putIfAbsent(
      (currency, language),
      () => MoneyFormatter._(currency, language),
    );
  }

  static final Map<(AppCurrency, String), MoneyFormatter> _shared = {};

  static const String spanish = 'es';
  static const String english = 'en';

  /// Number data of intl used for each language. Both only lend their
  /// separators: the currency patterns are fixed here, since intl's put
  /// the symbol after the number in `es_CO` and write `$` for any dollar.
  static const String _spanishNumbers = 'es_CO';
  static const String _englishNumbers = 'en_US';

  static const String positiveSign = '+';
  static const String negativeSign = '-';
  static const String millionsSuffix = 'M';
  static const double oneMillion = 1000000;

  /// The exchange rate keeps its cents, like the official TRM.
  static const int exchangeRateDigits = 2;

  final AppCurrency currency;
  final String languageCode;
  final _CurrencyStyle _style;
  late final NumberFormat _amount;
  late final NumberFormat _exchangeRate;
  late final NumberFormat _millions;
  late final NumberFormat _whole;

  /// How amount fields write amounts in [currency]: `1.500.000,50`
  /// after `US$ `, or `1,500,000` after `COP `.
  late final MoneyInputFormat inputFormat;

  /// How the TRM field writes the rate, as pesos with cents.
  late final MoneyInputFormat exchangeRateInputFormat;

  /// An amount in [currency]: `$ 1.500.000` or `$1,500,000.00`.
  String format(Money amount) => _amount.format(amount.units);

  /// Always signed: `+$ 2.450.000`, `-1.234,50 €` or `+€1,234.50`.
  String formatSigned(Money amount) {
    final sign = amount.isNegative ? negativeSign : positiveSign;
    return '$sign${format(amount.abs())}';
  }

  /// The TRM, which is in Colombian pesos per dollar whatever the user's
  /// currency, with its cents: `$ 3.950,25` or `COP 3,950.25`.
  String formatExchangeRate(Money rate) => _exchangeRate.format(rate.units);

  /// Short label for chart axes, without symbol: `173M` (`1,5M` or `1.5M`)
  /// from one million up, otherwise the whole number (`850.000`).
  String formatCompact(double amount) {
    if (amount.abs() >= oneMillion) {
      return '${_millions.format(amount / oneMillion)}$millionsSuffix';
    }
    return _whole.format(amount);
  }

  static String _numberLocaleOf(String languageCode) =>
      languageCode == english ? _englishNumbers : _spanishNumbers;

  static NumberFormat _currencyFormat(
    _CurrencyStyle style,
    String locale,
    int decimalDigits,
  ) =>
      NumberFormat.currency(
        locale: locale,
        symbol: style.symbol,
        decimalDigits: decimalDigits,
        customPattern: style.pattern(decimalDigits),
      );
}

/// Symbol of a currency in one language and where it goes.
final class _CurrencyStyle {
  const _CurrencyStyle(this.symbol, {this.after = false, this.spaced = true});

  /// Symbol, code or abbreviation written with the amount.
  final String symbol;

  /// Whether it goes after the number, as euros in Spanish.
  final bool after;

  /// Whether a non-breaking space separates it from the number.
  final bool spaced;

  static const String _placeholder = '¤';
  static const String _space = ' ';
  static const String _integer = '#,##0';

  static const Map<(AppCurrency, String), _CurrencyStyle> _styles = {
    (AppCurrency.cop, MoneyFormatter.spanish): _CurrencyStyle(r'$'),
    (AppCurrency.cop, MoneyFormatter.english): _CurrencyStyle('COP'),
    (AppCurrency.usd, MoneyFormatter.spanish): _CurrencyStyle(r'US$'),
    (AppCurrency.usd, MoneyFormatter.english):
        _CurrencyStyle(r'$', spaced: false),
    (AppCurrency.eur, MoneyFormatter.spanish): _CurrencyStyle('€', after: true),
    (AppCurrency.eur, MoneyFormatter.english):
        _CurrencyStyle('€', spaced: false),
  };

  static _CurrencyStyle of(AppCurrency currency, String languageCode) =>
      _styles[(currency, languageCode)]!;

  /// Field format with this symbol and the given separators.
  MoneyInputFormat inputFormat(
    String groupSeparator,
    String decimalSeparator,
    int maxDecimals,
  ) {
    final gap = spaced ? _space : '';
    return MoneyInputFormat(
      groupSeparator: groupSeparator,
      decimalSeparator: decimalSeparator,
      maxDecimals: maxDecimals,
      prefix: after ? '' : '$symbol$gap',
      suffix: after ? '$gap$symbol' : '',
    );
  }

  /// Intl pattern with [decimalDigits] decimals, such as `¤ #,##0`.
  String pattern(int decimalDigits) {
    final number =
        decimalDigits == 0 ? _integer : '$_integer.${'0' * decimalDigits}';
    final gap = spaced ? _space : '';
    return after ? '$number$gap$_placeholder' : '$_placeholder$gap$number';
  }
}
