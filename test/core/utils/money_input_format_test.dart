import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/utils/app_currency.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/utils/money_formatter.dart';
import 'package:pennypincher_pro/core/utils/money_input_format.dart';

MoneyInputFormat _format(AppCurrency currency, String language) =>
    MoneyFormatter.of(currency, language).inputFormat;

void main() {
  test('writes amounts with the separators of each language', () {
    const amount = Money.fromCents(123456750);
    const whole = Money.fromUnits(1500000);
    final cases = {
      (AppCurrency.cop, 'es'): ('1.500.000', '1.234.567,50'),
      (AppCurrency.cop, 'en'): ('1,500,000', '1,234,567.50'),
      (AppCurrency.usd, 'es'): ('1.500.000', '1.234.567,50'),
      (AppCurrency.usd, 'en'): ('1,500,000', '1,234,567.50'),
      (AppCurrency.eur, 'es'): ('1.500.000', '1.234.567,50'),
      (AppCurrency.eur, 'en'): ('1,500,000', '1,234,567.50'),
    };
    for (final MapEntry(key: (currency, language), value: (plain, cents))
        in cases.entries) {
      final format = _format(currency, language);
      final reason = '${currency.code} $language';

      expect(format.format(whole), plain, reason: reason);
      expect(format.format(amount), cents, reason: reason);
      expect(format.parse(plain), whole, reason: reason);
    }
  });

  test('writes nothing for no amount and zero as 0', () {
    final format = _format(AppCurrency.cop, 'es');

    expect(format.format(null), '');
    expect(format.format(Money.zero), '0');
    expect(format.format(const Money.fromCents(5)), '0,05');
  });

  test('reads back exactly what it writes, up to the largest amount', () {
    final format = _format(AppCurrency.usd, 'en');
    for (final cents in [0, 5, 150, 100000, 123456789, Money.maxCents]) {
      final amount = Money.fromCents(cents);

      expect(format.parse(format.format(amount)), amount, reason: '$cents');
    }
  });

  test('reads the decimals the user is still typing', () {
    final spanish = _format(AppCurrency.usd, 'es');
    final english = _format(AppCurrency.usd, 'en');

    expect(spanish.parse('1.500,'), const Money.fromUnits(1500));
    expect(spanish.parse('1.500,5'), const Money.fromCents(150050));
    expect(spanish.parse('1.500.5'), const Money.fromCents(150050));
    expect(spanish.parse('1.500.50'), const Money.fromCents(150050));
    expect(english.parse('1,5'), const Money.fromCents(150));
    expect(english.parse('1,500'), const Money.fromUnits(1500));
  });

  test('has no amount for empty, oversized or overlong text', () {
    final pesos = _format(AppCurrency.cop, 'es');
    final dollars = _format(AppCurrency.usd, 'en');

    expect(pesos.parse(''), isNull);
    expect(pesos.parse('1.500,5'), isNull);
    expect(dollars.parse('1.505'), isNull);
    expect(dollars.parse('10,000,000,000,000'), isNull);
  });

  test('reads a peso thousands dot as grouping, never as decimals', () {
    final pesos = _format(AppCurrency.cop, 'es');

    expect(pesos.parse('1.5'), const Money.fromUnits(15));
    expect(pesos.classify('1.5'), [
      MoneyCharKind.digit,
      MoneyCharKind.group,
      MoneyCharKind.digit,
    ]);
  });

  test('makes room for the cents of a peso amount saved with them', () {
    final pesos = _format(AppCurrency.cop, 'es');

    expect(pesos.keepingCentsOf(const Money.fromUnits(5)), pesos);
    expect(pesos.keepingCentsOf(null), pesos);
    expect(
      pesos.keepingCentsOf(const Money.fromCents(150)).maxDecimals,
      MoneyInputFormat.centsDigits,
    );
    expect(
      _format(AppCurrency.usd, 'es').keepingCentsOf(Money.zero).maxDecimals,
      2,
    );
  });
}
