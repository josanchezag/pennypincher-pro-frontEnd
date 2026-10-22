import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/constants/app_constants.dart';
import 'package:pennypincher_pro/core/crud/data/balance_json_codec.dart';
import 'package:pennypincher_pro/core/crud/data/crud_remote_data_source.dart';
import 'package:pennypincher_pro/core/crud/domain/balance_item.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/loan_entity.dart';

/// Keys of the loan JSON amounts.
abstract final class LoanJsonKeys {
  static const String monthlyPayment = 'monthlyPayment';
  static const String totalBalance = 'totalBalance';
  static const String originalAmount = 'originalAmount';
}

/// JSON shape of a loan:
/// `{id, name, monthlyPayment, totalBalance, originalAmount}`, where a null
/// `originalAmount` is not tracked (and clears it on update).
const BalanceJsonCodec<Loan> loanJsonCodec = BalanceJsonCodec(
  monthlyKey: LoanJsonKeys.monthlyPayment,
  balanceKey: LoanJsonKeys.totalBalance,
  originalAmountKey: LoanJsonKeys.originalAmount,
  build: _loan,
);

Loan _loan(String id, BalanceDraft fields) => Loan(
      id: id,
      name: fields.name,
      monthlyPayment: fields.monthlyAmount,
      totalBalance: fields.balance,
      originalAmount: fields.originalAmount,
    );

/// `/loans` endpoints, called with the authenticated client.
@lazySingleton
class LoanRemoteDataSource extends CrudRemoteDataSource<Loan, BalanceDraft> {
  LoanRemoteDataSource(super.dio)
      : super(path: ApiPaths.loans, codec: loanJsonCodec);
}
