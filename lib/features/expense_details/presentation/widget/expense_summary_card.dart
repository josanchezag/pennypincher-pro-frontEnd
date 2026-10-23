import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pennypincher_pro/core/crud/presentation/crud_screen_config.dart';
import 'package:pennypincher_pro/core/crud/presentation/widget/item_tile.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/utils/currency_formatter.dart';
import 'package:pennypincher_pro/core/widgets/loading_skeleton.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/expense_summary_entity.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/bloc/expenses_hub_bloc.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/expense_kinds.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/expense_texts.dart';

/// Hub card of one expense list: its live totals, a skeleton while they
/// load, or the error with a retry button. Tapping it opens the list, so
/// screen readers announce it as a button.
class ExpenseSummaryCard extends StatelessWidget {
  const ExpenseSummaryCard({
    required this.view,
    required this.status,
    required this.onRetry,
    super.key,
  });

  /// Height of a card at the default text size, enough for the longest
  /// state: an error message on two lines above the retry button.
  static const double height = 180;

  /// Height of every card in the hub grid, scaled with the text so the
  /// cards line up whatever their state and still fit their content.
  static double extentOf(BuildContext context) =>
      MediaQuery.textScalerOf(context).scale(height);

  final ExpenseKindView view;
  final SummaryStatus status;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Semantics(
        button: true,
        child: InkWell(
          onTap: () => context.goNamed(view.route.name),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Title(view: view),
                const SizedBox(height: AppSpacing.sm),
                Expanded(child: _body()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _body() => switch (status) {
        SummaryLoading() => const _Skeleton(),
        SummaryLoadFailure(:final message) =>
          _Failure(message: message, onRetry: onRetry),
        SummaryLoaded(:final summary) => _Totals(view: view, summary: summary),
      };
}

class _Title extends StatelessWidget {
  const _Title({required this.view});

  final ExpenseKindView view;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(view.icon, color: AppColors.textSecondary),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            view.route.title,
            style: AppTypography.heading3,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      ],
    );
  }
}

class _Totals extends StatelessWidget {
  const _Totals({required this.view, required this.summary});

  final ExpenseKindView view;
  final ExpenseSummary summary;

  @override
  Widget build(BuildContext context) {
    final balanceLabel = view.balanceLabel;
    final balance = summary.balanceTotal;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(view.monthlyLabel.toUpperCase(), style: AppTypography.label),
        const SizedBox(height: AppSpacing.xxs),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            CurrencyFormatter.format(summary.monthlyTotal),
            style: AppTypography.monoLarge
                .copyWith(fontSize: AppTypography.heading2Size),
          ),
        ),
        const Spacer(),
        if (balanceLabel != null && balance != null)
          LabeledAmount(
            label: balanceLabel,
            amount: CurrencyFormatter.format(balance),
          ),
        Text(view.countLabel(summary.count), style: AppTypography.bodySmall),
      ],
    );
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton();

  static const double lineHeight = AppSpacing.md;
  static const double valueWidth = 160;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: LoadingSkeleton.defaultLabel,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(height: lineHeight, width: valueWidth),
          SizedBox(height: AppSpacing.xs),
          SkeletonBox(height: AppSpacing.lg, width: valueWidth),
          Spacer(),
          SkeletonBox(height: lineHeight),
        ],
      ),
    );
  }
}

class _Failure extends StatelessWidget {
  const _Failure({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(ExpenseTexts.hubLoadError, style: AppTypography.bodyMedium),
        Text(
          message,
          style: AppTypography.bodySmall.copyWith(color: AppColors.error),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh),
          label: const Text(CrudTexts.retry),
        ),
      ],
    );
  }
}
