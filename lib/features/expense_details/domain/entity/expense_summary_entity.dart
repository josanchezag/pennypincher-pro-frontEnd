import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pennypincher_pro/core/utils/money.dart';

part 'expense_summary_entity.freezed.dart';

/// The lists of the expenses section, in the order the hub shows them.
enum ExpenseKind {
  creditCards,
  loans,
  fixedExpenses,
  variableExpenses,
  savings
}

/// Live totals of one [ExpenseKind]: the monthly total, the total balance
/// for the kinds that have one, and how many items there are.
@freezed
class ExpenseSummary with _$ExpenseSummary {
  const factory ExpenseSummary({
    required Money monthlyTotal,
    required int count,
    Money? balanceTotal,
  }) = _ExpenseSummary;
}
