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
final class BalanceDraft extends Equatable {
  const BalanceDraft({
    required this.name,
    required this.monthlyAmount,
    required this.balance,
  });

  final String name;
  final Money monthlyAmount;
  final Money balance;

  @override
  List<Object?> get props => [name, monthlyAmount, balance];
}
