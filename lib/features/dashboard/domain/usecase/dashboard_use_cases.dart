import 'package:dartz/dartz.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/core/time/calendar_month.dart';
import 'package:pennypincher_pro/features/dashboard/domain/entity/dashboard_summary_entity.dart';
import 'package:pennypincher_pro/features/dashboard/domain/repository/dashboard_repository.dart';

/// Loads the dashboard summary of the month of a date.
class GetDashboardSummary {
  const GetDashboardSummary(this._repository);

  final DashboardRepository _repository;

  Future<Either<Failure, DashboardSummary>> call(DateTime date) =>
      _repository.getSummary(CalendarMonth.of(date));
}

/// Saves the net worth snapshot of the month of a date; running it again
/// in the same month recalculates it.
class RecordNetWorthSnapshot {
  const RecordNetWorthSnapshot(this._repository);

  final DashboardRepository _repository;

  Future<Either<Failure, Unit>> call(DateTime date) =>
      _repository.recordSnapshot(CalendarMonth.of(date));
}
