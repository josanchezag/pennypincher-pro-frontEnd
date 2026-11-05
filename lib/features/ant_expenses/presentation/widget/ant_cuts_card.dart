import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/time/day_format.dart';
import 'package:pennypincher_pro/core/time/month_format.dart';
import 'package:pennypincher_pro/core/utils/percent_formatter.dart';
import 'package:pennypincher_pro/core/widgets/money_format_scope.dart';
import 'package:pennypincher_pro/core/widgets/report_section_card.dart';
import 'package:pennypincher_pro/features/ant_expenses/domain/entity/ant_expense_report_entity.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/ant_expense_categories.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/bloc/ant_section.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/widget/ant_section_states.dart';

/// The past cuts, newest month first: the month of the budget, its total,
/// how many expenses and the days they were bought, and the top
/// categories. Tapping one opens its expenses through [onOpen].
class AntCutsCard extends StatelessWidget {
  const AntCutsCard({
    required this.cuts,
    required this.onOpen,
    required this.onRetry,
    super.key,
  });

  static const List<double> skeletonHeights = [
    AppSpacing.xxl,
    AppSpacing.xxl,
  ];

  final AntSection<List<AntCut>> cuts;
  final ValueChanged<AntCut> onOpen;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ReportSectionCard(
      title: l10n.antCutsTitle,
      child: switch (cuts) {
        AntSectionLoading() =>
          const AntSectionSkeleton(heights: skeletonHeights),
        AntSectionFailure(:final message) => AntSectionError(
            title: l10n.antCutsLoadError,
            message: message,
            onRetry: onRetry,
          ),
        AntSectionLoaded(:final value) when value.isEmpty =>
          Text(l10n.antCutsEmpty, style: AppTypography.bodyMedium),
        AntSectionLoaded(:final value) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final (index, cut) in value.indexed) ...[
                if (index > 0) const Divider(height: AppSpacing.xxs),
                _CutRow(cut: cut, onTap: () => onOpen(cut)),
              ],
            ],
          ),
      },
    );
  }
}

class _CutRow extends StatelessWidget {
  const _CutRow({required this.cut, required this.onTap});

  /// Categories named under each cut.
  static const int topCategories = 3;
  static const String separator = ' · ';

  final AntCut cut;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final month = MonthFormat.long.format(cut.month);
    final total = context.money.format(cut.total);
    final details = [
      l10n.expenseItemCount(cut.count),
      AntCutTexts.period(l10n, cut),
    ].join(separator);
    final categories = AntCutTexts.topCategories(l10n, cut, topCategories);
    return MergeSemantics(
      child: Semantics(
        button: true,
        hint: l10n.antCutOpenHint,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _capitalized(month),
                        style: AppTypography.bodyLarge,
                      ),
                      Text(details, style: AppTypography.bodySmall),
                      if (categories.isNotEmpty)
                        Text(
                          categories,
                          style: AppTypography.bodySmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  total,
                  style: AppTypography.monoMedium
                      .copyWith(color: AppColors.warning),
                ),
                const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _capitalized(String text) =>
      text.isEmpty ? text : text[0].toUpperCase() + text.substring(1);
}

/// Texts that describe a cut, shared by its row and its sheet.
abstract final class AntCutTexts {
  /// `Purchases from Oct 1 to Oct 31`.
  static String period(AppLocalizations l10n, AntCut cut) => l10n.antCutPeriod(
        DayFormat.short.format(cut.periodStart),
        DayFormat.short.format(cut.periodEnd),
      );

  /// The [count] largest categories with their share, largest first:
  /// `Fast food 56.6% · Coffee and drinks 30.0%`.
  static String topCategories(AppLocalizations l10n, AntCut cut, int count) {
    final shares = [...cut.byCategory]
      ..sort((a, b) => b.total.compareTo(a.total));
    return shares
        .take(count)
        .map(
          (share) => '${share.category.label(l10n)} '
              '${PercentFormatter.format(share.percentage)}',
        )
        .join(_CutRow.separator);
  }
}
