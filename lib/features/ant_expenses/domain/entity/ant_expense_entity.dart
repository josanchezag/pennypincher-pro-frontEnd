import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pennypincher_pro/core/crud/domain/crud_item.dart';
import 'package:pennypincher_pro/core/utils/money.dart';

part 'ant_expense_entity.freezed.dart';

/// Kinds of ant expenses, in the order the backend lists every breakdown.
enum AntExpenseCategory {
  coffeeAndDrinks,
  snacksAndSweets,
  fastFood,
  transport,
  deliveryAndTips,
  appsAndSubscriptions,
  impulsePurchases,
  other,
}

/// A small, frequent purchase, such as a coffee or a tip. While [open] it
/// belongs to the current period; once a budget cut takes it, [budgetId]
/// names that budget and it can no longer change.
@freezed
class AntExpense with _$AntExpense implements CrudItem {
  const factory AntExpense({
    required String id,
    required Money amount,
    required AntExpenseCategory category,

    /// Day of the purchase, as a local date.
    required DateTime spentOn,
    String? description,
    @Default(true) bool open,
    String? budgetId,
    DateTime? createdAt,
  }) = _AntExpense;

  const AntExpense._();

  /// Same limit as the backend, after trimming.
  static const int descriptionMaxLength = 150;

  /// The description, or empty when there is none: the interface names
  /// such an expense by its category.
  @override
  String get name => description ?? '';
}

/// The editable fields of an [AntExpense], sent to create or update it.
final class AntExpenseDraft extends Equatable {
  const AntExpenseDraft({
    required this.amount,
    required this.category,
    required this.spentOn,
    this.description,
  });

  final Money amount;
  final AntExpenseCategory category;

  /// Always sent, as the device's local date.
  final DateTime spentOn;

  /// Trimmed, or `null` when empty.
  final String? description;

  @override
  List<Object?> get props => [amount, category, spentOn, description];
}
