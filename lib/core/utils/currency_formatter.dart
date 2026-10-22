import 'package:intl/intl.dart';
import 'package:pennypincher_pro/core/utils/money.dart';

/// Formats amounts in Colombian pesos for display, without cents.
abstract final class CurrencyFormatter {
  static const String locale = 'es_CO';
  static const String symbol = r'$';
  static const String positiveSign = '+';
  static const String negativeSign = '-';
  static const String millionsSuffix = 'M';
  static const double oneMillion = 1000000;

  /// Symbol first, as written in Colombia; the `es_CO` locale data of
  /// intl places it after the number.
  static const String currencyPattern = '\u00A4\u00A0#,##0';

  static final NumberFormat _currency = NumberFormat.currency(
    locale: locale,
    symbol: symbol,
    decimalDigits: 0,
    customPattern: currencyPattern,
  );
  static final NumberFormat _millions = NumberFormat('#,##0.#', locale);
  static final NumberFormat _whole = NumberFormat('#,##0', locale);

  /// `$ 1.500.000`.
  static String format(Money amount) => _currency.format(amount.pesos);

  /// Always signed: `+$ 2.450.000` or `-$ 300.000`.
  static String formatSigned(Money amount) {
    final sign = amount.isNegative ? negativeSign : positiveSign;
    return '$sign${format(amount.abs())}';
  }

  /// Short label for chart axes: `173M` from one million up, otherwise the
  /// whole number (`850.000`).
  static String formatCompact(double pesos) {
    if (pesos.abs() >= oneMillion) {
      return '${_millions.format(pesos / oneMillion)}$millionsSuffix';
    }
    return _whole.format(pesos);
  }
}
