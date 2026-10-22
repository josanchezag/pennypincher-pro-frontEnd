import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pennypincher_pro/core/crud/domain/item_group.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/utils/currency_formatter.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/widgets/button_progress_icon.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/income_source_entity.dart';
import 'package:pennypincher_pro/features/budget/presentation/budget_texts.dart';
import 'package:pennypincher_pro/features/budget/presentation/screen/income_sources_screen.dart';
import 'package:pennypincher_pro/features/budget/presentation/widget/budget_section_card.dart';

/// The current income sources next to the budget, with a reminder that
/// the budget keeps the values of its last calculation, a warning when the
/// current total differs from [budgetIncome], and the recalculate action.
class BudgetIncomeCard extends StatelessWidget {
  const BudgetIncomeCard({
    required this.sources,
    required this.error,
    required this.budgetIncome,
    required this.recalculating,
    required this.onRecalculate,
    required this.onRetry,
    super.key,
  });

  static const Key recalculateKey = Key('recalculate-budget');
  static const Key retryKey = Key('retry-income-sources');

  /// `null` while loading or when they could not be loaded ([error]).
  final List<IncomeSource>? sources;
  final String? error;
  final Money budgetIncome;
  final bool recalculating;

  /// `null` disables the action.
  final VoidCallback? onRecalculate;

  /// Loads the income sources again after [error].
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final current = sources;
    return BudgetSectionCard(
      title: BudgetTexts.incomeTitle,
      children: [
        if (current == null) _unavailable() else ..._sources(current),
        const SizedBox(height: AppSpacing.sm),
        const Text(BudgetTexts.incomeNote, style: AppTypography.bodySmall),
        if (current != null && totalOf(current) != budgetIncome) _warning(),
        const SizedBox(height: AppSpacing.sm),
        _actions(context),
      ],
    );
  }

  /// Loading bar, or the error with a retry button.
  Widget _unavailable() {
    final message = error;
    if (message == null) {
      return const LinearProgressIndicator();
    }
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.sm,
      children: [
        Text(
          message,
          style: AppTypography.bodyMedium.copyWith(color: AppColors.error),
        ),
        TextButton.icon(
          key: retryKey,
          onPressed: onRetry,
          icon: const Icon(Icons.refresh),
          label: const Text(BudgetTexts.retry),
        ),
      ],
    );
  }

  List<Widget> _sources(List<IncomeSource> current) {
    if (current.isEmpty) {
      return const [
        Text(BudgetTexts.noIncome, style: AppTypography.bodyMedium),
      ];
    }
    const config = IncomeSourcesScreen.config;
    final groups = ItemGroup.byCategory<IncomeSource, IncomeCategory>(
      current,
      config.categories,
    );
    return [
      for (final group in groups)
        for (final source in group.items)
          _AmountLine(
            label: source.name,
            detail: config.labelOf(source.category),
            amount: source.amount,
          ),
      const Divider(),
      _AmountLine(label: BudgetTexts.currentTotal, amount: totalOf(current)),
    ];
  }

  Widget _warning() => Padding(
        padding: const EdgeInsets.only(top: AppSpacing.xs),
        child: Text(
          BudgetTexts.incomeChanged,
          style: AppTypography.bodySmall.copyWith(color: AppColors.warning),
        ),
      );

  Widget _actions(BuildContext context) => Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.xs,
        alignment: WrapAlignment.end,
        children: [
          TextButton(
            onPressed: () => context.goNamed(AppRoute.budgetIncome.name),
            child: const Text(BudgetTexts.manageIncome),
          ),
          OutlinedButton.icon(
            key: recalculateKey,
            onPressed: onRecalculate,
            icon: recalculating
                ? const ButtonProgressIcon()
                : const Icon(Icons.refresh),
            label: const Text(BudgetTexts.recalculate),
          ),
        ],
      );
}

class _AmountLine extends StatelessWidget {
  const _AmountLine({required this.label, required this.amount, this.detail});

  final String label;
  final String? detail;
  final Money amount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.bodyLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (detail != null)
                  Text(detail!, style: AppTypography.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            CurrencyFormatter.format(amount),
            style: AppTypography.monoMedium,
          ),
        ],
      ),
    );
  }
}
