import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/monthly_budget_entity.dart';
import 'package:pennypincher_pro/features/budget/domain/repository/monthly_budget_repository.dart';
import 'package:pennypincher_pro/features/budget/domain/usecase/monthly_budget_use_cases.dart';

import '../../../helpers/budget_fixtures.dart';

class _MockRepository extends Mock implements MonthlyBudgetRepository {}

void main() {
  late _MockRepository repository;

  setUpAll(() => registerFallbackValue(DateTime(2026)));

  setUp(() => repository = _MockRepository());

  test('delegate every budget operation to the repository', () async {
    const settings = BudgetSettings(workDays: 21);
    when(() => repository.getByMonth(DateTime(2026, 10)))
        .thenAnswer((_) async => Right(octoberBudget));
    when(() => repository.create(DateTime(2026, 10)))
        .thenAnswer((_) async => Right(octoberBudget));
    when(() => repository.update('b', settings))
        .thenAnswer((_) async => Right(octoberBudget));
    when(() => repository.recalculate('b'))
        .thenAnswer((_) async => Right(octoberBudget));

    await GetMonthlyBudget(repository)(DateTime(2026, 10));
    await CreateMonthlyBudget(repository)(DateTime(2026, 10));
    await UpdateMonthlyBudget(repository)('b', settings);
    await RecalculateBudget(repository)('b');

    verify(() => repository.getByMonth(DateTime(2026, 10))).called(1);
    verify(() => repository.create(DateTime(2026, 10))).called(1);
    verify(() => repository.update('b', settings)).called(1);
    verify(() => repository.recalculate('b')).called(1);
  });

  test('limit budgets to the months the backend accepts', () {
    expect(BudgetLimits.firstMonth, DateTime(2000));
    expect(BudgetLimits.lastMonth, DateTime(2100, 12));
  });

  test('compare six months up to the month of a date by default', () async {
    when(
      () => repository.getComparison(any(), months: any(named: 'months')),
    ).thenAnswer((_) async => Right(sixMonthComparison));

    final result =
        await GetMonthlyComparison(repository)(DateTime(2026, 10, 25, 23));

    expect(result.getOrElse(() => []), sixMonthComparison);
    verify(() => repository.getComparison(DateTime(2026, 10), months: 6))
        .called(1);
  });

  test('keep the number of months within what the API accepts', () async {
    when(
      () => repository.getComparison(any(), months: any(named: 'months')),
    ).thenAnswer((_) async => const Right([]));

    await GetMonthlyComparison(repository)(DateTime(2026, 10), months: 0);
    await GetMonthlyComparison(repository)(DateTime(2026, 10), months: 36);

    verify(() => repository.getComparison(DateTime(2026, 10), months: 1))
        .called(1);
    verify(() => repository.getComparison(DateTime(2026, 10), months: 24))
        .called(1);
  });
}
