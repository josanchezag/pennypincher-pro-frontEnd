import 'package:pennypincher_pro/core/time/calendar_month.dart';

/// Span of history a report shows, ending at the current month: the last
/// [months] months including it, or everything when [months] is `null`.
enum TimeRange {
  sixMonths('6M', 6),
  oneYear('1Y', 12),
  threeYears('3Y', 36),
  all('All', null);

  const TimeRange(this.label, this.months);

  final String label;
  final int? months;

  /// First day of the first month of the range when the current time is
  /// [now] (local), or `null` for [all]: 6M from October 2026 starts on
  /// May 1, 2026.
  DateTime? startFor(DateTime now) {
    final count = months;
    return count == null
        ? null
        : CalendarMonth.shift(CalendarMonth.of(now), 1 - count);
  }
}
