import 'package:dartz/dartz.dart';
import 'package:pennypincher_pro/core/crud/domain/crud_item.dart';
import 'package:pennypincher_pro/core/error/failure.dart';

/// Create, read, update and delete operations of a user-managed list of
/// [T], whose editable fields are sent as a [D].
abstract interface class CrudRepository<T extends CrudItem, D> {
  /// Every active item of the signed-in user.
  Future<Either<Failure, List<T>>> getAll();

  Future<Either<Failure, T>> create(D draft);

  Future<Either<Failure, T>> update(String id, D draft);

  /// Removes the item from the list (the backend keeps it as inactive).
  Future<Either<Failure, Unit>> delete(String id);
}
