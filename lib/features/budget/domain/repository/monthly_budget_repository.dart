import 'package:dartz/dartz.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/monthly_budget_entity.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/monthly_comparison_entity.dart';

/// The user's monthly budgets.
abstract interface class MonthlyBudgetRepository {
  /// The budget of the month of [month], or `null` when there is none.
  Future<Either<Failure, MonthlyBudget?>> getByMonth(DateTime month);

  /// Creates the budget of the month of [month] from the current income
  /// and expenses.
  Future<Either<Failure, MonthlyBudget>> create(DateTime month);

  /// Replaces the settings of the budget with [id] and recalculates it.
  Future<Either<Failure, MonthlyBudget>> update(
    String id,
    BudgetSettings settings,
  );

  /// Recalculates the budget with [id] from the current income and
  /// expenses.
  Future<Either<Failure, MonthlyBudget>> recalculate(String id);

  /// The [months] months ending at the month of [month], oldest first,
  /// including those without a budget.
  Future<Either<Failure, List<MonthComparison>>> getComparison(
    DateTime month, {
    required int months,
  });
}
