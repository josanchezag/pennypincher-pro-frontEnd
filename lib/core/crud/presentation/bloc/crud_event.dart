part of 'crud_bloc.dart';

/// Inputs of a [CrudBloc].
sealed class CrudEvent<C extends Enum> extends Equatable {
  const CrudEvent();

  @override
  List<Object?> get props => const [];
}

/// Load (or reload after an error) every item of the list.
final class CrudLoadRequested<C extends Enum> extends CrudEvent<C> {
  const CrudLoadRequested();
}

/// Create an item from [draft], or update the item with [id].
final class CrudSaveRequested<C extends Enum> extends CrudEvent<C> {
  const CrudSaveRequested(this.draft, {this.id});

  final ItemDraft<C> draft;
  final String? id;

  @override
  List<Object?> get props => [draft, id];
}

/// Delete the item with [id] (already confirmed by the user).
final class CrudDeleteRequested<C extends Enum> extends CrudEvent<C> {
  const CrudDeleteRequested(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}
