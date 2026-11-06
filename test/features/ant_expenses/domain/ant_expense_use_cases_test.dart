import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/ant_expenses/domain/repository/ant_expense_repository.dart';
import 'package:pennypincher_pro/features/ant_expenses/domain/usecase/ant_expense_use_cases.dart';

import '../../../helpers/ant_fixtures.dart';

class _MockRepository extends Mock implements AntExpenseRepository {}

void main() {
  late _MockRepository repository;

  setUp(() => repository = _MockRepository());

  test('each use case calls its repository method', () async {
    when(repository.getSummary).thenAnswer((_) async => Right(antSummary));
    when(repository.getCuts).thenAnswer((_) async => Right([octoberCut]));
    when(() => repository.getCutItems(octoberBudgetId))
        .thenAnswer((_) async => Right([octoberSnack]));
    when(() => repository.getTrend(DateTime(2026, 11), 12))
        .thenAnswer((_) async => Right(antTrend));
    when(() => repository.saveLimit(const Money.fromUnits(90000)))
        .thenAnswer((_) async => const Right(Money.fromUnits(90000)));

    expect(
      await GetAntSummary(repository)(),
      Right<Failure, Object>(antSummary),
    );
    expect(
      (await GetAntCuts(repository)()).getOrElse(() => []),
      [octoberCut],
    );
    expect(
      (await GetAntCutItems(repository)(octoberBudgetId)).getOrElse(() => []),
      [octoberSnack],
    );
    expect(
      (await GetAntTrend(repository)(DateTime(2026, 11), 12))
          .getOrElse(() => []),
      antTrend,
    );
    expect(
      await SaveAntLimit(repository)(const Money.fromUnits(90000)),
      const Right<Failure, Money?>(Money.fromUnits(90000)),
    );
  });
}
