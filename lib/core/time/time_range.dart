import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/time/calendar_month.dart';

/// Span of history a report shows, ending at the current month: the last
/// [months] months including it, or everything when [months] is `null`.
enum TimeRange {
  sixMonths(6),
  oneYear(12),
  threeYears(36),
  all(null);

  const TimeRange(this.months);

  final int? months;

  /// Short name of the range: `6M`, `1Y`, `3Y` or `All` in English.
  String label(AppLocalizations l10n) => switch (this) {
        sixMonths => l10n.timeRangeSixMonths,
        oneYear => l10n.timeRangeOneYear,
        threeYears => l10n.timeRangeThreeYears,
        all => l10n.timeRangeAll,
      };

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
