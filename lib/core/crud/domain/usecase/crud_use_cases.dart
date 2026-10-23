import 'package:dartz/dartz.dart';
import 'package:pennypincher_pro/core/crud/domain/crud_item.dart';
import 'package:pennypincher_pro/core/crud/domain/crud_repository.dart';
import 'package:pennypincher_pro/core/error/failure.dart';

/// Loads every item of a list.
class GetItems<T extends CrudItem, D> {
  const GetItems(this._repository);

  final CrudRepository<T, D> _repository;

  Future<Either<Failure, List<T>>> call() => _repository.getAll();
}

/// Creates an item, or updates the item with [id] when one is given.
class SaveItem<T extends CrudItem, D> {
  const SaveItem(this._repository);

  final CrudRepository<T, D> _repository;

  Future<Either<Failure, T>> call(D draft, {String? id}) =>
      id == null ? _repository.create(draft) : _repository.update(id, draft);
}

/// Removes an item from its list.
class DeleteItem<T extends CrudItem, D> {
  const DeleteItem(this._repository);

  final CrudRepository<T, D> _repository;

  Future<Either<Failure, Unit>> call(String id) => _repository.delete(id);
}
