import 'package:pennypincher_pro/core/crud/domain/balance_item.dart';
import 'package:pennypincher_pro/core/crud/domain/crud_repository.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/savings_account_entity.dart';

/// The user's savings accounts.
abstract interface class SavingsAccountRepository
    implements CrudRepository<SavingsAccount, BalanceDraft> {}
