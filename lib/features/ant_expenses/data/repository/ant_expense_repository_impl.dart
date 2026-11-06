import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/crud/data/crud_repository_impl.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/core/error/failure_guard.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/ant_expenses/data/datasource/ant_expense_remote_datasource.dart';
import 'package:pennypincher_pro/features/ant_expenses/domain/entity/ant_expense_entity.dart';
import 'package:pennypincher_pro/features/ant_expenses/domain/entity/ant_expense_report_entity.dart';
import 'package:pennypincher_pro/features/ant_expenses/domain/repository/ant_expense_repository.dart';

@LazySingleton(as: AntExpenseRepository)
class AntExpenseRepositoryImpl
    extends CrudRepositoryImpl<AntExpense, AntExpenseDraft>
    implements AntExpenseRepository {
  AntExpenseRepositoryImpl(this._remote) : super(_remote);

  final AntExpenseRemoteDataSource _remote;

  @override
  Future<Either<Failure, AntSummary>> getSummary() =>
      guardFailures(_remote.getSummary);

  @override
  Future<Either<Failure, List<AntCut>>> getCuts() =>
      guardFailures(_remote.getCuts);

  @override
  Future<Either<Failure, List<AntExpense>>> getCutItems(String budgetId) =>
      guardFailures(() => _remote.getCutItems(budgetId));

  @override
  Future<Either<Failure, List<AntTrendMonth>>> getTrend(
    DateTime month,
    int months,
  ) =>
      guardFailures(() => _remote.getTrend(month, months));

  @override
  Future<Either<Failure, Money?>> saveLimit(Money? monthlyLimit) =>
      guardFailures(() => _remote.saveLimit(monthlyLimit));
}
