import 'package:dartz/dartz.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/net_worth_snapshot_entity.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/net_worth_summary_entity.dart';

/// Monthly net worth history and live totals.
abstract interface class NetWorthRepository {
  /// Every snapshot of the user, from the oldest month.
  Future<Either<Failure, List<NetWorthSnapshot>>> getSnapshots();

  /// Totals calculated now from the active assets and liabilities.
  Future<Either<Failure, NetWorthSummary>> getCurrent();

  /// Creates, or recalculates, the snapshot of the month of [month].
  Future<Either<Failure, NetWorthSnapshot>> createSnapshot(DateTime month);
}
