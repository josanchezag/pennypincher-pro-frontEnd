import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/constants/app_constants.dart';
import 'package:pennypincher_pro/core/crud/data/balance_json_codec.dart';
import 'package:pennypincher_pro/core/crud/data/crud_remote_data_source.dart';
import 'package:pennypincher_pro/core/crud/domain/balance_item.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/savings_account_entity.dart';

/// Keys of the savings account JSON that are specific to savings accounts.
abstract final class SavingsAccountJsonKeys {
  static const String monthlyContribution = 'monthlyContribution';
  static const String currentBalance = 'currentBalance';
}

/// JSON shape of a savings account:
/// `{id, name, monthlyContribution, currentBalance}`.
const BalanceJsonCodec<SavingsAccount> savingsAccountJsonCodec =
    BalanceJsonCodec(
  monthlyKey: SavingsAccountJsonKeys.monthlyContribution,
  balanceKey: SavingsAccountJsonKeys.currentBalance,
  build: _savingsAccount,
);

SavingsAccount _savingsAccount(String id, BalanceDraft fields) =>
    SavingsAccount(
      id: id,
      name: fields.name,
      monthlyContribution: fields.monthlyAmount,
      currentBalance: fields.balance,
    );

/// `/savings-accounts` endpoints, called with the authenticated client.
@lazySingleton
class SavingsAccountRemoteDataSource
    extends CrudRemoteDataSource<SavingsAccount, BalanceDraft> {
  SavingsAccountRemoteDataSource(super.dio)
      : super(path: ApiPaths.savingsAccounts, codec: savingsAccountJsonCodec);
}
