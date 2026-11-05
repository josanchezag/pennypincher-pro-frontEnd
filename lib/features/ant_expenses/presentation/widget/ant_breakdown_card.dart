import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/utils/percent_formatter.dart';
import 'package:pennypincher_pro/core/widgets/money_format_scope.dart';
import 'package:pennypincher_pro/core/widgets/report_section_card.dart';
import 'package:pennypincher_pro/features/ant_expenses/domain/entity/ant_expense_report_entity.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/ant_expense_categories.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/bloc/ant_section.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/widget/ant_section_states.dart';

/// Where the current period goes: one bar per category with its amount
/// and share of the period total, in the order of the categories.
class AntBreakdownCard extends StatelessWidget {
  const AntBreakdownCard({
    required this.summary,
    required this.onRetry,
    super.key,
  });

  static const List<double> skeletonHeights = [
    AppSpacing.xl,
    AppSpacing.xl,
    AppSpacing.xl,
  ];

  final AntSection<AntSummary> summary;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ReportSectionCard(
      title: l10n.antBreakdownTitle,
      child: switch (summary) {
        AntSectionLoading() =>
          const AntSectionSkeleton(heights: skeletonHeights),
        AntSectionFailure(:final message) => AntSectionError(
            title: l10n.antSummaryLoadError,
            message: message,
            onRetry: onRetry,
          ),
        AntSectionLoaded(:final value) when value.byCategory.isEmpty => Text(
            l10n.antBreakdownEmpty,
            style: AppTypography.bodyMedium,
          ),
        AntSectionLoaded(:final value) => AntCategoryBars(
            shares: value.byCategory,
          ),
      },
    );
  }
}

/// A bar per category share, also used for the categories of a cut.
class AntCategoryBars extends StatelessWidget {
  const AntCategoryBars({required this.shares, super.key});

  final List<AntCategoryShare> shares;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (index, share) in shares.indexed) ...[
          if (index > 0) const SizedBox(height: AppSpacing.sm),
          _ShareRow(share: share),
        ],
      ],
    );
  }
}

class _ShareRow extends StatelessWidget {
  const _ShareRow({required this.share});

  static const double barHeight = AppSpacing.xs;
  static const double percentWidth = 64;
  static const double full = 100;

  final AntCategoryShare share;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final label = share.category.label(l10n);
    final amount = context.money.format(share.total);
    final percent = PercentFormatter.format(share.percentage);
    return Semantics(
      container: true,
      label: [label, amount, percent, l10n.expenseItemCount(share.count)]
          .join(', '),
      child: ExcludeSemantics(
        child: Row(
          children: [
            Icon(
              share.category.icon,
              size: AppSpacing.lg,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          label,
                          style: AppTypography.bodyMedium
                              .copyWith(color: AppColors.textPrimary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(amount, style: AppTypography.monoSmall),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(barHeight),
                    child: LinearProgressIndicator(
                      value: (share.percentage / full).clamp(0, 1).toDouble(),
                      minHeight: barHeight,
                      color: AppColors.accentGold,
                      backgroundColor: AppColors.backgroundTertiary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: percentWidth,
              child: Text(
                percent,
                textAlign: TextAlign.right,
                style: AppTypography.monoMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
