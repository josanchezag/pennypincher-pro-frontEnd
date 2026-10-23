import 'package:dartz/dartz.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/net_worth_snapshot_entity.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/net_worth_summary_entity.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/net_worth_trend_entity.dart';
import 'package:pennypincher_pro/features/net_worth/domain/repository/net_worth_repository.dart';

/// Loads the monthly net worth history.
class GetNetWorthSnapshots {
  const GetNetWorthSnapshots(this._repository);

  final NetWorthRepository _repository;

  Future<Either<Failure, List<NetWorthSnapshot>>> call() =>
      _repository.getSnapshots();
}

/// Loads the live net worth totals.
class GetCurrentNetWorth {
  const GetCurrentNetWorth(this._repository);

  final NetWorthRepository _repository;

  Future<Either<Failure, NetWorthSummary>> call() => _repository.getCurrent();
}

/// Saves the net worth of the month of [date]; running it again in the
/// same month recalculates that month's snapshot.
class CreateSnapshot {
  const CreateSnapshot(this._repository);

  final NetWorthRepository _repository;

  Future<Either<Failure, NetWorthSnapshot>> call(DateTime date) =>
      _repository.createSnapshot(NetWorthSnapshot.monthOf(date));
}

/// Loads the monthly net worth report since the month of a date, or the
/// whole history without one.
class GetNetWorthTrend {
  const GetNetWorthTrend(this._repository);

  final NetWorthRepository _repository;

  Future<Either<Failure, NetWorthTrend>> call({DateTime? from}) =>
      _repository.getTrend(
        from: from == null ? null : NetWorthSnapshot.monthOf(from),
      );
}
