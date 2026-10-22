import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/crud/domain/usecase/crud_use_cases.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/core/time/clock.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/income_source_entity.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/monthly_budget_entity.dart';
import 'package:pennypincher_pro/features/budget/domain/usecase/monthly_budget_use_cases.dart';
import 'package:pennypincher_pro/features/budget/presentation/bloc/monthly_budget_bloc.dart';

import '../../../../helpers/budget_fixtures.dart';

class _MockGetBudget extends Mock implements GetMonthlyBudget {}

class _MockCreateBudget extends Mock implements CreateMonthlyBudget {}

class _MockUpdateBudget extends Mock implements UpdateMonthlyBudget {}

class _MockRecalculateBudget extends Mock implements RecalculateBudget {}

class _MockGetIncome extends Mock
    implements GetItems<IncomeSource, IncomeCategory> {}

class _FixedClock implements Clock {
  @override
  DateTime now() => DateTime(2026, 10, 22, 9, 30);
}

const Failure _offline = NetworkFailure('Offline');
const List<IncomeSource> _income = [avenueCode, remoti, arriendoMadera];
final DateTime _october = DateTime(2026, 10);
final DateTime _november = DateTime(2026, 11);
final DateTime _december = DateTime(2026, 12);

void main() {
  late _MockGetBudget getBudget;
  late _MockCreateBudget createBudget;
  late _MockUpdateBudget updateBudget;
  late _MockRecalculateBudget recalculateBudget;
  late _MockGetIncome getIncome;

  setUpAll(() {
    registerFallbackValue(DateTime(2000));
    registerFallbackValue(const BudgetSettings());
  });

  setUp(() {
    getBudget = _MockGetBudget();
    createBudget = _MockCreateBudget();
    updateBudget = _MockUpdateBudget();
    recalculateBudget = _MockRecalculateBudget();
    getIncome = _MockGetIncome();
    when(getIncome.call).thenAnswer((_) async => const Right(_income));
  });

  MonthlyBudgetBloc buildBloc() => MonthlyBudgetBloc(
        getBudget,
        createBudget,
        updateBudget,
        recalculateBudget,
        getIncome,
        _FixedClock(),
      );

  final loaded = MonthlyBudgetState(
    month: _october,
    status: BudgetLoadStatus.loaded,
    budget: octoberBudget,
    incomeSources: _income,
  );
  final empty = MonthlyBudgetState(
    month: _october,
    status: BudgetLoadStatus.loaded,
    incomeSources: _income,
  );

  test('opens on the current month, loading', () {
    expect(buildBloc().state, MonthlyBudgetState(month: _october));
  });

  group('loading', () {
    blocTest<MonthlyBudgetBloc, MonthlyBudgetState>(
      'loads the current month and the income sources',
      setUp: () => when(() => getBudget(_october))
          .thenAnswer((_) async => Right(octoberBudget)),
      build: buildBloc,
      act: (bloc) => bloc.add(const MonthlyBudgetStarted()),
      expect: () => [MonthlyBudgetState(month: _october), loaded],
    );

    blocTest<MonthlyBudgetBloc, MonthlyBudgetState>(
      'shows a month without a budget',
      setUp: () => when(() => getBudget(_october))
          .thenAnswer((_) async => const Right(null)),
      build: buildBloc,
      act: (bloc) => bloc.add(const MonthlyBudgetStarted()),
      expect: () => [MonthlyBudgetState(month: _october), empty],
      verify: (bloc) => expect(bloc.state.canCreate, isTrue),
    );

    blocTest<MonthlyBudgetBloc, MonthlyBudgetState>(
      'reports a failed load and keeps a failure of the income apart',
      setUp: () {
        when(() => getBudget(_october))
            .thenAnswer((_) async => const Left(_offline));
        when(getIncome.call).thenAnswer(
          (_) async => const Left(ServerFailure('Boom', code: 'X')),
        );
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const MonthlyBudgetStarted()),
      expect: () => [
        MonthlyBudgetState(month: _october),
        MonthlyBudgetState(
          month: _october,
          status: BudgetLoadStatus.failure,
          loadError: 'Offline',
          incomeError: 'Boom',
        ),
      ],
    );

    blocTest<MonthlyBudgetBloc, MonthlyBudgetState>(
      'reloads the month shown after a failure',
      setUp: () => when(() => getBudget(_november))
          .thenAnswer((_) async => Right(novemberDeficit)),
      build: buildBloc,
      seed: () => MonthlyBudgetState(
        month: _november,
        status: BudgetLoadStatus.failure,
        loadError: 'Offline',
      ),
      act: (bloc) => bloc.add(const MonthlyBudgetReloadRequested()),
      expect: () => [
        MonthlyBudgetState(month: _november),
        MonthlyBudgetState(
          month: _november,
          status: BudgetLoadStatus.loaded,
          budget: novemberDeficit,
          incomeSources: _income,
        ),
      ],
    );
  });

  group('MonthlyBudgetIncomeReloadRequested', () {
    final failed = loaded.copyWith(
      incomeSources: () => null,
      incomeError: () => 'Offline',
    );

    blocTest<MonthlyBudgetBloc, MonthlyBudgetState>(
      'loads the income sources again after a failure',
      build: buildBloc,
      seed: () => failed,
      act: (bloc) => bloc.add(const MonthlyBudgetIncomeReloadRequested()),
      expect: () => [
        failed.copyWith(incomeError: () => null),
        loaded,
      ],
      verify: (_) => verifyNever(() => getBudget(any())),
    );

    blocTest<MonthlyBudgetBloc, MonthlyBudgetState>(
      'reports a second failure of the income sources',
      setUp: () =>
          when(getIncome.call).thenAnswer((_) async => const Left(_offline)),
      build: buildBloc,
      seed: () => failed,
      act: (bloc) => bloc.add(const MonthlyBudgetIncomeReloadRequested()),
      expect: () => [failed.copyWith(incomeError: () => null), failed],
    );

    blocTest<MonthlyBudgetBloc, MonthlyBudgetState>(
      'does nothing while the income sources are loaded or loading',
      build: buildBloc,
      seed: () => loaded,
      act: (bloc) => bloc.add(const MonthlyBudgetIncomeReloadRequested()),
      expect: () => <MonthlyBudgetState>[],
      verify: (_) => verifyNever(getIncome.call),
    );
  });

  group('MonthlyBudgetMonthChanged', () {
    blocTest<MonthlyBudgetBloc, MonthlyBudgetState>(
      'loads the budget of the chosen month and keeps the income',
      setUp: () => when(() => getBudget(_november))
          .thenAnswer((_) async => Right(novemberDeficit)),
      build: buildBloc,
      seed: () => loaded,
      act: (bloc) => bloc.add(MonthlyBudgetMonthChanged(DateTime(2026, 11, 3))),
      expect: () => [
        MonthlyBudgetState(month: _november, incomeSources: _income),
        MonthlyBudgetState(
          month: _november,
          status: BudgetLoadStatus.loaded,
          budget: novemberDeficit,
          incomeSources: _income,
        ),
      ],
    );

    blocTest<MonthlyBudgetBloc, MonthlyBudgetState>(
      'drops the result of a month the user already left',
      setUp: () {
        final slow = Completer<Either<Failure, MonthlyBudget?>>();
        when(() => getBudget(_november)).thenAnswer((_) => slow.future);
        when(() => getBudget(_december)).thenAnswer((_) async {
          slow.complete(Right(novemberDeficit));
          return const Right(null);
        });
      },
      build: buildBloc,
      seed: () => loaded,
      act: (bloc) => bloc
        ..add(MonthlyBudgetMonthChanged(_november))
        ..add(MonthlyBudgetMonthChanged(_december)),
      wait: const Duration(milliseconds: 10),
      expect: () => [
        MonthlyBudgetState(month: _november, incomeSources: _income),
        MonthlyBudgetState(month: _december, incomeSources: _income),
        MonthlyBudgetState(
          month: _december,
          status: BudgetLoadStatus.loaded,
          incomeSources: _income,
        ),
      ],
    );

    blocTest<MonthlyBudgetBloc, MonthlyBudgetState>(
      'keeps the income sources that arrive after leaving the first month',
      setUp: () {
        final slowIncome = Completer<Either<Failure, List<IncomeSource>>>();
        when(getIncome.call).thenAnswer((_) => slowIncome.future);
        when(() => getBudget(_october))
            .thenAnswer((_) async => Right(octoberBudget));
        when(() => getBudget(_november)).thenAnswer((_) async {
          slowIncome.complete(const Right(_income));
          return Right(novemberDeficit);
        });
      },
      build: buildBloc,
      act: (bloc) => bloc
        ..add(const MonthlyBudgetStarted())
        ..add(MonthlyBudgetMonthChanged(_november)),
      wait: const Duration(milliseconds: 10),
      verify: (bloc) => expect(
        bloc.state,
        MonthlyBudgetState(
          month: _november,
          status: BudgetLoadStatus.loaded,
          budget: novemberDeficit,
          incomeSources: _income,
        ),
      ),
    );

    blocTest<MonthlyBudgetBloc, MonthlyBudgetState>(
      'ignores navigation while a change is running',
      build: buildBloc,
      seed: () => loaded.copyWith(runningAction: () => BudgetAction.update),
      act: (bloc) => bloc.add(MonthlyBudgetMonthChanged(_november)),
      expect: () => <MonthlyBudgetState>[],
    );
  });

  group('MonthlyBudgetCreateRequested', () {
    final creating = empty.copyWith(runningAction: () => BudgetAction.create);

    blocTest<MonthlyBudgetBloc, MonthlyBudgetState>(
      'creates the budget of the month shown',
      setUp: () => when(() => createBudget(_october))
          .thenAnswer((_) async => Right(octoberBudget)),
      build: buildBloc,
      seed: () => empty,
      act: (bloc) => bloc.add(const MonthlyBudgetCreateRequested()),
      expect: () => [
        creating,
        loaded.copyWith(finishedAction: BudgetAction.create),
      ],
    );

    blocTest<MonthlyBudgetBloc, MonthlyBudgetState>(
      'reports a failed create',
      setUp: () => when(() => createBudget(_october))
          .thenAnswer((_) async => const Left(_offline)),
      build: buildBloc,
      seed: () => empty,
      act: (bloc) => bloc.add(const MonthlyBudgetCreateRequested()),
      expect: () => [
        creating,
        empty.copyWith(
          finishedAction: BudgetAction.create,
          actionError: 'Offline',
        ),
      ],
    );

    blocTest<MonthlyBudgetBloc, MonthlyBudgetState>(
      'shows the budget another tab created first',
      setUp: () {
        when(() => createBudget(_october)).thenAnswer(
          (_) async => const Left(ServerFailure('Exists', code: 'CONFLICT')),
        );
        when(() => getBudget(_october))
            .thenAnswer((_) async => Right(octoberBudget));
      },
      build: buildBloc,
      seed: () => empty,
      act: (bloc) => bloc.add(const MonthlyBudgetCreateRequested()),
      expect: () => [
        creating,
        loaded.copyWith(
          finishedAction: BudgetAction.create,
          alreadyExisted: true,
        ),
      ],
    );

    blocTest<MonthlyBudgetBloc, MonthlyBudgetState>(
      'reports the conflict when the existing budget cannot be loaded',
      setUp: () {
        when(() => createBudget(_october)).thenAnswer(
          (_) async => const Left(ServerFailure('Exists', code: 'CONFLICT')),
        );
        when(() => getBudget(_october))
            .thenAnswer((_) async => const Left(_offline));
      },
      build: buildBloc,
      seed: () => empty,
      act: (bloc) => bloc.add(const MonthlyBudgetCreateRequested()),
      expect: () => [
        creating,
        empty.copyWith(
          finishedAction: BudgetAction.create,
          actionError: 'Exists',
        ),
      ],
    );

    blocTest<MonthlyBudgetBloc, MonthlyBudgetState>(
      'does not create over an existing budget or while loading',
      build: buildBloc,
      seed: () => loaded,
      act: (bloc) => bloc
        ..add(const MonthlyBudgetCreateRequested())
        ..add(const MonthlyBudgetCreateRequested()),
      expect: () => <MonthlyBudgetState>[],
      verify: (_) => verifyNever(() => createBudget(any())),
    );
  });

  group('changes to the budget shown', () {
    const settings = BudgetSettings(
      exchangeRate: Money.fromCents(395025),
      workDays: 22,
    );
    final updated = octoberBudget.copyWith(settings: settings);

    blocTest<MonthlyBudgetBloc, MonthlyBudgetState>(
      'saves new settings',
      setUp: () => when(() => updateBudget('b-2026-10', settings))
          .thenAnswer((_) async => Right(updated)),
      build: buildBloc,
      seed: () => loaded,
      act: (bloc) => bloc.add(const MonthlyBudgetSettingsChanged(settings)),
      expect: () => [
        loaded.copyWith(runningAction: () => BudgetAction.update),
        loaded.copyWith(
          budget: () => updated,
          finishedAction: BudgetAction.update,
        ),
      ],
    );

    blocTest<MonthlyBudgetBloc, MonthlyBudgetState>(
      'keeps the budget and reports failed settings',
      setUp: () => when(() => updateBudget('b-2026-10', settings))
          .thenAnswer((_) async => const Left(_offline)),
      build: buildBloc,
      seed: () => loaded,
      act: (bloc) => bloc.add(const MonthlyBudgetSettingsChanged(settings)),
      expect: () => [
        loaded.copyWith(runningAction: () => BudgetAction.update),
        loaded.copyWith(
          finishedAction: BudgetAction.update,
          actionError: 'Offline',
        ),
      ],
    );

    blocTest<MonthlyBudgetBloc, MonthlyBudgetState>(
      'recalculates the budget',
      setUp: () => when(() => recalculateBudget('b-2026-10'))
          .thenAnswer((_) async => Right(updated)),
      build: buildBloc,
      seed: () => loaded,
      act: (bloc) => bloc.add(const MonthlyBudgetRecalculateRequested()),
      expect: () => [
        loaded.copyWith(runningAction: () => BudgetAction.recalculate),
        loaded.copyWith(
          budget: () => updated,
          finishedAction: BudgetAction.recalculate,
        ),
      ],
    );

    blocTest<MonthlyBudgetBloc, MonthlyBudgetState>(
      'reports a failed recalculation',
      setUp: () => when(() => recalculateBudget('b-2026-10'))
          .thenAnswer((_) async => const Left(_offline)),
      build: buildBloc,
      seed: () => loaded,
      act: (bloc) => bloc.add(const MonthlyBudgetRecalculateRequested()),
      expect: () => [
        loaded.copyWith(runningAction: () => BudgetAction.recalculate),
        loaded.copyWith(
          finishedAction: BudgetAction.recalculate,
          actionError: 'Offline',
        ),
      ],
    );

    blocTest<MonthlyBudgetBloc, MonthlyBudgetState>(
      'runs one change at a time and none without a budget',
      setUp: () => when(() => recalculateBudget('b-2026-10'))
          .thenAnswer((_) async => Right(updated)),
      build: buildBloc,
      seed: () => loaded,
      act: (bloc) => bloc
        ..add(const MonthlyBudgetRecalculateRequested())
        ..add(const MonthlyBudgetSettingsChanged(settings)),
      expect: () => [
        loaded.copyWith(runningAction: () => BudgetAction.recalculate),
        loaded.copyWith(
          budget: () => updated,
          finishedAction: BudgetAction.recalculate,
        ),
      ],
      verify: (_) => verifyNever(() => updateBudget(any(), any())),
    );

    blocTest<MonthlyBudgetBloc, MonthlyBudgetState>(
      'ignores changes to a month without a budget',
      build: buildBloc,
      seed: () => empty,
      act: (bloc) => bloc
        ..add(const MonthlyBudgetRecalculateRequested())
        ..add(const MonthlyBudgetSettingsChanged(settings)),
      expect: () => <MonthlyBudgetState>[],
    );
  });
}
