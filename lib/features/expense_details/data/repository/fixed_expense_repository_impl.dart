import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/crud/data/crud_repository_impl.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/features/expense_details/data/datasource/fixed_expense_remote_datasource.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/fixed_expense_entity.dart';
import 'package:pennypincher_pro/features/expense_details/domain/repository/fixed_expense_repository.dart';

@LazySingleton(as: FixedExpenseRepository)
class FixedExpenseRepositoryImpl extends CrudRepositoryImpl<FixedExpense,
    CategorizedDraft<FixedExpenseCategory>> implements FixedExpenseRepository {
  FixedExpenseRepositoryImpl(FixedExpenseRemoteDataSource super.remote);
}
