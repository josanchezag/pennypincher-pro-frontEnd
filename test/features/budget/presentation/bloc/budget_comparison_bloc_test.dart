import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/core/time/clock.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/monthly_comparison_entity.dart';
import 'package:pennypincher_pro/features/budget/domain/usecase/monthly_budget_use_cases.dart';
import 'package:pennypincher_pro/features/budget/presentation/bloc/budget_comparison_bloc.dart';

import '../../../../helpers/budget_fixtures.dart';

class _MockGetMonthlyComparison extends Mock implements GetMonthlyComparison {}

class _FixedClock implements Clock {
  const _FixedClock(this.time);

  final DateTime time;

  @override
  DateTime now() => time;
}

const Failure _offline = NetworkFailure('Offline');

void main() {
  late _MockGetMonthlyComparison getComparison;

  setUpAll(() => registerFallbackValue(DateTime(2026)));

  setUp(() => getComparison = _MockGetMonthlyComparison());

  BudgetComparisonBloc buildBloc() => BudgetComparisonBloc(
        getComparison,
        _FixedClock(DateTime(2026, 10, 31, 23, 59)),
      );

  void answer(Either<Failure, List<MonthComparison>> result) =>
      when(() => getComparison(any())).thenAnswer((_) async => result);

  test('opens loading', () {
    expect(buildBloc().state, const BudgetComparisonState());
  });

  blocTest<BudgetComparisonBloc, BudgetComparisonState>(
    'loads the months up to the local month',
    setUp: () => answer(Right(sixMonthComparison)),
    build: buildBloc,
    act: (bloc) => bloc.add(const BudgetComparisonLoadRequested()),
    expect: () => [
      const BudgetComparisonState(),
      BudgetComparisonState(
        status: ComparisonStatus.loaded,
        months: sixMonthComparison,
      ),
    ],
    verify: (bloc) {
      verify(() => getComparison(DateTime(2026, 10))).called(1);
      expect(bloc.state.hasBudgets, isTrue);
    },
  );

  blocTest<BudgetComparisonBloc, BudgetComparisonState>(
    'knows when none of the months has a budget',
    setUp: () => answer(Right([comparisonOf(9), comparisonOf(10)])),
    build: buildBloc,
    act: (bloc) => bloc.add(const BudgetComparisonLoadRequested()),
    skip: 1,
    verify: (bloc) {
      expect(bloc.state.status, ComparisonStatus.loaded);
      expect(bloc.state.hasBudgets, isFalse);
    },
  );

  blocTest<BudgetComparisonBloc, BudgetComparisonState>(
    'shows the error of a failed load and loads again on retry',
    setUp: () => answer(const Left(_offline)),
    build: buildBloc,
    act: (bloc) async {
      bloc.add(const BudgetComparisonLoadRequested());
      await Future<void>.delayed(Duration.zero);
      answer(Right(sixMonthComparison));
      bloc.add(const BudgetComparisonLoadRequested());
    },
    expect: () => [
      const BudgetComparisonState(),
      const BudgetComparisonState(
        status: ComparisonStatus.failure,
        error: 'Offline',
      ),
      const BudgetComparisonState(),
      BudgetComparisonState(
        status: ComparisonStatus.loaded,
        months: sixMonthComparison,
      ),
    ],
  );
}
