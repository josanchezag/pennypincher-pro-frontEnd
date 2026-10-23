import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/theme/app_breakpoints.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/expense_summary_entity.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/bloc/expenses_hub_bloc.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/expense_kinds.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/expense_texts.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/widget/expense_summary_card.dart';

/// `/expenses`: one card per expense list with its live totals, and a
/// reminder that budgets pick up changes when recalculated. Expects an
/// [ExpensesHubBloc] above it.
class ExpensesHubScreen extends StatelessWidget {
  const ExpensesHubScreen({super.key});

  static const Map<ScreenSize, int> columns = {
    ScreenSize.mobile: 1,
    ScreenSize.tablet: 2,
    ScreenSize.desktop: 3,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) => CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(AppSpacing.md),
              sliver: SliverMainAxisGroup(
                slivers: [
                  const SliverToBoxAdapter(child: _Title()),
                  _cards(columns[ScreenSize.fromWidth(constraints.maxWidth)]!),
                  const SliverToBoxAdapter(child: _BudgetHint()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _cards(int columns) =>
      BlocBuilder<ExpensesHubBloc, ExpensesHubState>(
        builder: (context, state) => SliverGrid.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisExtent: ExpenseSummaryCard.extentOf(context),
            mainAxisSpacing: AppSpacing.sm,
            crossAxisSpacing: AppSpacing.md,
          ),
          itemCount: ExpenseKind.values.length,
          itemBuilder: (context, index) {
            final kind = ExpenseKind.values[index];
            return ExpenseSummaryCard(
              view: ExpenseKindView.all[kind]!,
              status: state.statusOf(kind),
              onRetry: () => context
                  .read<ExpensesHubBloc>()
                  .add(ExpenseSummaryRetried(kind)),
            );
          },
        ),
      );
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Semantics(
        header: true,
        child: Text(AppRoute.expenses.title, style: AppTypography.heading1),
      ),
    );
  }
}

class _BudgetHint extends StatelessWidget {
  const _BudgetHint();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: AppColors.textSecondary),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  ExpenseTexts.budgetHint,
                  style: AppTypography.bodyMedium,
                ),
                TextButton(
                  onPressed: () =>
                      context.goNamed(AppRoute.budgetOverview.name),
                  child: const Text(ExpenseTexts.openBudgetOverview),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
