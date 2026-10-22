import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/core/time/clock.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/net_worth_snapshot_entity.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/net_worth_summary_entity.dart';
import 'package:pennypincher_pro/features/net_worth/domain/usecase/net_worth_use_cases.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/bloc/net_worth_bloc.dart';

import '../../../../helpers/net_worth_fixtures.dart';

class _MockGetCurrentNetWorth extends Mock implements GetCurrentNetWorth {}

class _MockGetNetWorthSnapshots extends Mock implements GetNetWorthSnapshots {}

class _MockCreateSnapshot extends Mock implements CreateSnapshot {}

class _FixedClock implements Clock {
  @override
  DateTime now() => DateTime(2026, 10, 22, 9, 30);
}

const Failure _offline = NetworkFailure('Offline');

void main() {
  late _MockGetCurrentNetWorth getCurrent;
  late _MockGetNetWorthSnapshots getSnapshots;
  late _MockCreateSnapshot createSnapshot;
  final october = snapshotOf(2026, 10, 173000000);
  final loaded = NetWorthLoaded(
    current: currentSummary,
    history: [august, september],
    month: DateTime(2026, 10),
  );

  setUpAll(() => registerFallbackValue(DateTime(2026)));

  setUp(() {
    getCurrent = _MockGetCurrentNetWorth();
    getSnapshots = _MockGetNetWorthSnapshots();
    createSnapshot = _MockCreateSnapshot();
  });

  NetWorthBloc buildBloc() =>
      NetWorthBloc(getCurrent, getSnapshots, createSnapshot, _FixedClock());

  void answerLoad({
    Either<Failure, NetWorthSummary> current = const Right(currentSummary),
    Either<Failure, List<NetWorthSnapshot>>? history,
  }) {
    when(getCurrent.call).thenAnswer((_) async => current);
    when(getSnapshots.call)
        .thenAnswer((_) async => history ?? Right([august, september]));
  }

  test('starts loading', () {
    expect(buildBloc().state, const NetWorthLoading());
  });

  group('NetWorthLoadRequested', () {
    blocTest<NetWorthBloc, NetWorthState>(
      'loads the live totals, the history and the current month',
      setUp: answerLoad,
      build: buildBloc,
      act: (bloc) => bloc.add(const NetWorthLoadRequested()),
      expect: () => [const NetWorthLoading(), loaded],
      verify: (_) {
        verify(getCurrent.call).called(1);
        verify(getSnapshots.call).called(1);
      },
    );

    blocTest<NetWorthBloc, NetWorthState>(
      'reports a failure of the live totals',
      setUp: () => answerLoad(current: const Left(_offline)),
      build: buildBloc,
      act: (bloc) => bloc.add(const NetWorthLoadRequested()),
      expect: () => [
        const NetWorthLoading(),
        const NetWorthLoadFailure('Offline'),
      ],
    );

    blocTest<NetWorthBloc, NetWorthState>(
      'reports a failure of the history',
      setUp: () => answerLoad(
        history: const Left(UnauthorizedFailure('Expired')),
      ),
      build: buildBloc,
      act: (bloc) => bloc.add(const NetWorthLoadRequested()),
      expect: () => [
        const NetWorthLoading(),
        const NetWorthLoadFailure('Expired'),
      ],
    );
  });

  group('NetWorthLoaded', () {
    test('measures the change against the previous month', () {
      expect(loaded.baseline, september);
      expect(loaded.change, const Money.fromPesos(2450000));
    });

    test('has no change without an earlier snapshot', () {
      final first = NetWorthLoaded(
        current: currentSummary,
        history: [october],
        month: DateTime(2026, 10),
      );

      expect(first.baseline, isNull);
      expect(first.change, isNull);
    });
  });

  group('NetWorthSnapshotRequested', () {
    blocTest<NetWorthBloc, NetWorthState>(
      'saves the current month and adds it to the history',
      setUp: () => when(() => createSnapshot(any()))
          .thenAnswer((_) async => Right(october)),
      build: buildBloc,
      seed: () => loaded,
      act: (bloc) => bloc.add(const NetWorthSnapshotRequested()),
      expect: () => [
        loaded.copyWith(creatingSnapshot: true),
        loaded.copyWith(history: [august, september, october]),
      ],
      verify: (_) => verify(
        () => createSnapshot(DateTime(2026, 10, 22, 9, 30)),
      ).called(1),
    );

    blocTest<NetWorthBloc, NetWorthState>(
      'keeps the history and reports a failed snapshot',
      setUp: () => when(() => createSnapshot(any()))
          .thenAnswer((_) async => const Left(_offline)),
      build: buildBloc,
      seed: () => loaded,
      act: (bloc) => bloc.add(const NetWorthSnapshotRequested()),
      expect: () => [
        loaded.copyWith(creatingSnapshot: true),
        loaded.copyWith(errorMessage: 'Offline'),
      ],
    );

    blocTest<NetWorthBloc, NetWorthState>(
      'ignores a request while another snapshot is being saved',
      build: buildBloc,
      seed: () => loaded.copyWith(creatingSnapshot: true),
      act: (bloc) => bloc.add(const NetWorthSnapshotRequested()),
      expect: () => <NetWorthState>[],
      verify: (_) => verifyNever(() => createSnapshot(any())),
    );

    blocTest<NetWorthBloc, NetWorthState>(
      'ignores a request before the overview is loaded',
      build: buildBloc,
      act: (bloc) => bloc.add(const NetWorthSnapshotRequested()),
      expect: () => <NetWorthState>[],
    );
  });
}
