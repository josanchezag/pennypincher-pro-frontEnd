import 'package:equatable/equatable.dart';
import 'package:pennypincher_pro/core/crud/domain/crud_item.dart';
import 'package:pennypincher_pro/core/utils/money.dart';

/// A [CrudItem] without a category that has a monthly amount and a
/// balance, such as a credit card (monthly payment and outstanding
/// balance) or a savings account (monthly contribution and current
/// balance).
abstract interface class BalanceItem implements CrudItem {
  Money get monthlyAmount;
  Money get balance;
}

/// The editable fields of a [BalanceItem], sent to create or update it.
/// [originalAmount] is the amount a debt started from, for the items that
/// track it (loans); null when it is not tracked.
final class BalanceDraft extends Equatable {
  const BalanceDraft({
    required this.name,
    required this.monthlyAmount,
    required this.balance,
    this.originalAmount,
  });

  final String name;
  final Money monthlyAmount;
  final Money balance;
  final Money? originalAmount;

  @override
  List<Object?> get props => [name, monthlyAmount, balance, originalAmount];
}

/// Share of [originalAmount] already paid off when [balance] is left, from
/// 0 to 1: `1 - balance / originalAmount`, clamped. Null when the original
/// amount is not tracked (null or zero).
double? paidShare({required Money balance, Money? originalAmount}) {
  if (originalAmount == null || originalAmount.cents <= 0) {
    return null;
  }
  return (1 - balance.cents / originalAmount.cents).clamp(0, 1).toDouble();
}
