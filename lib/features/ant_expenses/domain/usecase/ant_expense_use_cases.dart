import 'package:dartz/dartz.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/ant_expenses/domain/entity/ant_expense_entity.dart';
import 'package:pennypincher_pro/features/ant_expenses/domain/entity/ant_expense_report_entity.dart';
import 'package:pennypincher_pro/features/ant_expenses/domain/repository/ant_expense_repository.dart';

/// Loads the totals of the current period.
class GetAntSummary {
  const GetAntSummary(this._repository);

  final AntExpenseRepository _repository;

  Future<Either<Failure, AntSummary>> call() => _repository.getSummary();
}

/// Loads the history of cuts, newest month first.
class GetAntCuts {
  const GetAntCuts(this._repository);

  final AntExpenseRepository _repository;

  Future<Either<Failure, List<AntCut>>> call() => _repository.getCuts();
}

/// Loads the expenses one cut took.
class GetAntCutItems {
  const GetAntCutItems(this._repository);

  final AntExpenseRepository _repository;

  Future<Either<Failure, List<AntExpense>>> call(String budgetId) =>
      _repository.getCutItems(budgetId);
}

/// Loads the spending per month of purchase up to a month.
class GetAntTrend {
  const GetAntTrend(this._repository);

  final AntExpenseRepository _repository;

  Future<Either<Failure, List<AntTrendMonth>>> call(
    DateTime month,
    int months,
  ) =>
      _repository.getTrend(month, months);
}

/// Sets the monthly soft limit, or removes it with `null`.
class SaveAntLimit {
  const SaveAntLimit(this._repository);

  final AntExpenseRepository _repository;

  Future<Either<Failure, Money?>> call(Money? monthlyLimit) =>
      _repository.saveLimit(monthlyLimit);
}
