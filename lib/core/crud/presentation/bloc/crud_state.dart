part of 'crud_bloc.dart';

/// State of a user-managed list.
sealed class CrudState<T> extends Equatable {
  const CrudState();

  @override
  List<Object?> get props => const [];
}

/// The list is being fetched.
final class CrudLoading<T> extends CrudState<T> {
  const CrudLoading();
}

/// The list could not be fetched; it can be retried.
final class CrudLoadFailure<T> extends CrudState<T> {
  const CrudLoadFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Changes a user can make to a list.
enum CrudAction { save, delete, createDefaults }

/// The list is available. While [busy], a create, update or delete is
/// running. [errorMessage] reports the [failedAction] that just failed;
/// the list itself is still valid.
final class CrudLoaded<T> extends CrudState<T> {
  const CrudLoaded(
    this.items, {
    this.busy = false,
    this.errorMessage,
    this.failedAction,
  });

  final List<T> items;
  final bool busy;
  final String? errorMessage;
  final CrudAction? failedAction;

  @override
  List<Object?> get props => [items, busy, errorMessage, failedAction];
}
