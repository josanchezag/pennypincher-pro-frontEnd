import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pennypincher_pro/core/crud/domain/balance_item.dart';
import 'package:pennypincher_pro/core/utils/money.dart';

part 'savings_account_entity.freezed.dart';

/// A savings account with what the user puts into it each month and its
/// current balance, in pesos.
@freezed
class SavingsAccount with _$SavingsAccount implements BalanceItem {
  const factory SavingsAccount({
    required String id,
    required String name,
    required Money monthlyContribution,
    required Money currentBalance,
  }) = _SavingsAccount;

  const SavingsAccount._();

  @override
  Money get monthlyAmount => monthlyContribution;

  @override
  Money get balance => currentBalance;
}
