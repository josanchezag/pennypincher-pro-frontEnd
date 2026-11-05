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

  group('Money.tryFromDigits', () {
    test('builds the exact amount from whole digits and decimals', () {
      expect(Money.tryFromDigits('1500000'), const Money.fromUnits(1500000));
      expect(Money.tryFromDigits('1500000', '5')?.cents, 150000050);
      expect(Money.tryFromDigits('1500000', '50')?.cents, 150000050);
      expect(Money.tryFromDigits('0', '05')?.cents, 5);
      expect(Money.tryFromDigits('', '5')?.cents, 50);
      expect(Money.tryFromDigits('0007')?.cents, 700);
      expect(Money.tryFromDigits('0')?.cents, 0);
    });

    test('rejects anything but digits, extra decimals and oversized amounts',
        () {
      expect(Money.tryFromDigits(''), isNull);
      expect(Money.tryFromDigits('1.500'), isNull);
      expect(Money.tryFromDigits('-3'), isNull);
      expect(Money.tryFromDigits('1', '505'), isNull);
      expect(Money.tryFromDigits('10000000000000'), isNull);
      expect(Money.tryFromDigits('9999999999999', '99')?.cents, Money.maxCents);
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
