import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/utils/app_currency.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/utils/money_formatter.dart';
import 'package:pennypincher_pro/core/utils/money_input_format.dart';

/// The formats put a no-break space between symbol and number.
String _plain(String text) => text.replaceAll(' ', ' ');

MoneyFormatter _formatter(AppCurrency currency, String language) =>
    MoneyFormatter.of(currency, language);

void main() {
  const amount = Money.fromCents(123456750);

  group('format', () {
    const expected = {
      (AppCurrency.cop, 'es'): r'$ 1.234.568',
      (AppCurrency.cop, 'en'): 'COP 1,234,568',
      (AppCurrency.usd, 'es'): r'US$ 1.234.567,50',
      (AppCurrency.usd, 'en'): r'$1,234,567.50',
      (AppCurrency.eur, 'es'): '1.234.567,50 €',
      (AppCurrency.eur, 'en'): '€1,234,567.50',
    };
    for (final MapEntry(key: (currency, language), value: text)
        in expected.entries) {
      test('writes 1234567.50 in ${currency.code} for $language as $text', () {
        expect(_plain(_formatter(currency, language).format(amount)), text);
      });
    }

    test('keeps Colombian pesos as they were shown in Spanish', () {
      final pesos = _formatter(AppCurrency.cop, 'es');

      expect(
        _plain(pesos.format(const Money.fromUnits(173450000))),
        r'$ 173.450.000',
      );
      expect(_plain(pesos.format(const Money.fromCents(99))), r'$ 1');
      expect(_plain(pesos.format(const Money.fromCents(49))), r'$ 0');
    });

    test('shows the cents of dollars and euros', () {
      expect(
        _plain(_formatter(AppCurrency.usd, 'en').format(Money.zero)),
        r'$0.00',
      );
      expect(
        _plain(
          _formatter(AppCurrency.eur, 'es').format(const Money.fromCents(5)),
        ),
        '0,05 €',
      );
    });

    test('puts the minus sign first', () {
      const debt = Money.fromCents(-150050);

      expect(
        _plain(_formatter(AppCurrency.eur, 'es').format(debt)),
        '-1.500,50 €',
      );
      expect(
        _plain(_formatter(AppCurrency.usd, 'en').format(debt)),
        r'-$1,500.50',
      );
    });
  });

  test('always signs a delta', () {
    final pesos = _formatter(AppCurrency.cop, 'es');
    final euros = _formatter(AppCurrency.eur, 'en');

    expect(
      _plain(pesos.formatSigned(const Money.fromUnits(2450000))),
      r'+$ 2.450.000',
    );
    expect(
      _plain(pesos.formatSigned(const Money.fromUnits(-300000))),
      r'-$ 300.000',
    );
    expect(_plain(euros.formatSigned(Money.zero)), '+€0.00');
    expect(
      _plain(euros.formatSigned(const Money.fromCents(-12345))),
      '-€123.45',
    );
  });

  test('writes the TRM as pesos with cents whatever the currency', () {
    const rate = Money.fromCents(395025);
    for (final currency in AppCurrency.values) {
      expect(
        _plain(_formatter(currency, 'es').formatExchangeRate(rate)),
        r'$ 3.950,25',
      );
      expect(
        _plain(_formatter(currency, 'en').formatExchangeRate(rate)),
        'COP 3,950.25',
      );
    }
    expect(
      _plain(
        _formatter(AppCurrency.cop, 'es')
            .formatExchangeRate(const Money.fromUnits(3300)),
      ),
      r'$ 3.300,00',
    );
  });

  test('shortens axis labels to millions with the language separators', () {
    final spanish = _formatter(AppCurrency.usd, 'es');
    final english = _formatter(AppCurrency.cop, 'en');

    expect(spanish.formatCompact(173000000), '173M');
    expect(spanish.formatCompact(2500000), '2,5M');
    expect(spanish.formatCompact(-4000000), '-4M');
    expect(spanish.formatCompact(850000), '850.000');
    expect(english.formatCompact(2500000), '2.5M');
    expect(english.formatCompact(850000), '850,000');
    expect(english.formatCompact(1234.5), '1,235');
  });

  test('gives amount fields the separators, decimals and symbol', () {
    String decoration(MoneyInputFormat format) =>
        '${format.prefix}1${format.groupSeparator}000'
        '${format.decimalSeparator}${format.maxDecimals}${format.suffix}';

    expect(
      decoration(_formatter(AppCurrency.cop, 'es').inputFormat),
      '\$\u00A01.000,0',
    );
    expect(
      decoration(_formatter(AppCurrency.cop, 'en').inputFormat),
      'COP\u00A01,000.0',
    );
    expect(
      decoration(_formatter(AppCurrency.usd, 'es').inputFormat),
      'US\$\u00A01.000,2',
    );
    expect(
      decoration(_formatter(AppCurrency.usd, 'en').inputFormat),
      '\$1,000.2',
    );
    expect(
      decoration(_formatter(AppCurrency.eur, 'es').inputFormat),
      '1.000,2\u00A0€',
    );
    expect(
      decoration(_formatter(AppCurrency.eur, 'en').inputFormat),
      '€1,000.2',
    );
  });

  test('gives the TRM field pesos with two decimals', () {
    final spanish = _formatter(AppCurrency.usd, 'es').exchangeRateInputFormat;
    final english = _formatter(AppCurrency.eur, 'en').exchangeRateInputFormat;

    expect(spanish.maxDecimals, 2);
    expect(spanish.prefix, '\$\u00A0');
    expect(spanish.decimalSeparator, ',');
    expect(english.maxDecimals, 2);
    expect(english.prefix, 'COP\u00A0');
    expect(english.decimalSeparator, '.');
  });

  test('shares one formatter per currency and language', () {
    final first = MoneyFormatter.of(AppCurrency.usd, 'en');

    expect(identical(first, MoneyFormatter.of(AppCurrency.usd, 'en')), isTrue);
    expect(identical(first, MoneyFormatter.of(AppCurrency.usd, 'es')), isFalse);
    expect(first.currency, AppCurrency.usd);
    expect(first.languageCode, 'en');
  });

  test('formats an unknown language as Spanish', () {
    final formatter = MoneyFormatter.of(AppCurrency.cop, 'fr');

    expect(formatter.languageCode, 'es');
    expect(_plain(formatter.format(const Money.fromUnits(1500))), r'$ 1.500');
  });

  group('AppCurrency', () {
    test('finds a currency by its exact code', () {
      expect(AppCurrency.forCode('COP'), AppCurrency.cop);
      expect(AppCurrency.forCode('USD'), AppCurrency.usd);
      expect(AppCurrency.forCode('EUR'), AppCurrency.eur);
      for (final code in ['usd', 'GBP', '', null]) {
        expect(AppCurrency.forCode(code), isNull, reason: '$code');
      }
    });

    test('has pesos as the default, without decimals', () {
      expect(AppCurrency.fallback, AppCurrency.cop);
      expect(AppCurrency.cop.decimalDigits, 0);
      expect(AppCurrency.usd.decimalDigits, 2);
      expect(AppCurrency.eur.decimalDigits, 2);
    });

    test('only shows the TRM for the currencies it relates', () {
      expect(AppCurrency.cop.hasExchangeRate, isTrue);
      expect(AppCurrency.usd.hasExchangeRate, isTrue);
      expect(AppCurrency.eur.hasExchangeRate, isFalse);
    });
  });
}
