import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/widgets/chart_legend.dart';
import 'package:pennypincher_pro/core/widgets/report_section_card.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/monthly_comparison_entity.dart';
import 'package:pennypincher_pro/features/budget/presentation/budget_texts.dart';
import 'package:pennypincher_pro/features/budget/presentation/widget/budget_comparison_chart.dart';
import 'package:pennypincher_pro/features/budget/presentation/widget/budget_comparison_table.dart';

/// The comparison chart with its legend.
class BudgetComparisonChartCard extends StatelessWidget {
  const BudgetComparisonChartCard({required this.months, super.key});

  static const List<LegendEntry> legend = [
    LegendEntry(
      color: BudgetComparisonChart.incomeColor,
      label: BudgetTexts.income,
    ),
    LegendEntry(
      color: BudgetComparisonChart.expensesColor,
      label: BudgetTexts.expenses,
    ),
    LegendEntry(
      color: BudgetComparisonChart.cashFlowColor,
      label: BudgetTexts.cashFlow,
    ),
    LegendEntry(
      color: BudgetComparisonChart.emptyColor,
      label: BudgetTexts.noBudget,
    ),
  ];

  final List<MonthComparison> months;

  @override
  Widget build(BuildContext context) {
    return ReportSectionCard(
      title: BudgetTexts.comparisonChartTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ChartLegend(entries: legend),
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
      title: BudgetTexts.comparisonTableTitle,
      child: BudgetComparisonTable(months: months),
    );
  }
}
