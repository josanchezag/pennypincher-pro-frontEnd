import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/utils/money.dart';

void main() {
  group('Money.fromJson', () {
    test('reads integers and decimals exactly', () {
      expect(Money.fromJson(1500000).cents, 150000000);
      expect(Money.fromJson(1500000.5).cents, 150000050);
      expect(Money.fromJson(0.1).cents, 10);
      expect(Money.fromJson(-12.34).cents, -1234);
    });

    test('reads numeric strings, including scientific notation', () {
      expect(Money.fromJson('1500000.00').cents, 150000000);
      expect(Money.fromJson('1.500').cents, 150);
      expect(Money.fromJson('-12.5').cents, -1250);
      expect(Money.fromJson('1.5E+7').cents, 1500000000);
    });

    test('rejects values that are not amounts', () {
      expect(() => Money.fromJson(null), throwsFormatException);
      expect(() => Money.fromJson('abc'), throwsFormatException);
      expect(() => Money.fromJson(true), throwsFormatException);
      expect(() => Money.fromJson(double.nan), throwsFormatException);
    });
  });

  test('reads an optional amount', () {
    expect(Money.fromOptionalJson(null), isNull);
    expect(Money.fromOptionalJson(1500.5), const Money.fromCents(150050));
  });

  group('Money.tryParseInput', () {
    test('reads Colombian grouping and decimal comma', () {
      expect(
        Money.tryParseInput('1.500.000'),
        const Money.fromUnits(1500000),
      );
      expect(Money.tryParseInput(' 1.500.000,50 ')?.cents, 150000050);
      expect(Money.tryParseInput('1500000,5')?.cents, 150000050);
      expect(Money.tryParseInput('1.500')?.cents, 150000);
      expect(Money.tryParseInput('0')?.cents, 0);
    });

    test('reads a dot followed by one or two digits as decimals', () {
      expect(Money.tryParseInput('10.25')?.cents, 1025);
      expect(Money.tryParseInput('1500000.5')?.cents, 150000050);
    });

    test('reads the cents of dollars and euros typed either way', () {
      for (final text in ['1234.56', '1234,56', '1.234,56', '0.5', '0,05']) {
        expect(Money.tryParseInput(text), isNotNull, reason: text);
      }
      expect(Money.tryParseInput('1234.56')?.cents, 123456);
      expect(Money.tryParseInput('1234,56')?.cents, 123456);
      expect(Money.tryParseInput('0,05')?.cents, 5);
    });

    test('rejects malformed, negative and oversized amounts', () {
      expect(Money.tryParseInput('1.50.000'), isNull);
      expect(Money.tryParseInput('1,500,000'), isNull);
      expect(Money.tryParseInput('1,234.56'), isNull);
      expect(Money.tryParseInput('1.234,567'), isNull);
      expect(Money.tryParseInput('-3'), isNull);
      expect(Money.tryParseInput(''), isNull);
      expect(Money.tryParseInput('1e5'), isNull);
      expect(Money.tryParseInput('12345678901234567890123'), isNull);
      expect(Money.tryParseInput('10.000.000.000.000'), isNull);
      expect(
        Money.tryParseInput('9.999.999.999.999,99')?.cents,
        Money.maxCents,
      );
    });
  });

  group('arithmetic and JSON', () {
    test('adds and subtracts without rounding errors', () {
      final sum = Money.fromJson(0.1) + Money.fromJson(0.2);

      expect(sum, Money.fromJson(0.3));
      expect((Money.zero - sum).isNegative, isTrue);
      expect((Money.zero - sum).abs(), sum);
      expect(Money.zero.isZero, isTrue);
    });

    test('sums a collection', () {
      expect(
        sumMoney([1, 2, 3], Money.fromUnits),
        const Money.fromUnits(6),
      );
    });

    test('writes integers when there are no cents', () {
      expect(const Money.fromUnits(1500000).toJson(), 1500000);
      expect(const Money.fromUnits(1500000).toJson(), isA<int>());
      expect(const Money.fromCents(150000050).toJson(), 1500000.5);
      expect(const Money.fromCents(-150).toJson(), -1.5);
      expect(const Money.fromCents(150000050).toInputString(), '1500000,50');
      expect(const Money.fromUnits(7).toInputString(), '7');
    });

    test('keeps every cent of the largest amount in JSON', () {
      const largest = Money.fromCents(Money.maxCents);

      expect(
        jsonEncode({'value': largest.toJson()}),
        '{"value":9999999999999.99}',
      );
      expect(Money.fromJson(jsonDecode(jsonEncode(largest.toJson()))), largest);
    });

    test('compares by amount', () {
      expect(
        const Money.fromUnits(2).compareTo(const Money.fromUnits(1)),
        greaterThan(0),
      );
      expect(const Money.fromCents(150).units, 1.5);
      expect(const Money.fromUnits(1).toString(), 'Money(100)');
    });
  });
}
