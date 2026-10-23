import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/variable_expense_entity.dart';

/// State of the variable expenses screen. A new instance is created per
/// screen.
@injectable
class VariableExpenseBloc extends CrudBloc<VariableExpense,
    CategorizedDraft<VariableExpenseCategory>> {
  VariableExpenseBloc(super.getItems, super.saveItem, super.deleteItem);
}
