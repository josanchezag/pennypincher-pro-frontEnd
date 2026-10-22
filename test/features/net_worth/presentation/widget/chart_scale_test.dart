import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/widget/chart_scale.dart';

import '../../../../helpers/net_worth_fixtures.dart';

void main() {
  test('picks round intervals of 1, 2 or 5 times a power of ten', () {
    expect(ChartScale.niceInterval(173000000), 50000000);
    expect(ChartScale.niceInterval(7000000), 2000000);
    expect(ChartScale.niceInterval(4), 1);
    expect(ChartScale.niceInterval(0), 1);
  });

  test('shows at least six months ending at the latest snapshot', () {
    final scale = ChartScale.of([august, september]);

    expect(scale.maxX, 1);
    expect(scale.minX, -4);
    expect(scale.visibleMonths, ChartScale.minVisibleMonths);
    expect(scale.monthAt(-4), DateTime(2026, 4));
    expect(scale.xOf(DateTime(2026, 9)), 1);
  });

  test('keeps every month of a longer history', () {
    final history = [
      snapshotOf(2021, 10, 50000000),
      snapshotOf(2026, 9, 170550000),
    ];

    final scale = ChartScale.of(history);

    expect(scale.minX, 0);
    expect(scale.visibleMonths, 60);
    expect(scale.monthAt(scale.maxX), DateTime(2026, 9));
  });

  test('includes zero and rounds the value range to the interval', () {
    final scale = ChartScale.of([august, snapshotOf(2026, 9, -3000000)]);

    expect(scale.interval, 50000000);
    expect(scale.minY, -50000000);
    expect(scale.maxY, 200000000);
  });

  test('keeps a positive range when every value is zero', () {
    final scale = ChartScale.of([snapshotOf(2026, 9, 0)]);

    expect(scale.minY, 0);
    expect(scale.maxY, 1);
  });
}
