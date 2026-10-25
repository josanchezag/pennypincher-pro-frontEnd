import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/widgets/loading_skeleton.dart';
import 'package:pennypincher_pro/core/widgets/month_selector.dart';
import 'package:pennypincher_pro/core/widgets/screen_title_row.dart';
import 'package:pennypincher_pro/core/widgets/status_message.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/monthly_comparison_entity.dart';
import 'package:pennypincher_pro/features/budget/presentation/bloc/budget_comparison_bloc.dart';
import 'package:pennypincher_pro/features/budget/presentation/budget_texts.dart';
import 'package:pennypincher_pro/features/budget/presentation/widget/budget_comparison_cards.dart';
import 'package:pennypincher_pro/features/budget/presentation/widget/budget_comparison_chart.dart';

/// `/budget/comparison`: income, expenses and cash flow of the last months
/// up to the current one, as a chart and a table. Expects a
/// [BudgetComparisonBloc] above it.
class BudgetComparisonScreen extends StatelessWidget {
  const BudgetComparisonScreen({super.key});

  static const Key retryKey = Key('budget-comparison-retry');
  static const Key openBudgetKey = Key('budget-comparison-open-budget');
  static const List<double> skeletonHeights = [
    BudgetComparisonChart.height,
    AppSpacing.xxxl + AppSpacing.lg,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BudgetComparisonBloc, BudgetComparisonState>(
        builder: (context, state) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Header(months: state.months),
            Expanded(child: _body(context, state)),
          ],
        ),
      ),
    );
  }

  static Widget _body(BuildContext context, BudgetComparisonState state) =>
      switch (state.status) {
        ComparisonStatus.loading => const LoadingSkeleton(
            heights: skeletonHeights,
            label: BudgetTexts.comparisonLoadingLabel,
          ),
        ComparisonStatus.failure => SingleChildScrollView(
            child: StatusMessage(
              icon: Icons.cloud_off_outlined,
              title: BudgetTexts.comparisonLoadErrorTitle,
              message: state.error ?? '',
              action: FilledButton.icon(
                key: retryKey,
                onPressed: () => context
                    .read<BudgetComparisonBloc>()
                    .add(const BudgetComparisonLoadRequested()),
                icon: const Icon(Icons.refresh),
                label: const Text(BudgetTexts.retry),
              ),
            ),
          ),
        ComparisonStatus.loaded when !state.hasBudgets =>
          const SingleChildScrollView(child: _NoBudgets()),
        ComparisonStatus.loaded => _Comparison(months: state.months),
      };
}

class _Header extends StatelessWidget {
  const _Header({required this.months});

  final List<MonthComparison> months;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ScreenTitleRow(
            title: AppRoute.budgetComparison.title,
            backTooltip: BudgetTexts.backToBudget,
            parent: AppRoute.budgetOverview.name,
          ),
          if (months.isNotEmpty)
            Text(
              '${BudgetTexts.comparisonSubtitlePrefix} ${months.length} '
              '${BudgetTexts.comparisonSubtitleSuffix} '
              '${MonthSelector.label(months.last.month)}',
              style: AppTypography.bodyMedium,
            ),
        ],
      ),
    );
  }
}

class _NoBudgets extends StatelessWidget {
  const _NoBudgets();

  @override
  Widget build(BuildContext context) {
    return StatusMessage(
      icon: Icons.bar_chart,
      title: BudgetTexts.comparisonEmptyTitle,
      message: BudgetTexts.comparisonEmptyMessage,
      action: FilledButton.icon(
        key: BudgetComparisonScreen.openBudgetKey,
        onPressed: () => context.goNamed(AppRoute.budgetOverview.name),
        icon: const Icon(Icons.pie_chart_outline),
        label: const Text(BudgetTexts.openBudget),
      ),
    );
  }
}

class _Comparison extends StatelessWidget {
  const _Comparison({required this.months});

  final List<MonthComparison> months;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        BudgetComparisonChartCard(months: months),
        const SizedBox(height: AppSpacing.md),
        BudgetComparisonTableCard(months: months),
      ],
    );
  }
}
