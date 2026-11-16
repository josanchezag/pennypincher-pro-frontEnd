import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_plan_basis.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/usecase/get_goal_plan_basis.dart';

/// The current monthly income and net worth the goal form previews a plan
/// from, unknown until [load] finishes. A new instance is created per
/// goals screen, so a change of income elsewhere is read when it opens.
@injectable
class GoalPlanBasisCubit extends Cubit<GoalPlanBasis> {
  GoalPlanBasisCubit(this._getPlanBasis) : super(GoalPlanBasis.unknown);

  final GetGoalPlanBasis _getPlanBasis;

  Future<void> load() async {
    final basis = await _getPlanBasis();
    if (!isClosed) {
      emit(basis);
    }
  }
}
