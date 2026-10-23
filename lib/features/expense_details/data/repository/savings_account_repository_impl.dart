import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/crud/data/crud_repository_impl.dart';
import 'package:pennypincher_pro/core/crud/domain/balance_item.dart';
import 'package:pennypincher_pro/features/expense_details/data/datasource/savings_account_remote_datasource.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/savings_account_entity.dart';
import 'package:pennypincher_pro/features/expense_details/domain/repository/savings_account_repository.dart';

@LazySingleton(as: SavingsAccountRepository)
class SavingsAccountRepositoryImpl
    extends CrudRepositoryImpl<SavingsAccount, BalanceDraft>
    implements SavingsAccountRepository {
  SavingsAccountRepositoryImpl(SavingsAccountRemoteDataSource super.remote);
}
