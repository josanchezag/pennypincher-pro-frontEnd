import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/widgets/chart_legend.dart';
import 'package:pennypincher_pro/core/widgets/report_section_card.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/monthly_comparison_entity.dart';
import 'package:pennypincher_pro/features/budget/presentation/widget/budget_comparison_chart.dart';
import 'package:pennypincher_pro/features/budget/presentation/widget/budget_comparison_table.dart';

/// The comparison chart with its legend.
class BudgetComparisonChartCard extends StatelessWidget {
  const BudgetComparisonChartCard({required this.months, super.key});

  static List<LegendEntry> legend(AppLocalizations l10n) => [
        LegendEntry(
          color: BudgetComparisonChart.incomeColor,
          label: l10n.income,
        ),
        LegendEntry(
          color: BudgetComparisonChart.expensesColor,
          label: l10n.expenses,
        ),
        LegendEntry(
          color: BudgetComparisonChart.cashFlowColor,
          label: l10n.cashFlow,
        ),
        LegendEntry(
          color: BudgetComparisonChart.emptyColor,
          label: l10n.noBudget,
        ),
      ];

  final List<MonthComparison> months;

  @override
  Widget build(BuildContext context) {
    return ReportSectionCard(
      title: context.l10n.budgetComparisonChartTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ChartLegend(entries: legend(context.l10n)),
          const SizedBox(height: AppSpacing.md),
          BudgetComparisonChart(months: months),
        ],
      ),
    );
  }
}

/// The month-by-month table.
class BudgetComparisonTableCard extends StatelessWidget {
  const BudgetComparisonTableCard({required this.months, super.key});

  final List<MonthComparison> months;

  @override
  Widget build(BuildContext context) {
    return ReportSectionCard(
      title: context.l10n.monthByMonth,
      child: BudgetComparisonTable(months: months),
    );
  }
}
