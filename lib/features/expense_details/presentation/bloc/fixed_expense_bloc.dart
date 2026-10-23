import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/fixed_expense_entity.dart';

/// State of the fixed expenses screen. A new instance is created per
/// screen.
@injectable
class FixedExpenseBloc
    extends CrudBloc<FixedExpense, CategorizedDraft<FixedExpenseCategory>> {
  FixedExpenseBloc(super.getItems, super.saveItem, super.deleteItem);
}
