import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/crud/domain/usecase/crud_use_cases.dart';
import 'package:pennypincher_pro/core/error/failure.dart';

part 'crud_event.dart';
part 'crud_state.dart';

/// Generic state holder of a user-managed list (assets, liabilities and
/// every later list with the same shape). Feature blocs only bind it to
/// their use cases. Changes run one at a time: requests that arrive while
/// another change is running are ignored.
class CrudBloc<T extends CategorizedItem<C>, C extends Enum>
    extends Bloc<CrudEvent<C>, CrudState<T>> {
  CrudBloc(this._getItems, this._saveItem, this._deleteItem)
      : super(CrudLoading<T>()) {
    on<CrudLoadRequested<C>>(_onLoadRequested);
    on<CrudSaveRequested<C>>(_onSaveRequested);
    on<CrudDeleteRequested<C>>(_onDeleteRequested);
  }

  final GetItems<T, C> _getItems;
  final SaveItem<T, C> _saveItem;
  final DeleteItem<T, C> _deleteItem;

  Future<void> _onLoadRequested(
    CrudLoadRequested<C> event,
    Emitter<CrudState<T>> emit,
  ) async {
    emit(CrudLoading<T>());
    final result = await _getItems();
    emit(
      result.fold(
        (failure) => CrudLoadFailure<T>(failure.message),
        CrudLoaded<T>.new,
      ),
    );
  }

  Future<void> _onSaveRequested(
    CrudSaveRequested<C> event,
    Emitter<CrudState<T>> emit,
  ) =>
      _change(
        emit,
        CrudAction.save,
        () => _saveItem(event.draft, id: event.id),
        (items, saved) => [
          for (final item in items) item.id == saved.id ? saved : item,
          if (items.every((item) => item.id != saved.id)) saved,
        ],
      );

  Future<void> _onDeleteRequested(
    CrudDeleteRequested<C> event,
    Emitter<CrudState<T>> emit,
  ) =>
      _change(
        emit,
        CrudAction.delete,
        () => _deleteItem(event.id),
        (items, _) => _without(items, event.id),
        whenMissing: (items) => _without(items, event.id),
      );

  static List<T> _without<T extends CategorizedItem<Enum>>(
    List<T> items,
    String id,
  ) =>
      items.where((item) => item.id != id).toList();

  /// Runs [request] against the loaded list and applies its result with
  /// [apply], or reports the failure of [action]. The list is kept, except
  /// that [whenMissing] updates it when the item no longer exists.
  Future<void> _change<R>(
    Emitter<CrudState<T>> emit,
    CrudAction action,
    Future<Either<Failure, R>> Function() request,
    List<T> Function(List<T> items, R result) apply, {
    List<T> Function(List<T> items)? whenMissing,
  }) async {
    final current = state;
    if (current is! CrudLoaded<T> || current.busy) {
      return;
    }
    emit(CrudLoaded<T>(current.items, busy: true));
    final result = await request();
    emit(
      result.fold(
        (failure) => CrudLoaded<T>(
          failure is NotFoundFailure && whenMissing != null
              ? whenMissing(current.items)
              : current.items,
          errorMessage: failure.message,
          failedAction: action,
        ),
        (value) => CrudLoaded<T>(apply(current.items, value)),
      ),
    );
  }
}
