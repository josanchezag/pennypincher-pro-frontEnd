import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pennypincher_pro/core/crud/domain/crud_item.dart';
import 'package:pennypincher_pro/core/crud/domain/usecase/crud_use_cases.dart';
import 'package:pennypincher_pro/core/error/failure.dart';

part 'crud_event.dart';
part 'crud_state.dart';

/// Generic state holder of a user-managed list of [T] edited through
/// drafts of type [D] (assets, income sources, credit cards and every
/// other list). Feature blocs only bind it to their use cases. Changes
/// run one at a time: requests that arrive while another change is
/// running are ignored. With [reloadAfterChange], every successful change
/// is followed by a reload of the whole list, for lists whose items carry
/// values the backend derives from the others; the local result is kept
/// when that reload fails. With [createDefaults], the list can be filled
/// with the standard items of its backend.
class CrudBloc<T extends CrudItem, D> extends Bloc<CrudEvent<D>, CrudState<T>> {
  CrudBloc(
    this._getItems,
    this._saveItem,
    this._deleteItem, {
    CreateDefaultItems<T>? createDefaults,
    this.reloadAfterChange = false,
  })  : _createDefaults = createDefaults,
        super(CrudLoading<T>()) {
    on<CrudLoadRequested<D>>(_onLoadRequested);
    on<CrudSaveRequested<D>>(_onSaveRequested);
    on<CrudDeleteRequested<D>>(_onDeleteRequested);
    on<CrudDefaultsRequested<D>>(_onDefaultsRequested);
  }

  final GetItems<T, D> _getItems;
  final SaveItem<T, D> _saveItem;
  final DeleteItem<T, D> _deleteItem;
  final CreateDefaultItems<T>? _createDefaults;
  final bool reloadAfterChange;

  Future<void> _onLoadRequested(
    CrudLoadRequested<D> event,
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
    CrudSaveRequested<D> event,
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
    CrudDeleteRequested<D> event,
    Emitter<CrudState<T>> emit,
  ) =>
      _change(
        emit,
        CrudAction.delete,
        () => _deleteItem(event.id),
        (items, _) => _without(items, event.id),
        whenMissing: (items) => _without(items, event.id),
      );

  Future<void> _onDefaultsRequested(
    CrudDefaultsRequested<D> event,
    Emitter<CrudState<T>> emit,
  ) async {
    final createDefaults = _createDefaults;
    if (createDefaults == null) {
      return;
    }
    await _change(
      emit,
      CrudAction.createDefaults,
      createDefaults.call,
      (_, items) => items,
    );
  }

  static List<T> _without<T extends CrudItem>(
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
      await result.fold(
        (failure) async => CrudLoaded<T>(
          failure is NotFoundFailure && whenMissing != null
              ? whenMissing(current.items)
              : current.items,
          errorMessage: failure.message,
          failedAction: action,
        ),
        (value) async =>
            CrudLoaded<T>(await _refreshed(apply(current.items, value))),
      ),
    );
  }

  /// The list reloaded after a change when [reloadAfterChange], otherwise
  /// (or when the reload fails) [changed], the list with the change
  /// applied locally.
  Future<List<T>> _refreshed(List<T> changed) async {
    if (!reloadAfterChange) {
      return changed;
    }
    final reloaded = await _getItems();
    return reloaded.getOrElse(() => changed);
  }
}
