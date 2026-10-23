import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/core/error/failure_guard.dart';
import 'package:pennypincher_pro/core/time/calendar_month.dart';
import 'package:pennypincher_pro/features/dashboard/data/datasource/dashboard_remote_datasource.dart';
import 'package:pennypincher_pro/features/dashboard/domain/entity/dashboard_summary_entity.dart';
import 'package:pennypincher_pro/features/dashboard/domain/repository/dashboard_repository.dart';

@LazySingleton(as: DashboardRepository)
class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRepositoryImpl(this._remote);

  final DashboardRemoteDataSource _remote;

  @override
  Future<Either<Failure, DashboardSummary>> getSummary(DateTime month) =>
      guardFailures(() => _remote.getSummary(CalendarMonth.of(month)));

  @override
  Future<Either<Failure, Unit>> recordSnapshot(DateTime month) =>
      guardFailures(() async {
        await _remote.recordSnapshot(CalendarMonth.of(month));
        return unit;
      });
}
