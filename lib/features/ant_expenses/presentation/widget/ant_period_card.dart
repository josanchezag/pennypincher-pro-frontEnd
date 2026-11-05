import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/time/day_format.dart';
import 'package:pennypincher_pro/core/utils/percent_formatter.dart';
import 'package:pennypincher_pro/core/widgets/money_format_scope.dart';
import 'package:pennypincher_pro/features/ant_expenses/domain/entity/ant_expense_report_entity.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/ant_expense_categories.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/bloc/ant_section.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/widget/ant_section_states.dart';

/// Color of the use of the monthly limit: green below [warningFrom] %,
/// amber up to the limit and red past it.
enum AntLimitBand {
  comfortable(AppColors.success),
  close(AppColors.warning),
  exceeded(AppColors.error);

  const AntLimitBand(this.color);

  final Color color;

  static const double warningFrom = 80;
  static const double full = 100;

  static AntLimitBand of(AntLimitUsage usage) {
    if (usage.exceeded || usage.usedPercentage > full) {
      return exceeded;
    }
    return usage.usedPercentage >= warningFrom ? close : comfortable;
  }
}

/// Totals of the current period: the amount, how many expenses, the daily
/// average, how long since the last cut, the top category and the use of
/// the monthly limit, with the button that sets or changes it.
class AntPeriodCard extends StatelessWidget {
  const AntPeriodCard({
    required this.summary,
    required this.onRetry,
    required this.onEditLimit,
    super.key,
  });

  static const Key limitButtonKey = Key('ant-limit-button');
  static const Key limitBarKey = Key('ant-limit-bar');
  static const List<double> skeletonHeights = [
    AppSpacing.md,
    AppSpacing.xl,
    AppSpacing.md,
    AppSpacing.md,
  ];

  final AntSection<AntSummary> summary;
  final VoidCallback onRetry;

  /// Null while the limit cannot be changed.
  final VoidCallback? onEditLimit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: switch (summary) {
          AntSectionLoading() =>
            const AntSectionSkeleton(heights: skeletonHeights),
          AntSectionFailure(:final message) => AntSectionError(
              title: l10n.antSummaryLoadError,
              message: message,
              onRetry: onRetry,
            ),
          AntSectionLoaded(:final value) =>
            _Totals(summary: value, onEditLimit: onEditLimit),
        },
      ),
    );
  }
}

class _Totals extends StatelessWidget {
  const _Totals({required this.summary, required this.onEditLimit});

  final AntSummary summary;
  final VoidCallback? onEditLimit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final money = context.money;
    final total = money.format(summary.total);
    final top = summary.topCategory;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          container: true,
          label: '${l10n.antCurrentPeriod}, $total',
          child: ExcludeSemantics(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.local_cafe_outlined,
                      size: AppSpacing.md,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      l10n.antCurrentPeriod.toUpperCase(),
                      style: AppTypography.label,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    total,
                    style: AppTypography.monoLarge.copyWith(
                      fontSize: AppTypography.heading1Size,
                      color: AppColors.warning,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.lg,
          runSpacing: AppSpacing.xs,
          children: [
            Text(
              l10n.expenseItemCount(summary.count),
              style: AppTypography.bodyMedium,
            ),
            Text(
              l10n.labelValue(
                l10n.antDailyAverage,
                money.format(summary.dailyAverage),
              ),
              style: AppTypography.bodyMedium,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(_cutText(l10n), style: AppTypography.bodySmall),
        if (top != null) ...[
          const SizedBox(height: AppSpacing.xs),
          _TopCategory(label: top.label(l10n), icon: top.icon),
        ],
        const Divider(height: AppSpacing.xl),
        _Limit(usage: summary.limit, onEdit: onEditLimit),
      ],
    );
  }

  /// `Since the last cut: 4 days · Period since Nov 1, 2026`, or `No cuts
  /// yet` before the first cut.
  String _cutText(AppLocalizations l10n) {
    const separator = ' · ';
    final days = summary.daysSinceLastCut;
    final start = summary.periodStart;
    return [
      if (summary.lastCut == null || days == null)
        l10n.antNoCutsYet
      else
        l10n.antSinceLastCut(days),
      if (start != null) l10n.antPeriodSince(DayFormat.medium.format(start)),
    ].join(separator);
  }
}

class _TopCategory extends StatelessWidget {
  const _TopCategory({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: '${context.l10n.antTopCategory}: $label',
      child: ExcludeSemantics(
        child: Row(
          children: [
            Text(
              '${context.l10n.antTopCategory}: ',
              style: AppTypography.bodySmall,
            ),
            Icon(icon, size: AppSpacing.md, color: AppColors.accentGold),
            const SizedBox(width: AppSpacing.xxs),
            Flexible(
              child: Text(
                label,
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textPrimary),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Use of the monthly limit as a colored bar with what is left (or how
/// far past it the period is), or a note when there is no limit.
class _Limit extends StatelessWidget {
  const _Limit({required this.usage, required this.onEdit});

  static const double barHeight = AppSpacing.xs;

  final AntLimitUsage? usage;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final usage = this.usage;
    final button = OutlinedButton.icon(
      key: AntPeriodCard.limitButtonKey,
      onPressed: onEdit,
      icon: const Icon(Icons.tune, size: AppSpacing.md),
      label: Text(usage == null ? l10n.antLimitSet : l10n.antLimitChange),
    );
    final heading = Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.xs,
      children: [
        Text(l10n.antLimitTitle.toUpperCase(), style: AppTypography.label),
        button,
      ],
    );
    if (usage == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          heading,
          const SizedBox(height: AppSpacing.xxs),
          Text(l10n.antLimitNone, style: AppTypography.bodySmall),
        ],
      );
    }
    final money = context.money;
    final band = AntLimitBand.of(usage);
    final used = l10n.antLimitUsed(
      PercentFormatter.format(usage.usedPercentage),
      money.format(usage.monthlyLimit),
    );
    final left = usage.exceeded
        ? l10n.antLimitExceeded(money.format(usage.remaining.abs()))
        : l10n.antLimitRemaining(money.format(usage.remaining));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        heading,
        const SizedBox(height: AppSpacing.xs),
        Semantics(
          container: true,
          label: '${l10n.antLimitTitle}, $used, $left',
          child: ExcludeSemantics(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(barHeight),
                  child: LinearProgressIndicator(
                    key: AntPeriodCard.limitBarKey,
                    value: (usage.usedPercentage / AntLimitBand.full)
                        .clamp(0, 1)
                        .toDouble(),
                    minHeight: barHeight,
                    color: band.color,
                    backgroundColor: AppColors.backgroundTertiary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: AppSpacing.sm,
                  children: [
                    Text(
                      left,
                      style: AppTypography.bodyMedium.copyWith(
                        color: band.color,
                      ),
                    ),
                    Text(used, style: AppTypography.monoSmall),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
