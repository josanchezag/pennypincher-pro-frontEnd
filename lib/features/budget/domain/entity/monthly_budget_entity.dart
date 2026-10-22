import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pennypincher_pro/core/utils/money.dart';

part 'monthly_budget_entity.freezed.dart';

/// Whether a category's ideal share of the income is a ceiling or a floor.
enum TargetDirection {
  /// Spending to keep low, such as credit cards: the ideal is a maximum.
  atMost,

  /// Money to set aside or give, such as savings: the ideal is a minimum.
  atLeast,
}

/// Where the monthly income goes, in the order the budget lists them.
enum BudgetComponentType {
  creditCards(TargetDirection.atMost),
  loans(TargetDirection.atMost),
  monthlyExpenses(TargetDirection.atMost),
  savings(TargetDirection.atLeast),
  charity(TargetDirection.atLeast);

  const BudgetComponentType(this.direction);

  /// How the share is compared with the ideal, when there is one.
  final TargetDirection direction;
}

/// Amount of one [BudgetComponentType] and its share of the income, in
/// percent units (`42.67` is 42.67 %). [idealPercentage] is the target
/// share, when the category has one.
@freezed
class BudgetComponent with _$BudgetComponent {
  const factory BudgetComponent({
    required BudgetComponentType type,
    required Money amount,
    required double percentage,
    double? idealPercentage,
  }) = _BudgetComponent;
}

/// Values of a budget the user enters by hand: the USD/COP exchange rate
/// (TRM) and the work days of the month. Both are optional.
@freezed
class BudgetSettings with _$BudgetSettings {
  const factory BudgetSettings({Money? exchangeRate, int? workDays}) =
      _BudgetSettings;
}

/// The budget of one month, with totals calculated by the backend from the
/// income and expenses at its last calculation.
@freezed
class MonthlyBudget with _$MonthlyBudget {
  const factory MonthlyBudget({
    required String id,

    /// First day of the month the budget belongs to.
    required DateTime month,
    required BudgetSettings settings,
    required Money totalIncome,
    required Money totalExpenses,
    required Money monthlyCashFlow,
    required List<BudgetComponent> components,
  }) = _MonthlyBudget;
}

/// Limits the backend accepts for a budget.
abstract final class BudgetLimits {
  static const int firstYear = 2000;
  static const int lastYear = 2100;
  static const int maxWorkDays = 31;

  /// Distance from the ideal share, in percent of the ideal, that is still
  /// close to target: for an ideal of 20 %, up to 22 % (ceiling) or down
  /// to 18 % (floor).
  static const int targetTolerancePercent = 10;

  static final DateTime firstMonth = DateTime(firstYear);
  static final DateTime lastMonth = DateTime(lastYear, DateTime.december);
}
