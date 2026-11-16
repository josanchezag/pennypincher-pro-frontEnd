import 'package:equatable/equatable.dart';
import 'package:pennypincher_pro/core/utils/money.dart';

/// What the target of a goal would yield at the reference rate of
/// return (10 % effective annual): a year and a month of it.
final class ReferenceReturn extends Equatable {
  const ReferenceReturn({
    required this.annualRate,
    required this.annualAmount,
    required this.monthlyAmount,
  });

  /// Fraction of one, such as `0.10`.
  final double annualRate;
  final Money annualAmount;
  final Money monthlyAmount;

  @override
  List<Object?> get props => [annualRate, annualAmount, monthlyAmount];
}
