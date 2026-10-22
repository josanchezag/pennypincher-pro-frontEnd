import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/crud/domain/balance_item.dart';
import 'package:pennypincher_pro/core/utils/money.dart';

void main() {
  group('paidShare', () {
    test('is the share of the original amount already paid', () {
      expect(
        paidShare(
          balance: const Money.fromPesos(30000000),
          originalAmount: const Money.fromPesos(50000000),
        ),
        closeTo(0.4, 1e-9),
      );
    });

    test('stays between nothing and everything paid', () {
      expect(
        paidShare(
          balance: const Money.fromPesos(11),
          originalAmount: const Money.fromPesos(10),
        ),
        0,
      );
      expect(
        paidShare(
          balance: Money.zero,
          originalAmount: const Money.fromPesos(1),
        ),
        1,
      );
    });

    test('is unknown without a positive original amount', () {
      expect(paidShare(balance: const Money.fromPesos(5)), isNull);
      expect(
        paidShare(
          balance: const Money.fromPesos(5),
          originalAmount: Money.zero,
        ),
        isNull,
      );
    });
  });
}
