part of 'crud_bloc.dart';

/// Inputs of a [CrudBloc].
sealed class CrudEvent<D> extends Equatable {
  const CrudEvent();

  @override
  List<Object?> get props => const [];
}

/// Load (or reload after an error) every item of the list.
final class CrudLoadRequested<D> extends CrudEvent<D> {
  const CrudLoadRequested();
}

/// Create an item from [draft], or update the item with [id].
final class CrudSaveRequested<D> extends CrudEvent<D> {
  const CrudSaveRequested(this.draft, {this.id});

  final D draft;
  final String? id;

  @override
  List<Object?> get props => [draft, id];
}

/// Delete the item with [id] (already confirmed by the user).
final class CrudDeleteRequested<D> extends CrudEvent<D> {
  const CrudDeleteRequested(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

/// Add the standard items the list is still missing; only handled by blocs
/// built with a `CreateDefaultItems` use case.
final class CrudDefaultsRequested<D> extends CrudEvent<D> {
  const CrudDefaultsRequested();
}
