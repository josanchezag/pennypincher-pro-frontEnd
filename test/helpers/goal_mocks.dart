import 'package:bloc_test/bloc_test.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/financial_goal_entity.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/bloc/goals_bloc.dart';

import 'net_worth_mocks.dart';

class MockGoalsBloc
    extends MockBloc<CrudEvent<GoalDraft>, CrudState<FinancialGoal>>
    implements GoalsBloc {}

MockGoalsBloc registerGoalsBloc(
  CrudState<FinancialGoal> state, {
  Stream<CrudState<FinancialGoal>> stream = const Stream.empty(),
}) =>
    registerBloc<GoalsBloc, CrudState<FinancialGoal>>(
      MockGoalsBloc(),
      state,
      stream: stream,
    ) as MockGoalsBloc;
