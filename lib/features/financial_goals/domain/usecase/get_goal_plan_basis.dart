import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_plan_basis.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/repository/financial_goal_repository.dart';

/// Loads the current monthly income and net worth the goal form previews
/// a plan from; unknown figures are left null.
class GetGoalPlanBasis {
  const GetGoalPlanBasis(this._repository);

  final FinancialGoalRepository _repository;

  Future<GoalPlanBasis> call() => _repository.getPlanBasis();
}
