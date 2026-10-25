import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/monthly_comparison_entity.dart';

void main() {
  final bands = {
    30.01: CashFlowBand.healthy,
    48.5: CashFlowBand.healthy,
    30.0: CashFlowBand.fair,
    10.0: CashFlowBand.fair,
    9.99: CashFlowBand.low,
    -10.0: CashFlowBand.low,
  };
  for (final MapEntry(key: percentage, value: band) in bands.entries) {
    test('puts a cash flow of $percentage % in the ${band.name} band', () {
      expect(CashFlowBand.of(percentage), band);
    });
  }

  test('knows a month has a budget by its figures', () {
    final month = MonthComparison(month: DateTime(2026, 7));

    expect(month.exists, isFalse);
  });
}
