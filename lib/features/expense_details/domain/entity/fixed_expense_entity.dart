import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/utils/money.dart';

part 'fixed_expense_entity.freezed.dart';

/// Kinds of fixed expenses, in the order the backend lists them.
enum FixedExpenseCategory {
  food,
  education,
  transport,
  utilities,
  insurance,
  housing,
  health,
  charity,
  communication,
  taxes,
  other,
}

/// A recurring expense with the same amount every month, in pesos.
@freezed
class FixedExpense
    with _$FixedExpense
    implements CategorizedItem<FixedExpenseCategory> {
  const factory FixedExpense({
    required String id,
    required String name,
    required Money monthlyAmount,
    required FixedExpenseCategory category,
  }) = _FixedExpense;

  const FixedExpense._();

  @override
  Money get amount => monthlyAmount;
}
