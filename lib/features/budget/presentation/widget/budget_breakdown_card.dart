import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/widgets/money_format_scope.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/monthly_budget_entity.dart';
import 'package:pennypincher_pro/features/budget/presentation/widget/budget_section_card.dart';
import 'package:pennypincher_pro/features/budget/presentation/widget/expense_percentage_row.dart';

/// Share of the income of every budget category against its ideal.
class BudgetBreakdownCard extends StatelessWidget {
  const BudgetBreakdownCard({required this.components, super.key});

  final List<BudgetComponent> components;

  /// Name of a budget category, such as `Credit cards`.
  static String componentLabel(
    AppLocalizations l10n,
    BudgetComponentType type,
  ) =>
      switch (type) {
        BudgetComponentType.creditCards => l10n.budgetComponentCreditCards,
        BudgetComponentType.loans => l10n.budgetComponentLoans,
        BudgetComponentType.monthlyExpenses =>
          l10n.budgetComponentMonthlyExpenses,
        BudgetComponentType.savings => l10n.budgetComponentSavings,
        BudgetComponentType.charity => l10n.budgetComponentCharity,
      };

  @override
  Widget build(BuildContext context) {
    return BudgetSectionCard(
      title: context.l10n.budgetBreakdownTitle,
      children: [
        for (final component in components) ...[
          ExpensePercentageRow(
            label: componentLabel(context.l10n, component.type),
            amount: context.money.format(component.amount),
            percentage: component.percentage,
            idealPercentage: component.idealPercentage,
            direction: component.type.direction,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        const _Legend(),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.budgetLegend(BudgetLimits.targetTolerancePercent),
      style: AppTypography.bodySmall,
    );
  }
}
