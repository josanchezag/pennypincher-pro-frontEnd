import 'package:dartz/dartz.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/expense_summary_entity.dart';

/// Live totals of the expense lists.
abstract interface class ExpenseSummaryRepository {
  Future<Either<Failure, ExpenseSummary>> getSummary(ExpenseKind kind);
}
