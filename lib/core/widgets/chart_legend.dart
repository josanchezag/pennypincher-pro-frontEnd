import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';

/// One series of a chart: its [color] and [label].
class LegendEntry {
  const LegendEntry({required this.color, required this.label});

  final Color color;
  final String label;
}

/// Colored marks with the label of every series of a chart, wrapping onto
/// more lines when they do not fit.
class ChartLegend extends StatelessWidget {
  const ChartLegend({required this.entries, super.key});

  static const double markSize = AppSpacing.sm;

  final List<LegendEntry> entries;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.xs,
      children: [
        for (final entry in entries)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: markSize,
                height: markSize,
                decoration: BoxDecoration(
                  color: entry.color,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(AppSpacing.xxs),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(entry.label, style: AppTypography.bodySmall),
            ],
          ),
      ],
    );
  }
}
