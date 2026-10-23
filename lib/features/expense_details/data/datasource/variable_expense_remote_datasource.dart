import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/constants/app_constants.dart';
import 'package:pennypincher_pro/core/crud/data/crud_remote_data_source.dart';
import 'package:pennypincher_pro/core/crud/data/item_json_codec.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/features/expense_details/data/datasource/fixed_expense_remote_datasource.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/variable_expense_entity.dart';

/// JSON shape of a variable expense: `{id, name, monthlyAmount, category}`.
const CategorizedJsonCodec<VariableExpense, VariableExpenseCategory>
    variableExpenseJsonCodec = CategorizedJsonCodec(
  amountKey: ExpenseJsonKeys.monthlyAmount,
  categories: VariableExpenseCategory.values,
  fallbackCategory: VariableExpenseCategory.other,
  build: _variableExpense,
);

VariableExpense _variableExpense(
  String id,
  CategorizedDraft<VariableExpenseCategory> fields,
) =>
    VariableExpense(
      id: id,
      name: fields.name,
      monthlyAmount: fields.amount,
      category: fields.category,
    );

/// `/variable-expenses` endpoints, called with the authenticated client.
@lazySingleton
class VariableExpenseRemoteDataSource extends CrudRemoteDataSource<
    VariableExpense, CategorizedDraft<VariableExpenseCategory>> {
  VariableExpenseRemoteDataSource(super.dio)
      : super(path: ApiPaths.variableExpenses, codec: variableExpenseJsonCodec);
}
