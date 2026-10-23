import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/core/time/clock.dart';
import 'package:pennypincher_pro/core/time/time_range.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/net_worth_trend_entity.dart';
import 'package:pennypincher_pro/features/net_worth/domain/usecase/net_worth_use_cases.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/bloc/net_worth_report_bloc.dart';

import '../../../../helpers/net_worth_fixtures.dart';

class _MockGetNetWorthTrend extends Mock implements GetNetWorthTrend {}

class _FixedClock implements Clock {
  const _FixedClock(this.time);

  final DateTime time;

  @override
  DateTime now() => time;
}

const Failure _offline = NetworkFailure('Offline');
final DateTime _now = DateTime(2026, 10, 23, 22, 15);

void main() {
  late _MockGetNetWorthTrend getTrend;

  setUp(() => getTrend = _MockGetNetWorthTrend());

  NetWorthReportBloc buildBloc() =>
      NetWorthReportBloc(getTrend, _FixedClock(_now));

  void answer(DateTime? from, Either<Failure, NetWorthTrend> result) =>
      when(() => getTrend(from: from)).thenAnswer((_) async => result);

  test('opens loading the last year', () {
    expect(buildBloc().state, const NetWorthReportState());
    expect(NetWorthReportState.defaultRange, TimeRange.oneYear);
  });

  blocTest<NetWorthReportBloc, NetWorthReportState>(
    'loads the year from the first day of the local month minus 11',
    setUp: () => answer(DateTime(2025, 11), Right(threeMonthTrend)),
    build: buildBloc,
    act: (bloc) => bloc.add(const NetWorthReportLoadRequested()),
    expect: () => [
      const NetWorthReportState(),
      NetWorthReportState(status: ReportStatus.loaded, trend: threeMonthTrend),
    ],
    verify: (_) => verify(() => getTrend(from: DateTime(2025, 11))).called(1),
  );

  blocTest<NetWorthReportBloc, NetWorthReportState>(
    'reloads the whole history without a start',
    setUp: () => answer(null, const Right(NetWorthTrend([]))),
    build: buildBloc,
    act: (bloc) => bloc.add(const NetWorthReportRangeChanged(TimeRange.all)),
    expect: () => [
      const NetWorthReportState(range: TimeRange.all),
      const NetWorthReportState(
        range: TimeRange.all,
        status: ReportStatus.loaded,
        trend: NetWorthTrend([]),
      ),
    ],
  );

  blocTest<NetWorthReportBloc, NetWorthReportState>(
    'ignores picking the range already shown',
    build: buildBloc,
    act: (bloc) =>
        bloc.add(const NetWorthReportRangeChanged(TimeRange.oneYear)),
    expect: () => const <NetWorthReportState>[],
  );

  blocTest<NetWorthReportBloc, NetWorthReportState>(
    'shows the error of a failed load',
    setUp: () => answer(DateTime(2025, 11), const Left(_offline)),
    build: buildBloc,
    act: (bloc) => bloc.add(const NetWorthReportLoadRequested()),
    expect: () => [
      const NetWorthReportState(),
      const NetWorthReportState(
        status: ReportStatus.failure,
        error: 'Offline',
      ),
    ],
  );

  group('a result that arrives after another range was picked', () {
    late Completer<Either<Failure, NetWorthTrend>> slowYear;

    blocTest<NetWorthReportBloc, NetWorthReportState>(
      'is dropped',
      setUp: () {
        slowYear = Completer();
        when(() => getTrend(from: DateTime(2025, 11)))
            .thenAnswer((_) => slowYear.future);
        answer(DateTime(2026, 5), Right(threeMonthTrend));
      },
      build: buildBloc,
      act: (bloc) async {
        bloc
          ..add(const NetWorthReportLoadRequested())
          ..add(const NetWorthReportRangeChanged(TimeRange.sixMonths));
        await Future<void>.delayed(Duration.zero);
        slowYear.complete(const Left(_offline));
      },
      expect: () => [
        const NetWorthReportState(),
        const NetWorthReportState(range: TimeRange.sixMonths),
        NetWorthReportState(
          range: TimeRange.sixMonths,
          status: ReportStatus.loaded,
          trend: threeMonthTrend,
        ),
      ],
    );
  });
}
