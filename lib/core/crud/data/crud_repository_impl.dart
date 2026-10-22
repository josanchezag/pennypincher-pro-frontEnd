import 'package:dartz/dartz.dart';
import 'package:pennypincher_pro/core/crud/data/crud_remote_data_source.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/crud/domain/crud_repository.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/core/error/failure_guard.dart';

/// [CrudRepository] backed by a [CrudRemoteDataSource]; feature
/// repositories only bind it to their resource.
class CrudRepositoryImpl<T extends CategorizedItem<C>, C extends Enum>
    implements CrudRepository<T, C> {
  CrudRepositoryImpl(this._remote);

  final CrudRemoteDataSource<T, C> _remote;

  @override
  Future<Either<Failure, List<T>>> getAll() => guardFailures(_remote.getAll);

  @override
  Future<Either<Failure, T>> create(ItemDraft<C> draft) =>
      guardFailures(() => _remote.create(draft));

  @override
  Future<Either<Failure, T>> update(String id, ItemDraft<C> draft) =>
      guardFailures(() => _remote.update(id, draft));

  @override
  Future<Either<Failure, Unit>> delete(String id) => guardFailures(() async {
        await _remote.delete(id);
        return unit;
      });
}
