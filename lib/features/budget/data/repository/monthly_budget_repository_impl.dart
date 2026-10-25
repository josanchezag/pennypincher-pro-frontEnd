import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/core/error/failure_guard.dart';
import 'package:pennypincher_pro/core/time/calendar_month.dart';
import 'package:pennypincher_pro/features/budget/data/datasource/monthly_budget_remote_datasource.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/monthly_budget_entity.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/monthly_comparison_entity.dart';
import 'package:pennypincher_pro/features/budget/domain/repository/monthly_budget_repository.dart';

@LazySingleton(as: MonthlyBudgetRepository)
class MonthlyBudgetRepositoryImpl implements MonthlyBudgetRepository {
  MonthlyBudgetRepositoryImpl(this._remote);

  final MonthlyBudgetRemoteDataSource _remote;

  @override
  Future<Either<Failure, MonthlyBudget?>> getByMonth(DateTime month) async {
    final result = await guardFailures<MonthlyBudget?>(
      () async =>
          (await _remote.getByMonth(CalendarMonth.of(month))).toEntity(),
    );
    return result.fold(
      (failure) =>
          failure is NotFoundFailure ? const Right(null) : Left(failure),
      Right.new,
    );
  }

  @override
  Future<Either<Failure, MonthlyBudget>> create(DateTime month) =>
      guardFailures(
        () async => (await _remote.create(CalendarMonth.of(month))).toEntity(),
      );

  @override
  Future<Either<Failure, MonthlyBudget>> update(
    String id,
    BudgetSettings settings,
  ) =>
      guardFailures(
        () async => (await _remote.update(id, settings)).toEntity(),
      );

  @override
  Future<Either<Failure, MonthlyBudget>> recalculate(String id) =>
      guardFailures(() async => (await _remote.recalculate(id)).toEntity());

  @override
  Future<Either<Failure, List<MonthComparison>>> getComparison(
    DateTime month, {
    required int months,
  }) =>
      guardFailures(() async {
        final models = await _remote.getComparison(
          CalendarMonth.of(month),
          months: months,
        );
        return [for (final model in models) model.toEntity()]
          ..sort((a, b) => a.month.compareTo(b.month));
      });
}
