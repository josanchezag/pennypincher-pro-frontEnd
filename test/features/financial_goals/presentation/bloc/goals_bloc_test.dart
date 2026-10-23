import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/crud/domain/usecase/crud_use_cases.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/financial_goal_entity.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_level.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/bloc/goals_bloc.dart';

import '../../../../helpers/goal_fixtures.dart';

class _MockGet extends Mock implements GetItems<FinancialGoal, GoalDraft> {}

class _MockSave extends Mock implements SaveItem<FinancialGoal, GoalDraft> {}

class _MockDelete extends Mock
    implements DeleteItem<FinancialGoal, GoalDraft> {}

class _MockDefaults extends Mock implements CreateDefaultItems<FinancialGoal> {}

typedef _State = CrudState<FinancialGoal>;

const Failure _offline = NetworkFailure('Offline');

const GoalDraft _draft = GoalDraft(
  name: 'Seguridad Financiera',
  level: GoalLevel.financialSecurity,
  targetAmount: Money.fromPesos(605000000),
  monthlyInvestment: Money.fromPesos(2000000),
  expectedAnnualReturn: 0.11,
  targetYears: 16,
);

void main() {
  late _MockGet getItems;
  late _MockSave saveItem;
  late _MockDelete deleteItem;
  late _MockDefaults createDefaults;

  setUpAll(() => registerFallbackValue(_draft));

  setUp(() {
    getItems = _MockGet();
    saveItem = _MockSave();
    deleteItem = _MockDelete();
    createDefaults = _MockDefaults();
  });

  GoalsBloc build() =>
      GoalsBloc(getItems, saveItem, deleteItem, createDefaults);

  /// [security] as saved, before its projection is reloaded.
  final saved = security.copyWith(
    monthlyInvestment: const Money.fromPesos(2000000),
    projection: null,
  );
  final reloaded = security.copyWith(
    monthlyInvestment: const Money.fromPesos(2000000),
    projection: security.projection!.copyWith(
      projectedMonthsToGoal: 30,
      projectedAchievementDate: DateTime(2029, 4),
    ),
  );

  test('starts loading and reloads after every change', () {
    final bloc = build();
    addTearDown(bloc.close);

    expect(bloc.state, const CrudLoading<FinancialGoal>());
    expect(bloc.reloadAfterChange, isTrue);
  });

  blocTest<GoalsBloc, _State>(
    'loads the goals with their projections (GoalsLoaded)',
    setUp: () => when(getItems.call).thenAnswer((_) async => Right(excelGoals)),
    build: build,
    act: (bloc) => bloc.add(const CrudLoadRequested()),
    expect: () => [const CrudLoading<FinancialGoal>(), CrudLoaded(excelGoals)],
  );

  blocTest<GoalsBloc, _State>(
    'reports a load that failed so it can be retried',
    setUp: () =>
        when(getItems.call).thenAnswer((_) async => const Left(_offline)),
    build: build,
    act: (bloc) => bloc.add(const CrudLoadRequested()),
    expect: () => [
      const CrudLoading<FinancialGoal>(),
      const CrudLoadFailure<FinancialGoal>('Offline'),
    ],
  );

  blocTest<GoalsBloc, _State>(
    'reloads goals and projections after an update (GoalUpdated)',
    setUp: () {
      when(() => saveItem(_draft, id: 'g1'))
          .thenAnswer((_) async => Right(saved));
      when(getItems.call)
          .thenAnswer((_) async => Right([reloaded, independence]));
    },
    build: build,
    seed: () => CrudLoaded([security, independence]),
    act: (bloc) => bloc.add(const CrudSaveRequested(_draft, id: 'g1')),
    expect: () => [
      CrudLoaded([security, independence], busy: true),
      CrudLoaded([reloaded, independence]),
    ],
  );

  blocTest<GoalsBloc, _State>(
    'reloads in API order after a create (GoalCreated)',
    setUp: () {
      when(() => saveItem(_draft)).thenAnswer((_) async => Right(saved));
      when(getItems.call)
          .thenAnswer((_) async => Right([reloaded, independence]));
    },
    build: build,
    seed: () => CrudLoaded([independence]),
    act: (bloc) => bloc.add(const CrudSaveRequested(_draft)),
    expect: () => [
      CrudLoaded([independence], busy: true),
      CrudLoaded([reloaded, independence]),
    ],
  );

  blocTest<GoalsBloc, _State>(
    'keeps the saved goal when the reload fails',
    setUp: () {
      when(() => saveItem(_draft, id: 'g1'))
          .thenAnswer((_) async => Right(saved));
      when(getItems.call).thenAnswer((_) async => const Left(_offline));
    },
    build: build,
    seed: () => CrudLoaded([security, independence]),
    act: (bloc) => bloc.add(const CrudSaveRequested(_draft, id: 'g1')),
    expect: () => [
      CrudLoaded([security, independence], busy: true),
      CrudLoaded([saved, independence]),
    ],
  );

  blocTest<GoalsBloc, _State>(
    'keeps the goals and reports a failed save without reloading',
    setUp: () => when(() => saveItem(_draft))
        .thenAnswer((_) async => const Left(_offline)),
    build: build,
    seed: () => CrudLoaded([security]),
    act: (bloc) => bloc.add(const CrudSaveRequested(_draft)),
    expect: () => [
      CrudLoaded([security], busy: true),
      CrudLoaded(
        [security],
        errorMessage: 'Offline',
        failedAction: CrudAction.save,
      ),
    ],
    verify: (_) => verifyNever(getItems.call),
  );

  blocTest<GoalsBloc, _State>(
    'reloads after a delete (GoalDeleted)',
    setUp: () {
      when(() => deleteItem('g1')).thenAnswer((_) async => const Right(unit));
      when(getItems.call).thenAnswer((_) async => Right([independence]));
    },
    build: build,
    seed: () => CrudLoaded([security, independence]),
    act: (bloc) => bloc.add(const CrudDeleteRequested('g1')),
    expect: () => [
      CrudLoaded([security, independence], busy: true),
      CrudLoaded([independence]),
    ],
  );

  blocTest<GoalsBloc, _State>(
    'adds the standard goals and reloads their projections',
    setUp: () {
      when(createDefaults.call).thenAnswer(
        (_) async => Right([for (final goal in excelGoals) goal.copyWith()]),
      );
      when(getItems.call).thenAnswer((_) async => Right(excelGoals));
    },
    build: build,
    seed: () => const CrudLoaded([]),
    act: (bloc) => bloc.add(const CrudDefaultsRequested()),
    expect: () => [
      const CrudLoaded<FinancialGoal>([], busy: true),
      CrudLoaded(excelGoals),
    ],
  );

  blocTest<GoalsBloc, _State>(
    'reports standard goals that could not be added',
    setUp: () =>
        when(createDefaults.call).thenAnswer((_) async => const Left(_offline)),
    build: build,
    seed: () => const CrudLoaded([]),
    act: (bloc) => bloc.add(const CrudDefaultsRequested()),
    expect: () => [
      const CrudLoaded<FinancialGoal>([], busy: true),
      const CrudLoaded<FinancialGoal>(
        [],
        errorMessage: 'Offline',
        failedAction: CrudAction.createDefaults,
      ),
    ],
  );

  blocTest<GoalsBloc, _State>(
    'ignores the standard goals while another change is running',
    build: build,
    seed: () => const CrudLoaded([], busy: true),
    act: (bloc) => bloc.add(const CrudDefaultsRequested()),
    expect: () => <_State>[],
    verify: (_) => verifyNever(createDefaults.call),
  );
}
