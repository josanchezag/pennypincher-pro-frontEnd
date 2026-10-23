import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/utils/money.dart';

part 'variable_expense_entity.freezed.dart';

/// Kinds of variable expenses, in the order the backend lists them.
enum VariableExpenseCategory {
  leisure,
  streaming,
  householdStaff,
  dining,
  clothing,
  gifts,
  other,
}

/// A monthly expense whose amount changes, budgeted as an estimate in
/// pesos.
@freezed
class VariableExpense
    with _$VariableExpense
    implements CategorizedItem<VariableExpenseCategory> {
  const factory VariableExpense({
    required String id,
    required String name,
    required Money monthlyAmount,
    required VariableExpenseCategory category,
  }) = _VariableExpense;

  const VariableExpense._();

  @override
  Money get amount => monthlyAmount;
}
