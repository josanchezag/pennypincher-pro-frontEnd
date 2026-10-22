import 'package:dartz/dartz.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/crud/domain/crud_repository.dart';
import 'package:pennypincher_pro/core/error/failure.dart';

/// Loads every item of a list.
class GetItems<T extends CategorizedItem<C>, C extends Enum> {
  const GetItems(this._repository);

  final CrudRepository<T, C> _repository;

  Future<Either<Failure, List<T>>> call() => _repository.getAll();
}

/// Creates an item, or updates the item with [id] when one is given.
class SaveItem<T extends CategorizedItem<C>, C extends Enum> {
  const SaveItem(this._repository);

  final CrudRepository<T, C> _repository;

  Future<Either<Failure, T>> call(ItemDraft<C> draft, {String? id}) =>
      id == null ? _repository.create(draft) : _repository.update(id, draft);
}

/// Removes an item from its list.
class DeleteItem<T extends CategorizedItem<C>, C extends Enum> {
  const DeleteItem(this._repository);

  final CrudRepository<T, C> _repository;

  Future<Either<Failure, Unit>> call(String id) => _repository.delete(id);
}
