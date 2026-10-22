import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/utils/currency_formatter.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/monthly_budget_entity.dart';
import 'package:pennypincher_pro/features/budget/presentation/budget_texts.dart';
import 'package:pennypincher_pro/features/budget/presentation/widget/budget_section_card.dart';
import 'package:pennypincher_pro/features/budget/presentation/widget/expense_percentage_row.dart';

/// Share of the income of every budget category against its ideal.
class BudgetBreakdownCard extends StatelessWidget {
  const BudgetBreakdownCard({required this.components, super.key});

  final List<BudgetComponent> components;

  @override
  Widget build(BuildContext context) {
    return BudgetSectionCard(
      title: BudgetTexts.breakdownTitle,
      children: [
        for (final component in components) ...[
          ExpensePercentageRow(
            label: BudgetTexts.componentLabels[component.type] ??
                component.type.name,
            amount: CurrencyFormatter.format(component.amount),
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
    return const Text(BudgetTexts.legend, style: AppTypography.bodySmall);
  }
}
