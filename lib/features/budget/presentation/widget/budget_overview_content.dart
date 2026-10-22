import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pennypincher_pro/core/theme/app_breakpoints.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/widgets/confirmation_dialog.dart';
import 'package:pennypincher_pro/core/widgets/month_selector.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/monthly_budget_entity.dart';
import 'package:pennypincher_pro/features/budget/presentation/bloc/monthly_budget_bloc.dart';
import 'package:pennypincher_pro/features/budget/presentation/budget_texts.dart';
import 'package:pennypincher_pro/features/budget/presentation/widget/budget_breakdown_card.dart';
import 'package:pennypincher_pro/features/budget/presentation/widget/budget_details_card.dart';
import 'package:pennypincher_pro/features/budget/presentation/widget/budget_income_card.dart';
import 'package:pennypincher_pro/features/budget/presentation/widget/budget_stat_cards.dart';

/// A month that has a budget: the stat cards, then the category breakdown
/// next to the month details and income sources on desktop screens, or
/// everything stacked on smaller ones.
class BudgetOverviewContent extends StatelessWidget {
  const BudgetOverviewContent({
    required this.budget,
    required this.state,
    super.key,
  });

  final MonthlyBudget budget;
  final MonthlyBudgetState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BudgetStatCards(budget: budget),
        const SizedBox(height: AppSpacing.md),
        _sections(context),
      ],
    );
  }

  /// Two columns on desktop screens, one otherwise.
  Widget _sections(BuildContext context) {
    final breakdown = BudgetBreakdownCard(components: budget.components);
    final side = _side(context);
    final desktop = ScreenSize.fromWidth(MediaQuery.sizeOf(context).width) ==
        ScreenSize.desktop;
    if (desktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: breakdown),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: side),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [breakdown, const SizedBox(height: AppSpacing.md), side],
    );
  }

  Widget _side(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BudgetDetailsCard(
            settings: budget.settings,
            enabled: !state.isBusy,
            onChanged: (settings) => context
                .read<MonthlyBudgetBloc>()
                .add(MonthlyBudgetSettingsChanged(settings)),
          ),
          const SizedBox(height: AppSpacing.md),
          _incomeCard(context),
        ],
      );

  Widget _incomeCard(BuildContext context) => BudgetIncomeCard(
        sources: state.incomeSources,
        error: state.incomeError,
        budgetIncome: budget.totalIncome,
        recalculating: state.runningAction == BudgetAction.recalculate,
        onRecalculate: state.isBusy ? null : () => _recalculate(context),
        onRetry: () => context
            .read<MonthlyBudgetBloc>()
            .add(const MonthlyBudgetIncomeReloadRequested()),
      );

  Future<void> _recalculate(BuildContext context) async {
    final bloc = context.read<MonthlyBudgetBloc>();
    final confirmed = await ConfirmationDialog.show(
      context,
      title: '${BudgetTexts.recalculateTitlePrefix} '
          '${MonthSelector.label(state.month)}?',
      message: BudgetTexts.recalculateMessage,
      confirmLabel: BudgetTexts.recalculate,
    );
    if (confirmed) {
      bloc.add(const MonthlyBudgetRecalculateRequested());
    }
  }
}
