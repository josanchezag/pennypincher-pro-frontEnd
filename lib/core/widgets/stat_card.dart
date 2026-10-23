import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';

/// Change of a KPI against a previous value, such as
/// `+$ 2.450.000 vs Sep 2026`.
class StatDelta {
  const StatDelta({required this.text, required this.isPositive});

  final String text;

  /// Green with an up arrow when true, red with a down arrow otherwise.
  final bool isPositive;
}

/// KPI card: a label, a large value and an optional [delta]. Read by
/// screen readers as one sentence.
class StatCard extends StatelessWidget {
  const StatCard({
    required this.label,
    required this.value,
    this.icon,
    this.valueColor,
    this.delta,
    super.key,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Color? valueColor;
  final StatDelta? delta;

  @override
  Widget build(BuildContext context) {
    final change = delta;
    return Semantics(
      container: true,
      label: [label, value, if (change != null) change.text].join(', '),
      child: ExcludeSemantics(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Header(label: label, icon: icon),
                const SizedBox(height: AppSpacing.xs),
                _Value(value: value, color: valueColor),
                if (change != null) ...[
                  const SizedBox(height: AppSpacing.xxs),
                  StatDeltaLine(delta: change),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.label, required this.icon});

  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final leading = icon;
    return Row(
      children: [
        if (leading != null) ...[
          Icon(leading, size: AppSpacing.md, color: AppColors.textSecondary),
          const SizedBox(width: AppSpacing.xs),
        ],
        Expanded(
          child: Text(
            label.toUpperCase(),
            style: AppTypography.label,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _Value extends StatelessWidget {
  const _Value({required this.value, required this.color});

  /// Fixed line height, so a value shrunk to fit keeps the card height.
  static const double height = AppSpacing.xl;

  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Text(
          value,
          style: AppTypography.monoLarge.copyWith(
            fontSize: AppTypography.heading2Size,
            color: color,
          ),
        ),
      ),
    );
  }
}

/// Arrow and text of a [StatDelta], green when positive and red otherwise.
class StatDeltaLine extends StatelessWidget {
  const StatDeltaLine({required this.delta, super.key});

  /// Long deltas wrap so the reference, such as the month, stays visible.
  static const int maxDeltaLines = 2;

  final StatDelta delta;

  @override
  Widget build(BuildContext context) {
    final color = delta.isPositive ? AppColors.success : AppColors.error;
    return Row(
      children: [
        Icon(
          delta.isPositive ? Icons.arrow_upward : Icons.arrow_downward,
          size: AppSpacing.md,
          color: color,
        ),
        const SizedBox(width: AppSpacing.xxs),
        Expanded(
          child: Text(
            delta.text,
            style: AppTypography.monoSmall.copyWith(color: color),
            maxLines: maxDeltaLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
