import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/crud/domain/usecase/crud_use_cases.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/asset_entity.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/bloc/asset_bloc.dart';

import '../../../../helpers/net_worth_fixtures.dart';

class _MockGetAssets extends Mock implements GetItems<Asset, AssetCategory> {}

class _MockSaveAsset extends Mock implements SaveItem<Asset, AssetCategory> {}

class _MockDeleteAsset extends Mock
    implements DeleteItem<Asset, AssetCategory> {}

const ItemDraft<AssetCategory> _draft = ItemDraft(
  name: 'Carro Mazda',
  amount: Money.fromPesos(58000000),
  category: AssetCategory.vehicle,
);

const Failure _offline = NetworkFailure('Offline');

void main() {
  late _MockGetAssets getAssets;
  late _MockSaveAsset saveAsset;
  late _MockDeleteAsset deleteAsset;

  setUpAll(() => registerFallbackValue(_draft));

  setUp(() {
    getAssets = _MockGetAssets();
    saveAsset = _MockSaveAsset();
    deleteAsset = _MockDeleteAsset();
  });

  AssetBloc buildBloc() => AssetBloc(getAssets, saveAsset, deleteAsset);

  const loaded = CrudLoaded<Asset>([apartment, car]);
  const busy = CrudLoaded<Asset>([apartment, car], busy: true);

  test('starts loading', () {
    expect(buildBloc().state, const CrudLoading<Asset>());
  });

  group('CrudLoadRequested', () {
    blocTest<AssetBloc, CrudState<Asset>>(
      'emits the loaded assets',
      setUp: () => when(getAssets.call)
          .thenAnswer((_) async => const Right([apartment, car])),
      build: buildBloc,
      act: (bloc) => bloc.add(const CrudLoadRequested()),
      expect: () => [const CrudLoading<Asset>(), loaded],
    );

    blocTest<AssetBloc, CrudState<Asset>>(
      'emits a load failure that can be retried',
      setUp: () =>
          when(getAssets.call).thenAnswer((_) async => const Left(_offline)),
      build: buildBloc,
      act: (bloc) => bloc.add(const CrudLoadRequested()),
      expect: () => [
        const CrudLoading<Asset>(),
        const CrudLoadFailure<Asset>('Offline'),
      ],
    );
  });

  group('CrudSaveRequested', () {
    const updatedCar = Asset(
      id: 'a2',
      name: 'Carro Mazda',
      value: Money.fromPesos(58000000),
      category: AssetCategory.vehicle,
    );

    blocTest<AssetBloc, CrudState<Asset>>(
      'adds a created asset',
      setUp: () => when(() => saveAsset(_draft))
          .thenAnswer((_) async => const Right(wallet)),
      build: buildBloc,
      seed: () => loaded,
      act: (bloc) => bloc.add(const CrudSaveRequested(_draft)),
      expect: () => [
        busy,
        const CrudLoaded<Asset>([apartment, car, wallet]),
      ],
    );

    blocTest<AssetBloc, CrudState<Asset>>(
      'replaces an updated asset in place',
      setUp: () => when(() => saveAsset(_draft, id: 'a2'))
          .thenAnswer((_) async => const Right(updatedCar)),
      build: buildBloc,
      seed: () => loaded,
      act: (bloc) => bloc.add(const CrudSaveRequested(_draft, id: 'a2')),
      expect: () => [
        busy,
        const CrudLoaded<Asset>([apartment, updatedCar]),
      ],
    );

    blocTest<AssetBloc, CrudState<Asset>>(
      'keeps the list and reports a failed save',
      setUp: () => when(() => saveAsset(_draft))
          .thenAnswer((_) async => const Left(_offline)),
      build: buildBloc,
      seed: () => loaded,
      act: (bloc) => bloc.add(const CrudSaveRequested(_draft)),
      expect: () => [
        busy,
        const CrudLoaded<Asset>(
          [apartment, car],
          errorMessage: 'Offline',
          failedAction: CrudAction.save,
        ),
      ],
    );

    blocTest<AssetBloc, CrudState<Asset>>(
      'ignores a save while the list is not loaded or busy',
      build: buildBloc,
      seed: () => busy,
      act: (bloc) => bloc.add(const CrudSaveRequested(_draft)),
      expect: () => <CrudState<Asset>>[],
      verify: (_) => verifyNever(() => saveAsset(any())),
    );
  });

  group('CrudDeleteRequested', () {
    blocTest<AssetBloc, CrudState<Asset>>(
      'removes the deleted asset',
      setUp: () => when(() => deleteAsset('a1'))
          .thenAnswer((_) async => const Right(unit)),
      build: buildBloc,
      seed: () => loaded,
      act: (bloc) => bloc.add(const CrudDeleteRequested('a1')),
      expect: () => [
        busy,
        const CrudLoaded<Asset>([car]),
      ],
    );

    blocTest<AssetBloc, CrudState<Asset>>(
      'keeps the asset and reports a failed delete',
      setUp: () => when(() => deleteAsset('a1'))
          .thenAnswer((_) async => const Left(_offline)),
      build: buildBloc,
      seed: () => loaded,
      act: (bloc) => bloc.add(const CrudDeleteRequested('a1')),
      expect: () => [
        busy,
        const CrudLoaded<Asset>(
          [apartment, car],
          errorMessage: 'Offline',
          failedAction: CrudAction.delete,
        ),
      ],
    );

    blocTest<AssetBloc, CrudState<Asset>>(
      'removes an asset that no longer exists and says so',
      setUp: () => when(() => deleteAsset('a1')).thenAnswer(
        (_) async => const Left(NotFoundFailure('Asset not found')),
      ),
      build: buildBloc,
      seed: () => loaded,
      act: (bloc) => bloc.add(const CrudDeleteRequested('a1')),
      expect: () => [
        busy,
        const CrudLoaded<Asset>(
          [car],
          errorMessage: 'Asset not found',
          failedAction: CrudAction.delete,
        ),
      ],
    );

    blocTest<AssetBloc, CrudState<Asset>>(
      'ignores a delete before the list is loaded',
      build: buildBloc,
      act: (bloc) => bloc.add(const CrudDeleteRequested('a1')),
      expect: () => <CrudState<Asset>>[],
      verify: (_) => verifyNever(() => deleteAsset(any())),
    );
  });
}
