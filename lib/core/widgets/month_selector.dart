import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/time/calendar_month.dart';
import 'package:pennypincher_pro/core/time/month_format.dart';

/// `← October 2026 →`: shows [month] and moves one month back or forward.
/// The arrows stop at [first] and [last] when given, and are disabled
/// while [enabled] is false.
class MonthSelector extends StatelessWidget {
  const MonthSelector({
    required this.month,
    required this.onChanged,
    this.first,
    this.last,
    this.enabled = true,
    super.key,
  });

  static const String previousTooltip = 'Previous month';
  static const String nextTooltip = 'Next month';
  static const Key previousKey = Key('month-selector-previous');
  static const Key nextKey = Key('month-selector-next');

  /// Wide enough for the longest month name, so the arrows never move.
  static const double labelWidth = 160;

  /// Any day of the month shown.
  final DateTime month;
  final ValueChanged<DateTime> onChanged;
  final DateTime? first;
  final DateTime? last;
  final bool enabled;

  /// `October 2026`.
  static String label(DateTime month) => MonthFormat.long.format(month);

  @override
  Widget build(BuildContext context) {
    final current = CalendarMonth.of(month);
    final previous = CalendarMonth.shift(current, -1);
    final next = CalendarMonth.shift(current, 1);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _arrow(previousKey, previousTooltip, Icons.chevron_left, previous),
        const SizedBox(width: AppSpacing.xxs),
        SizedBox(
          width: labelWidth,
          child: Semantics(
            liveRegion: true,
            child: Text(
              label(current),
              style: AppTypography.heading3,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.xxs),
        _arrow(nextKey, nextTooltip, Icons.chevron_right, next),
      ],
    );
  }

  Widget _arrow(Key key, String tooltip, IconData icon, DateTime target) =>
      IconButton(
        key: key,
        tooltip: tooltip,
        icon: Icon(icon),
        onPressed: _allows(target) ? () => onChanged(target) : null,
      );

  bool _allows(DateTime target) {
    final lower = first;
    final upper = last;
    return enabled &&
        (lower == null || !target.isBefore(CalendarMonth.of(lower))) &&
        (upper == null || !target.isAfter(CalendarMonth.of(upper)));
  }
}
