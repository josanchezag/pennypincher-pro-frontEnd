import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/time/time_range.dart';

/// `6M | 1Y | 3Y | All`: picks the [TimeRange] of a report. The selected
/// segment is brand blue with white text.
class TimeRangeSelector extends StatelessWidget {
  const TimeRangeSelector({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final TimeRange selected;
  final ValueChanged<TimeRange> onChanged;

  /// Brand background and white text when selected: 5.2:1 contrast,
  /// instead of the theme's dark text on muted gold.
  static final ButtonStyle style = ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith(
      (states) =>
          states.contains(WidgetState.selected) ? AppColors.brandPrimary : null,
    ),
    foregroundColor: WidgetStateProperty.resolveWith(
      (states) => states.contains(WidgetState.selected)
          ? AppColors.textOnBrand
          : AppColors.textPrimary,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<TimeRange>(
      showSelectedIcon: false,
      segments: [
        for (final range in TimeRange.values)
          ButtonSegment(value: range, label: Text(range.label)),
      ],
      selected: {selected},
      onSelectionChanged: (ranges) => onChanged(ranges.single),
      style: style,
    );
  }
}
