import 'package:dartz/dartz.dart';
import 'package:pennypincher_pro/core/crud/domain/crud_repository.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/ant_expenses/domain/entity/ant_expense_entity.dart';
import 'package:pennypincher_pro/features/ant_expenses/domain/entity/ant_expense_report_entity.dart';

/// The open ant expenses of the current period (the list operations) and
/// the reports around them.
abstract interface class AntExpenseRepository
    implements CrudRepository<AntExpense, AntExpenseDraft> {
  Future<Either<Failure, AntSummary>> getSummary();

  /// Past cuts, newest month first.
  Future<Either<Failure, List<AntCut>>> getCuts();

  /// The expenses the budget [budgetId] took, newest first.
  Future<Either<Failure, List<AntExpense>>> getCutItems(String budgetId);

  /// The [months] months up to [month], oldest first.
  Future<Either<Failure, List<AntTrendMonth>>> getTrend(
    DateTime month,
    int months,
  );

  /// Stores [monthlyLimit], or removes the limit when it is `null`, and
  /// returns the stored value.
  Future<Either<Failure, Money?>> saveLimit(Money? monthlyLimit);
}
