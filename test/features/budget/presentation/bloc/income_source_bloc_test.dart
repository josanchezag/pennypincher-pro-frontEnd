import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/crud/domain/usecase/crud_use_cases.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/income_source_entity.dart';
import 'package:pennypincher_pro/features/budget/presentation/bloc/income_source_bloc.dart';

import '../../../../helpers/budget_fixtures.dart';

class _MockGet extends Mock implements GetItems<IncomeSource, IncomeCategory> {}

class _MockSave extends Mock
    implements SaveItem<IncomeSource, IncomeCategory> {}

class _MockDelete extends Mock
    implements DeleteItem<IncomeSource, IncomeCategory> {}

const ItemDraft<IncomeCategory> _draft = ItemDraft(
  name: 'Remoti',
  amount: Money.fromPesos(9500000),
  category: IncomeCategory.employment,
);

const Failure _offline = NetworkFailure('Offline');

void main() {
  late _MockGet getSources;
  late _MockSave saveSource;
  late _MockDelete deleteSource;

  setUpAll(() => registerFallbackValue(_draft));

  setUp(() {
    getSources = _MockGet();
    saveSource = _MockSave();
    deleteSource = _MockDelete();
  });

  IncomeSourceBloc buildBloc() =>
      IncomeSourceBloc(getSources, saveSource, deleteSource);

  const loaded = CrudLoaded<IncomeSource>([avenueCode, remoti]);
  const busy = CrudLoaded<IncomeSource>([avenueCode, remoti], busy: true);

  test('starts loading', () {
    expect(buildBloc().state, const CrudLoading<IncomeSource>());
  });

  group('CrudLoadRequested', () {
    blocTest<IncomeSourceBloc, CrudState<IncomeSource>>(
      'emits the loaded income sources',
      setUp: () => when(getSources.call)
          .thenAnswer((_) async => const Right([avenueCode, remoti])),
      build: buildBloc,
      act: (bloc) => bloc.add(const CrudLoadRequested()),
      expect: () => [const CrudLoading<IncomeSource>(), loaded],
    );

    blocTest<IncomeSourceBloc, CrudState<IncomeSource>>(
      'emits a load failure that can be retried',
      setUp: () =>
          when(getSources.call).thenAnswer((_) async => const Left(_offline)),
      build: buildBloc,
      act: (bloc) => bloc.add(const CrudLoadRequested()),
      expect: () => [
        const CrudLoading<IncomeSource>(),
        const CrudLoadFailure<IncomeSource>('Offline'),
      ],
    );
  });

  group('CrudSaveRequested', () {
    const raised = IncomeSource(
      id: 'i2',
      name: 'Remoti',
      amount: Money.fromPesos(9500000),
      category: IncomeCategory.employment,
    );

    blocTest<IncomeSourceBloc, CrudState<IncomeSource>>(
      'adds a created income source',
      setUp: () => when(() => saveSource(_draft))
          .thenAnswer((_) async => const Right(arriendoMadera)),
      build: buildBloc,
      seed: () => loaded,
      act: (bloc) => bloc.add(const CrudSaveRequested(_draft)),
      expect: () => [
        busy,
        const CrudLoaded<IncomeSource>([avenueCode, remoti, arriendoMadera]),
      ],
    );

    blocTest<IncomeSourceBloc, CrudState<IncomeSource>>(
      'replaces an updated income source in place',
      setUp: () => when(() => saveSource(_draft, id: 'i2'))
          .thenAnswer((_) async => const Right(raised)),
      build: buildBloc,
      seed: () => loaded,
      act: (bloc) => bloc.add(const CrudSaveRequested(_draft, id: 'i2')),
      expect: () => [
        busy,
        const CrudLoaded<IncomeSource>([avenueCode, raised]),
      ],
    );

    blocTest<IncomeSourceBloc, CrudState<IncomeSource>>(
      'keeps the list and reports a failed save',
      setUp: () => when(() => saveSource(_draft))
          .thenAnswer((_) async => const Left(_offline)),
      build: buildBloc,
      seed: () => loaded,
      act: (bloc) => bloc.add(const CrudSaveRequested(_draft)),
      expect: () => [
        busy,
        const CrudLoaded<IncomeSource>(
          [avenueCode, remoti],
          errorMessage: 'Offline',
          failedAction: CrudAction.save,
        ),
      ],
    );

    blocTest<IncomeSourceBloc, CrudState<IncomeSource>>(
      'ignores a save while another change is running',
      build: buildBloc,
      seed: () => busy,
      act: (bloc) => bloc.add(const CrudSaveRequested(_draft)),
      expect: () => <CrudState<IncomeSource>>[],
      verify: (_) => verifyNever(() => saveSource(any())),
    );
  });

  group('CrudDeleteRequested', () {
    blocTest<IncomeSourceBloc, CrudState<IncomeSource>>(
      'removes the deleted income source',
      setUp: () => when(() => deleteSource('i1'))
          .thenAnswer((_) async => const Right(unit)),
      build: buildBloc,
      seed: () => loaded,
      act: (bloc) => bloc.add(const CrudDeleteRequested('i1')),
      expect: () => [
        busy,
        const CrudLoaded<IncomeSource>([remoti]),
      ],
    );

    blocTest<IncomeSourceBloc, CrudState<IncomeSource>>(
      'keeps the income source and reports a failed delete',
      setUp: () => when(() => deleteSource('i1'))
          .thenAnswer((_) async => const Left(_offline)),
      build: buildBloc,
      seed: () => loaded,
      act: (bloc) => bloc.add(const CrudDeleteRequested('i1')),
      expect: () => [
        busy,
        const CrudLoaded<IncomeSource>(
          [avenueCode, remoti],
          errorMessage: 'Offline',
          failedAction: CrudAction.delete,
        ),
      ],
    );

    blocTest<IncomeSourceBloc, CrudState<IncomeSource>>(
      'removes an income source that no longer exists and says so',
      setUp: () => when(() => deleteSource('i1')).thenAnswer(
        (_) async => const Left(NotFoundFailure('Income source not found')),
      ),
      build: buildBloc,
      seed: () => loaded,
      act: (bloc) => bloc.add(const CrudDeleteRequested('i1')),
      expect: () => [
        busy,
        const CrudLoaded<IncomeSource>(
          [remoti],
          errorMessage: 'Income source not found',
          failedAction: CrudAction.delete,
        ),
      ],
    );
  });
}
