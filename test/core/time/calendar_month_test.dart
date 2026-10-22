import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/time/calendar_month.dart';

void main() {
  test('keeps the first day of the month', () {
    expect(CalendarMonth.of(DateTime(2026, 10, 22, 9)), DateTime(2026, 10));
  });

  test('shifts months across years', () {
    expect(CalendarMonth.shift(DateTime(2026, 12, 31), 1), DateTime(2027));
    expect(CalendarMonth.shift(DateTime(2026), -1), DateTime(2025, 12));
    expect(CalendarMonth.shift(DateTime(2026, 3, 31), -1), DateTime(2026, 2));
  });
}
