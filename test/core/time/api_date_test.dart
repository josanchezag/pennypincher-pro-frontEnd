import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/time/api_date.dart';

void main() {
  test('writes dates and months as the API reads them', () {
    expect(ApiDate.format(DateTime(2026, 2, 1, 23)), '2026-02-01');
    expect(ApiDate.formatMonth(DateTime(2026, 2, 28)), '2026-02');
  });

  test('keeps the calendar date of a parsed date', () {
    expect(ApiDate.parse('2026-10-01'), DateTime(2026, 10));
    expect(() => ApiDate.parse('October'), throwsFormatException);
  });
}
