import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/features/net_worth/domain/repository/net_worth_repository.dart';
import 'package:pennypincher_pro/features/net_worth/domain/usecase/net_worth_use_cases.dart';

import '../../../helpers/net_worth_fixtures.dart';

class _MockNetWorthRepository extends Mock implements NetWorthRepository {}

void main() {
  group('net worth use cases', () {
    late _MockNetWorthRepository repository;

    setUp(() => repository = _MockNetWorthRepository());

    test('load the history and the live totals', () async {
      when(repository.getSnapshots)
          .thenAnswer((_) async => Right([august, september]));
      when(repository.getCurrent)
          .thenAnswer((_) async => const Right(currentSummary));

      final history = await GetNetWorthSnapshots(repository)();
      final current = await GetCurrentNetWorth(repository)();

      expect(history.getOrElse(() => []), [august, september]);
      expect(current, const Right<Failure, Object>(currentSummary));
    });

    test('create the snapshot of the month of the given date', () async {
      when(() => repository.createSnapshot(DateTime(2026, 10)))
          .thenAnswer((_) async => Right(snapshotOf(2026, 10, 1)));

      await CreateSnapshot(repository)(DateTime(2026, 10, 22, 9));

      verify(() => repository.createSnapshot(DateTime(2026, 10))).called(1);
    });

    test('load the trend since the first day of the month of a date', () async {
      when(() => repository.getTrend(from: any(named: 'from')))
          .thenAnswer((_) async => Right(threeMonthTrend));

      await GetNetWorthTrend(repository)(from: DateTime(2025, 11, 23, 8));
      await GetNetWorthTrend(repository)();

      verify(() => repository.getTrend(from: DateTime(2025, 11))).called(1);
      verify(() => repository.getTrend()).called(1);
    });
  });
}
