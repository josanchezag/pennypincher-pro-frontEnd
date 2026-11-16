import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_plan_basis.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/usecase/get_goal_plan_basis.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/bloc/goal_plan_basis_cubit.dart';

import '../../../../helpers/goal_fixtures.dart';

class _MockGetGoalPlanBasis extends Mock implements GetGoalPlanBasis {}

void main() {
  late _MockGetGoalPlanBasis getPlanBasis;
  const basis =
      GoalPlanBasis(monthlyIncome: monthlyIncome, currentNetWorth: netWorth);

  setUp(() {
    getPlanBasis = _MockGetGoalPlanBasis();
    when(getPlanBasis.call).thenAnswer((_) async => basis);
  });

  test('starts with an unknown basis', () {
    expect(GoalPlanBasisCubit(getPlanBasis).state, GoalPlanBasis.unknown);
  });

  blocTest<GoalPlanBasisCubit, GoalPlanBasis>(
    'loads the income and the net worth',
    build: () => GoalPlanBasisCubit(getPlanBasis),
    act: (cubit) => cubit.load(),
    expect: () => [basis],
  );
}
