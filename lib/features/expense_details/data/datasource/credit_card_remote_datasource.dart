import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/constants/app_constants.dart';
import 'package:pennypincher_pro/core/crud/data/balance_json_codec.dart';
import 'package:pennypincher_pro/core/crud/data/crud_remote_data_source.dart';
import 'package:pennypincher_pro/core/crud/domain/balance_item.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/credit_card_entity.dart';

/// Keys of the credit card JSON that are specific to credit cards.
abstract final class CreditCardJsonKeys {
  static const String monthlyPayment = 'monthlyPayment';
  static const String totalBalance = 'totalBalance';
}

/// JSON shape of a credit card: `{id, name, monthlyPayment, totalBalance}`.
const BalanceJsonCodec<CreditCard> creditCardJsonCodec = BalanceJsonCodec(
  monthlyKey: CreditCardJsonKeys.monthlyPayment,
  balanceKey: CreditCardJsonKeys.totalBalance,
  build: _creditCard,
);

CreditCard _creditCard(String id, BalanceDraft fields) => CreditCard(
      id: id,
      name: fields.name,
      monthlyPayment: fields.monthlyAmount,
      totalBalance: fields.balance,
    );

/// `/credit-cards` endpoints, called with the authenticated client.
@lazySingleton
class CreditCardRemoteDataSource
    extends CrudRemoteDataSource<CreditCard, BalanceDraft> {
  CreditCardRemoteDataSource(super.dio)
      : super(path: ApiPaths.creditCards, codec: creditCardJsonCodec);
}
