import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/crud/domain/usecase/crud_use_cases.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/repository/financial_goal_repository.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/usecase/get_goal_projection.dart';

import '../../../helpers/goal_fixtures.dart';

class _MockRepository extends Mock implements FinancialGoalRepository {}

void main() {
  test('CreateDefaultItems adds the standard goals', () async {
    final repository = _MockRepository();
    when(repository.createDefaults).thenAnswer((_) async => Right(excelGoals));

    final result = await CreateDefaultItems(repository)();

    expect(result.getOrElse(() => []), excelGoals);
  });

  test('GetGoalProjection loads the projection of one goal', () async {
    final repository = _MockRepository();
    when(() => repository.getProjection('g1'))
        .thenAnswer((_) async => Right(security.projection!));

    final result = await GetGoalProjection(repository)('g1');

    expect(
      result.getOrElse(() => throw StateError('missing')),
      security.projection,
    );
  });
}
