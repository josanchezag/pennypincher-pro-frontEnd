import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/time/month_format.dart';
import 'package:pennypincher_pro/core/utils/currency_formatter.dart';
import 'package:pennypincher_pro/core/utils/percent_formatter.dart';
import 'package:pennypincher_pro/core/widgets/report_table.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/monthly_comparison_entity.dart';
import 'package:pennypincher_pro/features/budget/presentation/budget_texts.dart';

/// Figures of every compared month, newest first, with the cash flow
/// share colored by [CashFlowBand] and dashes for months without a budget.
class BudgetComparisonTable extends StatelessWidget {
  const BudgetComparisonTable({required this.months, super.key});

  static const List<String> columns = [
    BudgetTexts.month,
    BudgetTexts.income,
    BudgetTexts.expenses,
    BudgetTexts.cashFlow,
    BudgetTexts.cashFlowPercentShort,
  ];

  /// Oldest first.
  final List<MonthComparison> months;

  @override
  Widget build(BuildContext context) {
    return ReportTable(
      columns: columns,
      rows: [
        for (final month in months.reversed) ReportRow(cells: cellsOf(month)),
      ],
    );
  }

  static List<ReportCell> cellsOf(MonthComparison month) {
    final name = ReportCell(MonthFormat.short.format(month.month));
    final figures = month.figures;
    if (figures == null) {
      return [
        name,
        for (var column = 1; column < columns.length; column++)
          const ReportCell(BudgetTexts.noValue),
      ];
    }
    return [
      name,
      ReportCell(CurrencyFormatter.format(figures.totalIncome)),
      ReportCell(CurrencyFormatter.format(figures.totalExpenses)),
      ReportCell(
        CurrencyFormatter.format(figures.cashFlow),
        color: figures.cashFlow.isNegative ? AppColors.error : null,
      ),
      percentCell(figures.cashFlowPercentage),
    ];
  }

  /// The share colored by its band, or a dash without one.
  static ReportCell percentCell(double? percentage) => percentage == null
      ? const ReportCell(BudgetTexts.noValue)
      : ReportCell(
          PercentFormatter.format(percentage),
          color: colorOf(CashFlowBand.of(percentage)),
        );

  static Color colorOf(CashFlowBand band) => switch (band) {
        CashFlowBand.healthy => AppColors.success,
        CashFlowBand.fair => AppColors.warning,
        CashFlowBand.low => AppColors.error,
      };
}
