import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/crud/domain/crud_repository.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/variable_expense_entity.dart';

/// The user's variable expenses.
abstract interface class VariableExpenseRepository
    implements
        CrudRepository<VariableExpense,
            CategorizedDraft<VariableExpenseCategory>> {}
