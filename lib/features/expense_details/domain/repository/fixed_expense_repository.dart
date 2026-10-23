import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/crud/domain/crud_repository.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/fixed_expense_entity.dart';

/// The user's fixed expenses.
abstract interface class FixedExpenseRepository
    implements
        CrudRepository<FixedExpense, CategorizedDraft<FixedExpenseCategory>> {}
