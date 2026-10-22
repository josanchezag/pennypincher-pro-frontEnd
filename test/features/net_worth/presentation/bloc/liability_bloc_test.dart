import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/crud/domain/usecase/crud_use_cases.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/liability_entity.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/bloc/liability_bloc.dart';

import '../../../../helpers/net_worth_fixtures.dart';

class _MockGetLiabilities extends Mock
    implements GetItems<Liability, LiabilityCategory> {}

class _MockSaveLiability extends Mock
    implements SaveItem<Liability, LiabilityCategory> {}

class _MockDeleteLiability extends Mock
    implements DeleteItem<Liability, LiabilityCategory> {}

const ItemDraft<LiabilityCategory> _draft = ItemDraft(
  name: 'Tarjeta Nu Bank',
  amount: Money.fromPesos(2900000),
  category: LiabilityCategory.creditCard,
);

const Liability _paidDown = Liability(
  id: 'l1',
  name: 'Tarjeta Nu Bank',
  currentBalance: Money.fromPesos(2900000),
  category: LiabilityCategory.creditCard,
);

void main() {
  late _MockGetLiabilities getLiabilities;
  late _MockSaveLiability saveLiability;
  late _MockDeleteLiability deleteLiability;

  setUp(() {
    getLiabilities = _MockGetLiabilities();
    saveLiability = _MockSaveLiability();
    deleteLiability = _MockDeleteLiability();
  });

  LiabilityBloc buildBloc() =>
      LiabilityBloc(getLiabilities, saveLiability, deleteLiability);

  const loaded = CrudLoaded<Liability>([nuCard, davivienda]);
  const busy = CrudLoaded<Liability>([nuCard, davivienda], busy: true);

  test('starts loading', () {
    expect(buildBloc().state, const CrudLoading<Liability>());
  });

  blocTest<LiabilityBloc, CrudState<Liability>>(
    'loads the liabilities',
    setUp: () => when(getLiabilities.call)
        .thenAnswer((_) async => const Right([nuCard, davivienda])),
    build: buildBloc,
    act: (bloc) => bloc.add(const CrudLoadRequested()),
    expect: () => [const CrudLoading<Liability>(), loaded],
  );

  blocTest<LiabilityBloc, CrudState<Liability>>(
    'reports a load failure',
    setUp: () => when(getLiabilities.call)
        .thenAnswer((_) async => const Left(UnauthorizedFailure('Expired'))),
    build: buildBloc,
    act: (bloc) => bloc.add(const CrudLoadRequested()),
    expect: () => [
      const CrudLoading<Liability>(),
      const CrudLoadFailure<Liability>('Expired'),
    ],
  );

  blocTest<LiabilityBloc, CrudState<Liability>>(
    'updates the balance of a liability',
    setUp: () => when(() => saveLiability(_draft, id: 'l1'))
        .thenAnswer((_) async => const Right(_paidDown)),
    build: buildBloc,
    seed: () => loaded,
    act: (bloc) => bloc.add(const CrudSaveRequested(_draft, id: 'l1')),
    expect: () => [
      busy,
      const CrudLoaded<Liability>([_paidDown, davivienda]),
    ],
  );

  blocTest<LiabilityBloc, CrudState<Liability>>(
    'removes a deleted liability',
    setUp: () => when(() => deleteLiability('l2'))
        .thenAnswer((_) async => const Right(unit)),
    build: buildBloc,
    seed: () => loaded,
    act: (bloc) => bloc.add(const CrudDeleteRequested('l2')),
    expect: () => [
      busy,
      const CrudLoaded<Liability>([nuCard]),
    ],
  );
}
