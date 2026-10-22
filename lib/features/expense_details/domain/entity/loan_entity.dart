import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pennypincher_pro/core/crud/domain/balance_item.dart';
import 'package:pennypincher_pro/core/utils/money.dart';

part 'loan_entity.freezed.dart';

/// A loan with its monthly installment and remaining balance, in pesos.
/// [originalAmount] is the amount borrowed, when the user tracks it.
@freezed
class Loan with _$Loan implements BalanceItem {
  const factory Loan({
    required String id,
    required String name,
    required Money monthlyPayment,
    required Money totalBalance,
    Money? originalAmount,
  }) = _Loan;

  const Loan._();

  @override
  Money get monthlyAmount => monthlyPayment;

  @override
  Money get balance => totalBalance;
}
