import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/utils/currency_formatter.dart';
import 'package:pennypincher_pro/core/widgets/responsive_card_row.dart';
import 'package:pennypincher_pro/core/widgets/stat_card.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/monthly_budget_entity.dart';
import 'package:pennypincher_pro/features/budget/presentation/budget_texts.dart';

/// Total income, total expenses and cash flow (green when zero or more,
/// red when negative): side by side from tablet up, stacked on mobile.
class BudgetStatCards extends StatelessWidget {
  const BudgetStatCards({required this.budget, super.key});

  final MonthlyBudget budget;

  @override
  Widget build(BuildContext context) {
    final cashFlow = budget.monthlyCashFlow;
    return ResponsiveCardRow(
      children: [
        StatCard(
          label: BudgetTexts.totalIncome,
          value: CurrencyFormatter.format(budget.totalIncome),
          icon: Icons.trending_up,
          valueColor: AppColors.success,
        ),
        StatCard(
          label: BudgetTexts.totalExpenses,
          value: CurrencyFormatter.format(budget.totalExpenses),
          icon: Icons.trending_down,
          valueColor: AppColors.error,
        ),
        StatCard(
          label: BudgetTexts.cashFlow,
          value: CurrencyFormatter.format(cashFlow),
          icon: Icons.account_balance_wallet_outlined,
          valueColor: cashFlow.isNegative ? AppColors.error : AppColors.success,
        ),
      ],
    );
  }
}
