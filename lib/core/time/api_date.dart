import 'package:intl/intl.dart';

/// Calendar dates and months as the API writes them: `2026-10-01` and
/// `2026-10`. Parsed dates are local dates without time.
abstract final class ApiDate {
  static final DateFormat _date = DateFormat('yyyy-MM-dd');
  static final DateFormat _month = DateFormat('yyyy-MM');

  /// `2026-10-01`.
  static String format(DateTime date) => _date.format(date);

  /// `2026-10`, the `month` query parameter.
  static String formatMonth(DateTime date) => _month.format(date);

  /// Keeps the calendar date of [json] only. Throws [FormatException] when
  /// it is not a date.
  static DateTime parse(String json) {
    final parsed = DateTime.parse(json);
    return DateTime(parsed.year, parsed.month, parsed.day);
  }
}
