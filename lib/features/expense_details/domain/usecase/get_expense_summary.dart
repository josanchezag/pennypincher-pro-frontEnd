import 'package:dartz/dartz.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/expense_summary_entity.dart';
import 'package:pennypincher_pro/features/expense_details/domain/repository/expense_summary_repository.dart';

/// Loads the live totals of one expense list.
class GetExpenseSummary {
  const GetExpenseSummary(this._repository);

  final ExpenseSummaryRepository _repository;

  Future<Either<Failure, ExpenseSummary>> call(ExpenseKind kind) =>
      _repository.getSummary(kind);
}
