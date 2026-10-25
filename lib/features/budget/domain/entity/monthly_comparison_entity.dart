import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pennypincher_pro/core/utils/money.dart';

part 'monthly_comparison_entity.freezed.dart';

/// Stored totals of the budget of a month. [cashFlowPercentage] is the
/// cash flow in percent of the income, `null` when the API sends none.
@freezed
class ComparisonFigures with _$ComparisonFigures {
  const factory ComparisonFigures({
    required Money totalIncome,
    required Money totalExpenses,
    required Money cashFlow,
    double? cashFlowPercentage,
  }) = _ComparisonFigures;
}

/// One month of the budget comparison: its first day and the [figures] of
/// its budget, `null` when the month has no budget.
@freezed
class MonthComparison with _$MonthComparison {
  const factory MonthComparison({
    required DateTime month,
    ComparisonFigures? figures,
  }) = _MonthComparison;

  const MonthComparison._();

  bool get exists => figures != null;
}

/// How healthy a cash flow share of the income is: [healthy] above
/// [CashFlowBand.healthyAbove] %, [low] below [CashFlowBand.lowBelow] %,
/// [fair] from one to the other, both included.
enum CashFlowBand {
  healthy,
  fair,
  low;

  static const double healthyAbove = 30;
  static const double lowBelow = 10;

  static CashFlowBand of(double percentage) => percentage > healthyAbove
      ? healthy
      : percentage >= lowBelow
          ? fair
          : low;
}
