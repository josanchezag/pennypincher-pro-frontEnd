import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/financial_goal_entity.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_plan_basis.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/bloc/goal_plan_basis_cubit.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/bloc/goals_bloc.dart';

import 'net_worth_mocks.dart';

class MockGoalsBloc
    extends MockBloc<CrudEvent<GoalDraft>, CrudState<FinancialGoal>>
    implements GoalsBloc {}

class MockGoalPlanBasisCubit extends MockCubit<GoalPlanBasis>
    implements GoalPlanBasisCubit {}

/// Registers a goals bloc in [state] and, for the form of the goals
/// screen, the plan [basis].
MockGoalsBloc registerGoalsBloc(
  CrudState<FinancialGoal> state, {
  Stream<CrudState<FinancialGoal>> stream = const Stream.empty(),
  GoalPlanBasis basis = GoalPlanBasis.unknown,
}) {
  registerGoalPlanBasis(basis);
  return registerBloc<GoalsBloc, CrudState<FinancialGoal>>(
    MockGoalsBloc(),
    state,
    stream: stream,
  ) as MockGoalsBloc;
}

MockGoalPlanBasisCubit registerGoalPlanBasis(GoalPlanBasis basis) {
  final cubit = MockGoalPlanBasisCubit();
  when(cubit.load).thenAnswer((_) async {});
  return registerBloc<GoalPlanBasisCubit, GoalPlanBasis>(cubit, basis)
      as MockGoalPlanBasisCubit;
}
