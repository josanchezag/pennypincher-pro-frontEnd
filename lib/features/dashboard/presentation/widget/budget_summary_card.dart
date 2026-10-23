import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/time/month_format.dart';
import 'package:pennypincher_pro/core/utils/currency_formatter.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/utils/percent_formatter.dart';
import 'package:pennypincher_pro/features/dashboard/domain/entity/dashboard_summary_entity.dart';
import 'package:pennypincher_pro/features/dashboard/presentation/dashboard_texts.dart';
import 'package:pennypincher_pro/features/dashboard/presentation/widget/dashboard_action_card.dart';
import 'package:pennypincher_pro/features/dashboard/presentation/widget/dashboard_card.dart';

/// Income, expenses and cash flow of the month's budget (cash flow green
/// when zero or more, red otherwise, with its share of the income), or a
/// card that leads to the budget overview to create it.
class BudgetSummaryCard extends StatelessWidget {
  const BudgetSummaryCard({required this.budget, super.key});

  final MonthBudgetOverview budget;

  static Color cashFlowColor(Money cashFlow) =>
      cashFlow.isNegative ? AppColors.error : AppColors.success;

  @override
  Widget build(BuildContext context) {
    final figures = budget.figures;
    if (figures == null) {
      return DashboardActionCard(
        icon: Icons.add_chart,
        title: DashboardTexts.createBudgetTitle,
        message: '${DashboardTexts.createBudgetMessage} '
            '${MonthFormat.long.format(budget.month)}.',
        route: AppRoute.budgetOverview,
      );
    }
    return DashboardCard(
      icon: Icons.pie_chart_outline,
      title: '${DashboardTexts.budgetTitle}${DashboardTexts.titleSeparator}'
          '${MonthFormat.long.format(budget.month)}',
      children: _rows(figures),
    );
  }

  static List<Widget> _rows(BudgetFigures figures) {
    final cashFlow = figures.monthlyCashFlow;
    return [
      _FigureRow(
        label: DashboardTexts.income,
        amount: figures.totalIncome,
        color: AppColors.success,
      ),
      _FigureRow(
        label: DashboardTexts.expenses,
        amount: figures.totalExpenses,
        color: AppColors.error,
      ),
      const Divider(height: AppSpacing.lg),
      _FigureRow(
        label: DashboardTexts.cashFlow,
        amount: cashFlow,
        color: cashFlowColor(cashFlow),
        detail: '${PercentFormatter.format(figures.cashFlowPercentage)} '
            '${DashboardTexts.ofIncome}',
      ),
    ];
  }
}

class _FigureRow extends StatelessWidget {
  const _FigureRow({
    required this.label,
    required this.amount,
    required this.color,
    this.detail,
  });

  final String label;
  final Money amount;
  final Color color;
  final String? detail;

  @override
  Widget build(BuildContext context) {
    final note = detail;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTypography.bodyLarge)),
          const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    CurrencyFormatter.format(amount),
                    style: AppTypography.monoLarge.copyWith(color: color),
                  ),
                ),
                if (note != null)
                  Text(
                    note,
                    style: AppTypography.monoSmall.copyWith(color: color),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
