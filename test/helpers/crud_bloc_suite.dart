import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/crud/domain/crud_item.dart';
import 'package:pennypincher_pro/core/crud/domain/usecase/crud_use_cases.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/core/error/failure.dart';

class _MockGet<T extends CrudItem, D> extends Mock implements GetItems<T, D> {}

class _MockSave<T extends CrudItem, D> extends Mock implements SaveItem<T, D> {}

class _MockDelete<T extends CrudItem, D> extends Mock
    implements DeleteItem<T, D> {}

const Failure _offline = NetworkFailure('Offline');

/// Behaviour every list bloc inherits from [CrudBloc], checked for the
/// bloc built by [build]: loading, creating, updating and deleting, with
/// their failures. [first] and [second] are the loaded items; [created] is
/// a new item and [updated] is [second] after [draft] is saved.
void crudBlocSuite<T extends CrudItem, D, B extends CrudBloc<T, D>>({
  required B Function(GetItems<T, D>, SaveItem<T, D>, DeleteItem<T, D>) build,
  required T first,
  required T second,
  required T created,
  required T updated,
  required D draft,
}) {
  late _MockGet<T, D> getItems;
  late _MockSave<T, D> saveItem;
  late _MockDelete<T, D> deleteItem;

  setUpAll(() => registerFallbackValue(draft));

  setUp(() {
    getItems = _MockGet();
    saveItem = _MockSave();
    deleteItem = _MockDelete();
  });

  B buildBloc() => build(getItems, saveItem, deleteItem);

  final loaded = CrudLoaded<T>([first, second]);
  final busy = CrudLoaded<T>([first, second], busy: true);

  test('starts loading', () {
    expect(buildBloc().state, CrudLoading<T>());
  });

  blocTest<B, CrudState<T>>(
    'emits the loaded items',
    setUp: () =>
        when(getItems.call).thenAnswer((_) async => Right([first, second])),
    build: buildBloc,
    act: (bloc) => bloc.add(CrudLoadRequested<D>()),
    expect: () => [CrudLoading<T>(), loaded],
  );

  blocTest<B, CrudState<T>>(
    'emits a load failure that can be retried',
    setUp: () =>
        when(getItems.call).thenAnswer((_) async => const Left(_offline)),
    build: buildBloc,
    act: (bloc) => bloc.add(CrudLoadRequested<D>()),
    expect: () => [CrudLoading<T>(), CrudLoadFailure<T>('Offline')],
  );

  blocTest<B, CrudState<T>>(
    'adds a created item',
    setUp: () =>
        when(() => saveItem(draft)).thenAnswer((_) async => Right(created)),
    build: buildBloc,
    seed: () => loaded,
    act: (bloc) => bloc.add(CrudSaveRequested<D>(draft)),
    expect: () => [
      busy,
      CrudLoaded<T>([first, second, created]),
    ],
  );

  blocTest<B, CrudState<T>>(
    'replaces an updated item in place',
    setUp: () => when(() => saveItem(draft, id: second.id))
        .thenAnswer((_) async => Right(updated)),
    build: buildBloc,
    seed: () => loaded,
    act: (bloc) => bloc.add(CrudSaveRequested<D>(draft, id: second.id)),
    expect: () => [
      busy,
      CrudLoaded<T>([first, updated]),
    ],
  );

  blocTest<B, CrudState<T>>(
    'keeps the list and reports a failed save',
    setUp: () => when(() => saveItem(draft))
        .thenAnswer((_) async => const Left(_offline)),
    build: buildBloc,
    seed: () => loaded,
    act: (bloc) => bloc.add(CrudSaveRequested<D>(draft)),
    expect: () => [
      busy,
      CrudLoaded<T>(
        [first, second],
        errorMessage: 'Offline',
        failedAction: CrudAction.save,
      ),
    ],
  );

  blocTest<B, CrudState<T>>(
    'ignores a save while another change is running',
    build: buildBloc,
    seed: () => busy,
    act: (bloc) => bloc.add(CrudSaveRequested<D>(draft)),
    expect: () => <CrudState<T>>[],
    verify: (_) => verifyNever(() => saveItem(any())),
  );

  blocTest<B, CrudState<T>>(
    'removes a deleted item',
    setUp: () => when(() => deleteItem(first.id))
        .thenAnswer((_) async => const Right(unit)),
    build: buildBloc,
    seed: () => loaded,
    act: (bloc) => bloc.add(CrudDeleteRequested<D>(first.id)),
    expect: () => [
      busy,
      CrudLoaded<T>([second]),
    ],
  );

  blocTest<B, CrudState<T>>(
    'keeps the item and reports a failed delete',
    setUp: () => when(() => deleteItem(first.id))
        .thenAnswer((_) async => const Left(_offline)),
    build: buildBloc,
    seed: () => loaded,
    act: (bloc) => bloc.add(CrudDeleteRequested<D>(first.id)),
    expect: () => [
      busy,
      CrudLoaded<T>(
        [first, second],
        errorMessage: 'Offline',
        failedAction: CrudAction.delete,
      ),
    ],
  );

  blocTest<B, CrudState<T>>(
    'removes an item that no longer exists and says so',
    setUp: () => when(() => deleteItem(first.id))
        .thenAnswer((_) async => const Left(NotFoundFailure('Not found'))),
    build: buildBloc,
    seed: () => loaded,
    act: (bloc) => bloc.add(CrudDeleteRequested<D>(first.id)),
    expect: () => [
      busy,
      CrudLoaded<T>(
        [second],
        errorMessage: 'Not found',
        failedAction: CrudAction.delete,
      ),
    ],
  );
}
