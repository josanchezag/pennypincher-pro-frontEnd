import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/constants/app_constants.dart';
import 'package:pennypincher_pro/core/crud/data/crud_remote_data_source.dart';
import 'package:pennypincher_pro/core/crud/data/item_json_codec.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/fixed_expense_entity.dart';

/// Key of the amount of the fixed and variable expense JSON.
abstract final class ExpenseJsonKeys {
  static const String monthlyAmount = 'monthlyAmount';
}

/// JSON shape of a fixed expense: `{id, name, monthlyAmount, category}`.
const CategorizedJsonCodec<FixedExpense, FixedExpenseCategory>
    fixedExpenseJsonCodec = CategorizedJsonCodec(
  amountKey: ExpenseJsonKeys.monthlyAmount,
  categories: FixedExpenseCategory.values,
  fallbackCategory: FixedExpenseCategory.other,
  build: _fixedExpense,
);

FixedExpense _fixedExpense(
  String id,
  CategorizedDraft<FixedExpenseCategory> fields,
) =>
    FixedExpense(
      id: id,
      name: fields.name,
      monthlyAmount: fields.amount,
      category: fields.category,
    );

/// `/fixed-expenses` endpoints, called with the authenticated client.
@lazySingleton
class FixedExpenseRemoteDataSource extends CrudRemoteDataSource<FixedExpense,
    CategorizedDraft<FixedExpenseCategory>> {
  FixedExpenseRemoteDataSource(super.dio)
      : super(path: ApiPaths.fixedExpenses, codec: fixedExpenseJsonCodec);
}
