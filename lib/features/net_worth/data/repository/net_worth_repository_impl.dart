import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/core/error/failure_guard.dart';
import 'package:pennypincher_pro/features/net_worth/data/datasource/net_worth_remote_datasource.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/net_worth_snapshot_entity.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/net_worth_summary_entity.dart';
import 'package:pennypincher_pro/features/net_worth/domain/repository/net_worth_repository.dart';

@LazySingleton(as: NetWorthRepository)
class NetWorthRepositoryImpl implements NetWorthRepository {
  NetWorthRepositoryImpl(this._remote);

  final NetWorthRemoteDataSource _remote;

  @override
  Future<Either<Failure, List<NetWorthSnapshot>>> getSnapshots() =>
      guardFailures(() async {
        final models = await _remote.getSnapshots();
        return [for (final model in models) model.toEntity()]
          ..sort((a, b) => a.snapshotDate.compareTo(b.snapshotDate));
      });

  @override
  Future<Either<Failure, NetWorthSummary>> getCurrent() =>
      guardFailures(() async => (await _remote.getCurrent()).toEntity());

  @override
  Future<Either<Failure, NetWorthSnapshot>> createSnapshot(DateTime month) =>
      guardFailures(
        () async => (await _remote.createSnapshot(month)).toEntity(),
      );
}
