import 'package:dartz/dartz.dart';
import 'package:pennypincher_pro/core/crud/data/crud_remote_data_source.dart';
import 'package:pennypincher_pro/core/crud/domain/crud_item.dart';
import 'package:pennypincher_pro/core/crud/domain/crud_repository.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/core/error/failure_guard.dart';

/// [CrudRepository] backed by a [CrudRemoteDataSource]; feature
/// repositories only bind it to their resource.
class CrudRepositoryImpl<T extends CrudItem, D>
    implements CrudRepository<T, D> {
  CrudRepositoryImpl(this._remote);

  final CrudRemoteDataSource<T, D> _remote;

  @override
  Future<Either<Failure, List<T>>> getAll() => guardFailures(_remote.getAll);

  @override
  Future<Either<Failure, T>> create(D draft) =>
      guardFailures(() => _remote.create(draft));

  @override
  Future<Either<Failure, T>> update(String id, D draft) =>
      guardFailures(() => _remote.update(id, draft));

  @override
  Future<Either<Failure, Unit>> delete(String id) => guardFailures(() async {
        await _remote.delete(id);
        return unit;
      });
}
