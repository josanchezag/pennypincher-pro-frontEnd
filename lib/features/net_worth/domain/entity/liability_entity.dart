import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/utils/money.dart';

part 'liability_entity.freezed.dart';

/// Kinds of debts the user owes.
enum LiabilityCategory { creditCard, personalLoan, bankLoan, familyDebt, other }

/// A debt of the user, at its outstanding balance.
@freezed
class Liability with _$Liability implements CategorizedItem<LiabilityCategory> {
  const factory Liability({
    required String id,
    required String name,
    required Money currentBalance,
    required LiabilityCategory category,
  }) = _Liability;

  const Liability._();

  @override
  Money get amount => currentBalance;
}
