import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/crud/data/crud_repository_impl.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/features/expense_details/data/datasource/variable_expense_remote_datasource.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/variable_expense_entity.dart';
import 'package:pennypincher_pro/features/expense_details/domain/repository/variable_expense_repository.dart';

@LazySingleton(as: VariableExpenseRepository)
class VariableExpenseRepositoryImpl extends CrudRepositoryImpl<VariableExpense,
        CategorizedDraft<VariableExpenseCategory>>
    implements VariableExpenseRepository {
  VariableExpenseRepositoryImpl(VariableExpenseRemoteDataSource super.remote);
}
