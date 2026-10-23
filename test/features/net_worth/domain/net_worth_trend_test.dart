import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/net_worth_trend_entity.dart';

import '../../../helpers/net_worth_fixtures.dart';

void main() {
  group('NetWorthTrend', () {
    test('finds the month with the highest net worth', () {
      expect(threeMonthTrend.best?.month, DateTime(2026, 9));
    });

    test('prefers the latest month on a tie for the best one', () {
      final trend = NetWorthTrend([
        trendPointOf(8, assets: 100, liabilities: 0),
        trendPointOf(9, assets: 100, liabilities: 0),
      ]);

      expect(trend.best?.month, DateTime(2026, 9));
    });

    test('measures the change from the first to the last month', () {
      expect(threeMonthTrend.change, const Money.fromPesos(30000000));
      expect(threeMonthTrend.changePercentage, closeTo(30, 1e-9));
    });

    test('measures the percentage against a negative start', () {
      final trend = NetWorthTrend([
        trendPointOf(8, assets: 0, liabilities: 200),
        trendPointOf(9, assets: 0, liabilities: 100),
      ]);

      expect(trend.change, const Money.fromPesos(100));
      expect(trend.changePercentage, closeTo(50, 1e-9));
    });

    test('has no percentage when the range started at zero', () {
      final trend = NetWorthTrend([
        trendPointOf(8, assets: 0, liabilities: 0),
        trendPointOf(9, assets: 500, liabilities: 0),
      ]);

      expect(trend.change, const Money.fromPesos(500));
      expect(trend.changePercentage, isNull);
    });

    test('has nothing to summarize without points', () {
      const trend = NetWorthTrend([]);

      expect(trend.isEmpty, isTrue);
      expect(trend.best, isNull);
      expect(trend.change, isNull);
      expect(trend.changePercentage, isNull);
    });
  });
}
