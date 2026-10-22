import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/error/app_exception.dart';
import 'package:pennypincher_pro/core/error/error_codes.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/features/budget/data/datasource/monthly_budget_remote_datasource.dart';
import 'package:pennypincher_pro/features/budget/data/model/monthly_budget_models.dart';
import 'package:pennypincher_pro/features/budget/data/repository/monthly_budget_repository_impl.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/monthly_budget_entity.dart';

import '../../../helpers/budget_fixtures.dart';

class _MockRemote extends Mock implements MonthlyBudgetRemoteDataSource {}

final MonthlyBudgetModel _model =
    MonthlyBudgetModel.fromJson(Map.of(octoberBudgetJson));

void main() {
  late _MockRemote remote;
  late MonthlyBudgetRepositoryImpl repository;

  setUp(() {
    remote = _MockRemote();
    repository = MonthlyBudgetRepositoryImpl(remote);
  });

  test('returns the budget of the month of a date', () async {
    when(() => remote.getByMonth(DateTime(2026, 10)))
        .thenAnswer((_) async => _model);

    final result = await repository.getByMonth(DateTime(2026, 10, 22, 9));

    expect(result, Right<Failure, MonthlyBudget?>(octoberBudget));
  });

  test('returns no budget for a month without one', () async {
    when(() => remote.getByMonth(DateTime(2026, 11))).thenThrow(
      const AppException(
        code: 'NOT_FOUND',
        message: 'Monthly budget not found',
        statusCode: 404,
      ),
    );

    final result = await repository.getByMonth(DateTime(2026, 11));

    expect(result, const Right<Failure, MonthlyBudget?>(null));
  });

  test('reports other failures when getting a month', () async {
    when(() => remote.getByMonth(DateTime(2026, 11))).thenThrow(
      const AppException(code: ErrorCodes.networkError, message: 'Offline'),
    );

    final result = await repository.getByMonth(DateTime(2026, 11));

    expect(
      result.fold((failure) => failure, (_) => null),
      isA<NetworkFailure>(),
    );
  });

  test('creates, updates and recalculates a budget', () async {
    const settings = BudgetSettings(workDays: 20);
    when(() => remote.create(DateTime(2026, 10)))
        .thenAnswer((_) async => _model);
    when(() => remote.update('b-2026-10', settings))
        .thenAnswer((_) async => _model);
    when(() => remote.recalculate('b-2026-10')).thenAnswer((_) async => _model);

    final expected = Right<Failure, MonthlyBudget>(octoberBudget);
    expect(await repository.create(DateTime(2026, 10, 5)), expected);
    expect(await repository.update('b-2026-10', settings), expected);
    expect(await repository.recalculate('b-2026-10'), expected);
  });

  test('reports a month that already has a budget as a conflict', () async {
    when(() => remote.create(DateTime(2026, 10))).thenThrow(
      const AppException(
        code: 'CONFLICT',
        message: 'Budget already exists',
        statusCode: 409,
      ),
    );

    final result = await repository.create(DateTime(2026, 10));

    expect(
      result.fold((failure) => failure, (_) => null),
      isA<ServerFailure>().having((f) => f.code, 'code', 'CONFLICT'),
    );
  });
}
