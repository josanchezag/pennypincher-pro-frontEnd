import 'package:dartz/dartz.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/features/dashboard/domain/entity/dashboard_summary_entity.dart';

/// The dashboard overview of the user.
abstract interface class DashboardRepository {
  /// Summary of the month of [month].
  Future<Either<Failure, DashboardSummary>> getSummary(DateTime month);

  /// Saves (or recalculates) the net worth snapshot of the month of
  /// [month].
  Future<Either<Failure, Unit>> recordSnapshot(DateTime month);
}
