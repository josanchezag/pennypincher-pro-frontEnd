import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/time/time_range.dart';

void main() {
  final now = DateTime(2026, 10, 23, 21, 30);

  test('starts each range at the first day of current month minus n-1', () {
    expect(TimeRange.sixMonths.startFor(now), DateTime(2026, 5));
    expect(TimeRange.oneYear.startFor(now), DateTime(2025, 11));
    expect(TimeRange.threeYears.startFor(now), DateTime(2023, 11));
  });

  test('has no start for the whole history', () {
    expect(TimeRange.all.startFor(now), isNull);
  });

  test('crosses the year boundary from the first days of January', () {
    final january = DateTime(2027, 1, 1, 0, 5);

    expect(TimeRange.sixMonths.startFor(january), DateTime(2026, 8));
    expect(TimeRange.oneYear.startFor(january), DateTime(2026, 2));
  });

  test('labels the ranges for the selector', () {
    expect(TimeRange.values.map((range) => range.label), [
      '6M',
      '1Y',
      '3Y',
      'All',
    ]);
  });
}
