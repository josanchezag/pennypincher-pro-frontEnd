import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/core/error/failure_guard.dart';
import 'package:pennypincher_pro/features/expense_details/data/datasource/expense_summary_remote_datasource.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/expense_summary_entity.dart';
import 'package:pennypincher_pro/features/expense_details/domain/repository/expense_summary_repository.dart';

@LazySingleton(as: ExpenseSummaryRepository)
class ExpenseSummaryRepositoryImpl implements ExpenseSummaryRepository {
  ExpenseSummaryRepositoryImpl(this._remote);

  final ExpenseSummaryRemoteDataSource _remote;

  @override
  Future<Either<Failure, ExpenseSummary>> getSummary(ExpenseKind kind) =>
      guardFailures(() => _remote.getSummary(kind));
}
