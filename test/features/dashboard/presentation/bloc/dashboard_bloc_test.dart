import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/core/time/clock.dart';
import 'package:pennypincher_pro/features/dashboard/domain/entity/dashboard_summary_entity.dart';
import 'package:pennypincher_pro/features/dashboard/domain/entity/part_of_day.dart';
import 'package:pennypincher_pro/features/dashboard/domain/usecase/dashboard_use_cases.dart';
import 'package:pennypincher_pro/features/dashboard/presentation/bloc/dashboard_bloc.dart';

import '../../../../helpers/dashboard_fixtures.dart';

class _MockGetDashboardSummary extends Mock implements GetDashboardSummary {}

class _MockRecordNetWorthSnapshot extends Mock
    implements RecordNetWorthSnapshot {}

class _FixedClock implements Clock {
  _FixedClock(this.time);

  DateTime time;

  @override
  DateTime now() => time;
}

const Failure _offline = NetworkFailure('Offline');
final DateTime _morning = DateTime(2026, 10, 22, 9, 30);

void main() {
  late _MockGetDashboardSummary getSummary;
  late _MockRecordNetWorthSnapshot recordSnapshot;
  late _FixedClock clock;
  final updated = dashboardSummary.copyWith(goals: fourGoals);
  final loaded = loadedDashboard(dashboardSummary);

  setUpAll(() => registerFallbackValue(DateTime(2026)));

  setUp(() {
    getSummary = _MockGetDashboardSummary();
    recordSnapshot = _MockRecordNetWorthSnapshot();
    clock = _FixedClock(_morning);
  });

  DashboardBloc buildBloc() => DashboardBloc(getSummary, recordSnapshot, clock);

  void answerSummary(Either<Failure, DashboardSummary> result) =>
      when(() => getSummary(any())).thenAnswer((_) async => result);

  test('starts loading with the greeting of the local hour', () {
    expect(
      buildBloc().state,
      const DashboardState(period: PartOfDay.morning),
    );
  });

  group('greeting', () {
    final hours = {
      const Duration(hours: 5): PartOfDay.morning,
      const Duration(hours: 11, minutes: 59): PartOfDay.morning,
      const Duration(hours: 12): PartOfDay.afternoon,
      const Duration(hours: 17, minutes: 59): PartOfDay.afternoon,
      const Duration(hours: 18): PartOfDay.evening,
      const Duration(hours: 4, minutes: 59): PartOfDay.evening,
    };
    for (final MapEntry(key: time, value: period) in hours.entries) {
      blocTest<DashboardBloc, DashboardState>(
        'greets with ${period.name} at $time of the local clock',
        setUp: () {
          clock.time = DateTime(2026, 10, 22).add(time);
          answerSummary(Right(dashboardSummary));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const DashboardLoadRequested()),
        skip: 1,
        expect: () => [loadedDashboard(dashboardSummary, period: period)],
      );
    }

    blocTest<DashboardBloc, DashboardState>(
      'updates the greeting when it refreshes later in the day',
      setUp: () => answerSummary(Right(dashboardSummary)),
      build: buildBloc,
      seed: () => loaded,
      act: (bloc) {
        clock.time = DateTime(2026, 10, 22, 18, 5);
        bloc.add(const DashboardRefreshRequested());
      },
      expect: () => [
        loadedDashboard(dashboardSummary, refreshing: true),
        loadedDashboard(dashboardSummary, period: PartOfDay.evening),
      ],
    );
  });

  group('DashboardLoadRequested', () {
    blocTest<DashboardBloc, DashboardState>(
      'loads the summary of the local month',
      setUp: () => answerSummary(Right(dashboardSummary)),
      build: buildBloc,
      act: (bloc) => bloc.add(const DashboardLoadRequested()),
      expect: () => [
        const DashboardState(period: PartOfDay.morning),
        loaded,
      ],
      verify: (_) => verify(() => getSummary(_morning)).called(1),
    );

    blocTest<DashboardBloc, DashboardState>(
      'reports a failure that can be retried',
      setUp: () => answerSummary(const Left(_offline)),
      build: buildBloc,
      act: (bloc) => bloc.add(const DashboardLoadRequested()),
      expect: () => [
        const DashboardState(period: PartOfDay.morning),
        const DashboardState(
          period: PartOfDay.morning,
          status: DashboardStatus.failure,
          loadError: 'Offline',
        ),
      ],
    );

    blocTest<DashboardBloc, DashboardState>(
      'starts over after a failure',
      setUp: () => answerSummary(Right(dashboardSummary)),
      build: buildBloc,
      seed: () => const DashboardState(
        period: PartOfDay.morning,
        status: DashboardStatus.failure,
        loadError: 'Offline',
      ),
      act: (bloc) => bloc.add(const DashboardLoadRequested()),
      expect: () => [
        const DashboardState(period: PartOfDay.morning),
        loaded,
      ],
    );
  });

  group('DashboardRefreshRequested', () {
    blocTest<DashboardBloc, DashboardState>(
      'keeps the summary visible while it reloads',
      setUp: () => answerSummary(Right(updated)),
      build: buildBloc,
      seed: () => loaded,
      act: (bloc) => bloc.add(const DashboardRefreshRequested()),
      expect: () => [
        loadedDashboard(dashboardSummary, refreshing: true),
        loadedDashboard(updated),
      ],
    );

    blocTest<DashboardBloc, DashboardState>(
      'keeps the summary and reports a failed refresh',
      setUp: () => answerSummary(const Left(_offline)),
      build: buildBloc,
      seed: () => loaded,
      act: (bloc) => bloc.add(const DashboardRefreshRequested()),
      expect: () => [
        loadedDashboard(dashboardSummary, refreshing: true),
        loadedDashboard(
          dashboardSummary,
          notice: DashboardNotice.refreshFailed,
          noticeMessage: 'Offline',
        ),
      ],
    );

    blocTest<DashboardBloc, DashboardState>(
      'is ignored before the summary is loaded',
      build: buildBloc,
      act: (bloc) => bloc.add(const DashboardRefreshRequested()),
      expect: () => <DashboardState>[],
      verify: (_) => verifyNever(() => getSummary(any())),
    );

    blocTest<DashboardBloc, DashboardState>(
      'is ignored while a snapshot is being saved',
      build: buildBloc,
      seed: () => loadedDashboard(dashboardSummary, recordingSnapshot: true),
      act: (bloc) => bloc.add(const DashboardRefreshRequested()),
      expect: () => <DashboardState>[],
      verify: (_) => verifyNever(() => getSummary(any())),
    );
  });

  group('DashboardSnapshotRequested', () {
    blocTest<DashboardBloc, DashboardState>(
      'saves the local month and reloads the summary',
      setUp: () {
        when(() => recordSnapshot(any()))
            .thenAnswer((_) async => const Right(unit));
        answerSummary(Right(updated));
      },
      build: buildBloc,
      seed: () => loaded,
      act: (bloc) => bloc.add(const DashboardSnapshotRequested()),
      expect: () => [
        loadedDashboard(dashboardSummary, recordingSnapshot: true),
        loadedDashboard(updated, notice: DashboardNotice.snapshotSaved),
      ],
      verify: (_) {
        verify(() => recordSnapshot(_morning)).called(1);
        verify(() => getSummary(_morning)).called(1);
      },
    );

    blocTest<DashboardBloc, DashboardState>(
      'reports a snapshot that could not be saved',
      setUp: () => when(() => recordSnapshot(any()))
          .thenAnswer((_) async => const Left(_offline)),
      build: buildBloc,
      seed: () => loaded,
      act: (bloc) => bloc.add(const DashboardSnapshotRequested()),
      expect: () => [
        loadedDashboard(dashboardSummary, recordingSnapshot: true),
        loadedDashboard(
          dashboardSummary,
          notice: DashboardNotice.snapshotFailed,
          noticeMessage: 'Offline',
        ),
      ],
      verify: (_) => verifyNever(() => getSummary(any())),
    );

    blocTest<DashboardBloc, DashboardState>(
      'keeps the summary when the reload after a saved snapshot fails',
      setUp: () {
        when(() => recordSnapshot(any()))
            .thenAnswer((_) async => const Right(unit));
        answerSummary(const Left(_offline));
      },
      build: buildBloc,
      seed: () => loaded,
      act: (bloc) => bloc.add(const DashboardSnapshotRequested()),
      expect: () => [
        loadedDashboard(dashboardSummary, recordingSnapshot: true),
        loadedDashboard(
          dashboardSummary,
          notice: DashboardNotice.snapshotSaved,
        ),
      ],
    );

    blocTest<DashboardBloc, DashboardState>(
      'is ignored while a refresh runs',
      build: buildBloc,
      seed: () => loadedDashboard(dashboardSummary, refreshing: true),
      act: (bloc) => bloc.add(const DashboardSnapshotRequested()),
      expect: () => <DashboardState>[],
      verify: (_) => verifyNever(() => recordSnapshot(any())),
    );

    blocTest<DashboardBloc, DashboardState>(
      'is ignored before the summary is loaded',
      build: buildBloc,
      act: (bloc) => bloc.add(const DashboardSnapshotRequested()),
      expect: () => <DashboardState>[],
    );
  });
}
