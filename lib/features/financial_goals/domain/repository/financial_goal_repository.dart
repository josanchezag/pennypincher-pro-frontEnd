import 'package:dartz/dartz.dart';
import 'package:pennypincher_pro/core/crud/domain/crud_repository.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/financial_goal_entity.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_plan_basis.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_projection_entity.dart';

/// The user's financial goals. The list comes with the projection of
/// every goal against the current net worth.
abstract interface class FinancialGoalRepository
    implements
        CrudRepository<FinancialGoal, GoalDraft>,
        DefaultItemsRepository<FinancialGoal> {
  /// Projection of the goal with [goalId] against the current net worth.
  Future<Either<Failure, GoalProjection>> getProjection(String goalId);

  /// The current monthly income and net worth, requested in parallel; a
  /// figure that cannot be loaded is left unknown, so this never fails.
  Future<GoalPlanBasis> getPlanBasis();
}
