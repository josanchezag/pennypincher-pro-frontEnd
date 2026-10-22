import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/crud/data/crud_repository_impl.dart';
import 'package:pennypincher_pro/core/crud/domain/balance_item.dart';
import 'package:pennypincher_pro/features/expense_details/data/datasource/loan_remote_datasource.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/loan_entity.dart';
import 'package:pennypincher_pro/features/expense_details/domain/repository/loan_repository.dart';

@LazySingleton(as: LoanRepository)
class LoanRepositoryImpl extends CrudRepositoryImpl<Loan, BalanceDraft>
    implements LoanRepository {
  LoanRepositoryImpl(LoanRemoteDataSource super.remote);
}
