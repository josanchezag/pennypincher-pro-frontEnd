import 'package:dartz/dartz.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/error/failure.dart';

/// Create, read, update and delete operations of a user-managed list.
abstract interface class CrudRepository<T extends CategorizedItem<C>,
    C extends Enum> {
  /// Every active item of the signed-in user.
  Future<Either<Failure, List<T>>> getAll();

  Future<Either<Failure, T>> create(ItemDraft<C> draft);

  Future<Either<Failure, T>> update(String id, ItemDraft<C> draft);

  /// Removes the item from the list (the backend keeps it as inactive).
  Future<Either<Failure, Unit>> delete(String id);
}
