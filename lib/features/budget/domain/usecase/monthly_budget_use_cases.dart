import 'package:dartz/dartz.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/core/time/calendar_month.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/monthly_budget_entity.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/monthly_comparison_entity.dart';
import 'package:pennypincher_pro/features/budget/domain/repository/monthly_budget_repository.dart';

/// Loads the budget of a month; `null` when the month has none.
class GetMonthlyBudget {
  const GetMonthlyBudget(this._repository);

  final MonthlyBudgetRepository _repository;

  Future<Either<Failure, MonthlyBudget?>> call(DateTime month) =>
      _repository.getByMonth(month);
}

/// Creates the budget of a month.
class CreateMonthlyBudget {
  const CreateMonthlyBudget(this._repository);

  final MonthlyBudgetRepository _repository;

  Future<Either<Failure, MonthlyBudget>> call(DateTime month) =>
      _repository.create(month);
}

/// Changes the exchange rate and work days of a budget.
class UpdateMonthlyBudget {
  const UpdateMonthlyBudget(this._repository);

  final MonthlyBudgetRepository _repository;

  Future<Either<Failure, MonthlyBudget>> call(
    String id,
    BudgetSettings settings,
  ) =>
      _repository.update(id, settings);
}

/// Recalculates a budget from the current income and expenses.
class RecalculateBudget {
  const RecalculateBudget(this._repository);

  final MonthlyBudgetRepository _repository;

  Future<Either<Failure, MonthlyBudget>> call(String id) =>
      _repository.recalculate(id);
}

/// Loads the budget figures of the [defaultMonths] months (or [months])
/// ending at the month of a date.
class GetMonthlyComparison {
  const GetMonthlyComparison(this._repository);

  static const int defaultMonths = 6;

  /// Range of months the API compares.
  static const int minMonths = 1;
  static const int maxMonths = 24;

  final MonthlyBudgetRepository _repository;

  Future<Either<Failure, List<MonthComparison>>> call(
    DateTime month, {
    int months = defaultMonths,
  }) =>
      _repository.getComparison(
        CalendarMonth.of(month),
        months: months.clamp(minMonths, maxMonths),
      );
}
