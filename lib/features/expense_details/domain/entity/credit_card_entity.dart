import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pennypincher_pro/core/crud/domain/balance_item.dart';
import 'package:pennypincher_pro/core/utils/money.dart';

part 'credit_card_entity.freezed.dart';

/// A credit card with what the user pays on it each month and what is
/// still owed on it, in pesos.
@freezed
class CreditCard with _$CreditCard implements BalanceItem {
  const factory CreditCard({
    required String id,
    required String name,
    required Money monthlyPayment,
    required Money totalBalance,
  }) = _CreditCard;

  const CreditCard._();

  @override
  Money get monthlyAmount => monthlyPayment;

  @override
  Money get balance => totalBalance;
}
