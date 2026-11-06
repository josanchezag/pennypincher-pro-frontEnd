import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/time/month_format.dart';
import 'package:pennypincher_pro/core/utils/money_formatter.dart';
import 'package:pennypincher_pro/core/utils/percent_formatter.dart';
import 'package:pennypincher_pro/core/widgets/money_format_scope.dart';
import 'package:pennypincher_pro/core/widgets/report_table.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/monthly_comparison_entity.dart';

/// Figures of every compared month, newest first, with the cash flow
/// share colored by [CashFlowBand] and dashes for months without a budget.
class BudgetComparisonTable extends StatelessWidget {
  const BudgetComparisonTable({required this.months, super.key});

  static List<String> columns(AppLocalizations l10n) => [
        l10n.tableMonth,
        l10n.income,
        l10n.expenses,
        l10n.cashFlow,
        l10n.budgetCashFlowPercentShort,
      ];

  /// Number of [columns].
  static const int columnCount = 5;

  /// Oldest first.
  final List<MonthComparison> months;

  @override
  Widget build(BuildContext context) {
    return ReportTable(
      columns: columns(context.l10n),
      rows: [
        for (final month in months.reversed)
          ReportRow(cells: cellsOf(context.money, month)),
      ],
    );
  }

  static List<ReportCell> cellsOf(MoneyFormatter money, MonthComparison month) {
    final name = ReportCell(MonthFormat.short.format(month.month));
    final figures = month.figures;
    if (figures == null) {
      return [
        name,
        for (var column = 1; column < columnCount; column++)
          const ReportCell(ReportTable.noValue),
      ];
    }
    return [
      name,
      ReportCell(money.format(figures.totalIncome)),
      ReportCell(money.format(figures.totalExpenses)),
      ReportCell(
        money.format(figures.cashFlow),
        color: figures.cashFlow.isNegative ? AppColors.error : null,
      ),
      percentCell(figures.cashFlowPercentage),
    ];
  }

  /// The share colored by its band, or a dash without one.
  static ReportCell percentCell(double? percentage) => percentage == null
      ? const ReportCell(ReportTable.noValue)
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
