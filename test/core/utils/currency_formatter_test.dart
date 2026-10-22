import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/utils/currency_formatter.dart';
import 'package:pennypincher_pro/core/utils/money.dart';

/// es_CO separates the symbol with a no-break space.
String _plain(String text) => text.replaceAll(' ', ' ');

void main() {
  test('formats pesos with Colombian grouping and no cents', () {
    expect(
      _plain(CurrencyFormatter.format(const Money.fromPesos(173450000))),
      r'$ 173.450.000',
    );
    expect(
      _plain(CurrencyFormatter.format(const Money.fromCents(99))),
      r'$ 1',
    );
  });

  test('keeps both decimals for rates', () {
    expect(
      _plain(CurrencyFormatter.formatWithCents(const Money.fromCents(395025))),
      r'$ 3.950,25',
    );
    expect(
      _plain(CurrencyFormatter.formatWithCents(const Money.fromPesos(3300))),
      r'$ 3.300,00',
    );
  });

  test('always signs a delta', () {
    expect(
      _plain(CurrencyFormatter.formatSigned(const Money.fromPesos(2450000))),
      r'+$ 2.450.000',
    );
    expect(
      _plain(CurrencyFormatter.formatSigned(const Money.fromPesos(-300000))),
      r'-$ 300.000',
    );
  });

  test('shortens axis labels to millions', () {
    expect(CurrencyFormatter.formatCompact(173000000), '173M');
    expect(CurrencyFormatter.formatCompact(2500000), '2,5M');
    expect(CurrencyFormatter.formatCompact(-4000000), '-4M');
    expect(CurrencyFormatter.formatCompact(850000), '850.000');
  });
}
