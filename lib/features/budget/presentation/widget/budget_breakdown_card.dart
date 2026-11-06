import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/widgets/money_format_scope.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/monthly_budget_entity.dart';
import 'package:pennypincher_pro/features/budget/presentation/widget/budget_section_card.dart';
import 'package:pennypincher_pro/features/budget/presentation/widget/expense_percentage_row.dart';

/// Share of the income of every budget category against its ideal.
class BudgetBreakdownCard extends StatelessWidget {
  const BudgetBreakdownCard({
    required this.components,
    this.antExpenseTotal = Money.zero,
    super.key,
  });

  static const Key antExpensesKey = Key('budget-ant-expenses');

  final List<BudgetComponent> components;

  /// Part of the monthly expenses that came from ant expenses, shown under
  /// that category.
  final Money antExpenseTotal;

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
          if (component.type == BudgetComponentType.monthlyExpenses)
            _AntExpensesLine(total: antExpenseTotal),
          const SizedBox(height: AppSpacing.md),
        ],
        const _Legend(),
      ],
    );
  }
}

/// `Ant expenses $ 58.500`, the part of the monthly expenses above that
/// came from the ant expenses of the budget's cuts.
class _AntExpensesLine extends StatelessWidget {
  const _AntExpensesLine({required this.total});

  final Money total;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final amount = context.money.format(total);
    return Semantics(
      container: true,
      label: '${l10n.budgetAntExpenses}, $amount, '
          '${l10n.budgetAntExpensesIncluded}',
      child: ExcludeSemantics(
        child: Padding(
          key: BudgetBreakdownCard.antExpensesKey,
          padding: const EdgeInsets.only(
            top: AppSpacing.xs,
            left: AppSpacing.md,
          ),
          child: Row(
            children: [
              const Icon(
                Icons.subdirectory_arrow_right,
                size: AppSpacing.md,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: l10n.budgetAntExpenses,
                        style: AppTypography.bodyMedium,
                      ),
                      TextSpan(
                        text: ' · ${l10n.budgetAntExpensesIncluded}',
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(amount, style: AppTypography.monoSmall),
            ],
          ),
        ),
      ),
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
