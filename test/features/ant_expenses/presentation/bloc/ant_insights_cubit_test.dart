import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/core/time/clock.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/ant_expenses/domain/entity/ant_expense_report_entity.dart';
import 'package:pennypincher_pro/features/ant_expenses/domain/usecase/ant_expense_use_cases.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/bloc/ant_insights_cubit.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/bloc/ant_section.dart';

import '../../../../helpers/ant_fixtures.dart';

class _MockGetSummary extends Mock implements GetAntSummary {}

class _MockGetTrend extends Mock implements GetAntTrend {}

class _MockGetCuts extends Mock implements GetAntCuts {}

class _MockSaveLimit extends Mock implements SaveAntLimit {}

class _FixedClock implements Clock {
  @override
  DateTime now() => DateTime(2026, 11, 5, 23, 30);
}

void main() {
  late _MockGetSummary getSummary;
  late _MockGetTrend getTrend;
  late _MockGetCuts getCuts;
  late _MockSaveLimit saveLimit;

  setUpAll(() => registerFallbackValue(DateTime(2026)));

  setUp(() {
    getSummary = _MockGetSummary();
    getTrend = _MockGetTrend();
    getCuts = _MockGetCuts();
    saveLimit = _MockSaveLimit();
    when(() => getSummary()).thenAnswer((_) async => Right(antSummary));
    when(() => getTrend(any(), any())).thenAnswer((_) async => Right(antTrend));
    when(() => getCuts()).thenAnswer((_) async => Right([octoberCut]));
    when(() => saveLimit(any()))
        .thenAnswer((_) async => const Right(Money.fromUnits(90000)));
  });

  AntInsightsCubit buildCubit() =>
      AntInsightsCubit(getSummary, getTrend, getCuts, saveLimit, _FixedClock());

  test('starts loading on the local day of the device', () {
    final state = buildCubit().state;

    expect(state.today, antToday);
    expect(state.summary, isA<AntSectionLoading<AntSummary>>());
    expect(state.trendMonths, 6);
  });

  blocTest<AntInsightsCubit, AntInsightsState>(
    'loads the totals, the trend of the local month and the cuts',
    build: buildCubit,
    act: (cubit) => cubit.load(),
    skip: 2,
    expect: () => [antInsightsLoaded],
    verify: (_) => verify(() => getTrend(DateTime(2026, 11), 6)).called(1),
  );

  blocTest<AntInsightsCubit, AntInsightsState>(
    'keeps the other parts when one fails, and retries only that one',
    setUp: () => when(() => getCuts())
        .thenAnswer((_) async => const Left(NetworkFailure('Offline'))),
    build: buildCubit,
    act: (cubit) async {
      await cubit.load();
      when(() => getCuts()).thenAnswer((_) async => Right([octoberCut]));
      await cubit.retryCuts();
    },
    skip: 2,
    expect: () => [
      antInsightsLoaded.copyWith(cuts: const AntSectionFailure('Offline')),
      antInsightsLoaded.copyWith(cuts: const AntSectionLoading()),
      antInsightsLoaded,
    ],
  );

  blocTest<AntInsightsCubit, AntInsightsState>(
    'retries the totals and the trend on their own',
    build: buildCubit,
    seed: () => antInsightsLoaded.copyWith(
      summary: const AntSectionFailure('Offline'),
      trend: const AntSectionFailure('Offline'),
    ),
    act: (cubit) async {
      await cubit.retrySummary();
      await cubit.retryTrend();
    },
    expect: () => [
      antInsightsLoaded.copyWith(
        summary: const AntSectionLoading(),
        trend: const AntSectionFailure('Offline'),
      ),
      antInsightsLoaded.copyWith(trend: const AntSectionFailure('Offline')),
      antInsightsLoaded.copyWith(trend: const AntSectionLoading()),
      antInsightsLoaded,
    ],
  );

  blocTest<AntInsightsCubit, AntInsightsState>(
    'shows twelve months on request, once',
    build: buildCubit,
    seed: () => antInsightsLoaded,
    act: (cubit) async {
      await cubit.changeTrendMonths(12);
      await cubit.changeTrendMonths(12);
    },
    expect: () => [
      antInsightsLoaded.copyWith(
        trendMonths: 12,
        trend: const AntSectionLoading(),
      ),
      antInsightsLoaded.copyWith(trendMonths: 12),
    ],
    verify: (_) => verify(() => getTrend(DateTime(2026, 11), 12)).called(1),
  );

  blocTest<AntInsightsCubit, AntInsightsState>(
    'refreshes the totals and the trend keeping the figures on screen',
    setUp: () => when(() => getSummary())
        .thenAnswer((_) async => const Right(emptySummary)),
    build: buildCubit,
    seed: () => antInsightsLoaded,
    act: (cubit) => cubit.refreshPeriod(),
    expect: () => [
      antInsightsLoaded.copyWith(summary: const AntSectionLoaded(emptySummary)),
    ],
    verify: (_) => verifyNever(() => getCuts()),
  );

  blocTest<AntInsightsCubit, AntInsightsState>(
    'saves the limit and loads the totals again',
    build: buildCubit,
    seed: () => antInsightsLoaded,
    act: (cubit) => cubit.saveLimit(const Money.fromUnits(90000)),
    expect: () => [
      antInsightsLoaded.copyWith(savingLimit: true),
      antInsightsLoaded,
    ],
    verify: (_) {
      verify(() => saveLimit(const Money.fromUnits(90000))).called(1);
      verify(() => getSummary()).called(1);
    },
  );

  blocTest<AntInsightsCubit, AntInsightsState>(
    'reports a limit that could not be removed',
    setUp: () => when(() => saveLimit(null)).thenAnswer(
      (_) async => const Left(ServerFailure('Rejected', code: 'X')),
    ),
    build: buildCubit,
    seed: () => antInsightsLoaded,
    act: (cubit) => cubit.saveLimit(null),
    expect: () => [
      antInsightsLoaded.copyWith(savingLimit: true),
      antInsightsLoaded.copyWith(limitError: () => 'Rejected'),
    ],
    verify: (_) => verifyNever(() => getSummary()),
  );

  blocTest<AntInsightsCubit, AntInsightsState>(
    'ignores a second limit while one is saving',
    build: buildCubit,
    seed: () => antInsightsLoaded.copyWith(savingLimit: true),
    act: (cubit) => cubit.saveLimit(null),
    expect: () => <AntInsightsState>[],
  );
}
