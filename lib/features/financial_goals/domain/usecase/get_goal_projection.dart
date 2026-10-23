import 'package:dartz/dartz.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_projection_entity.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/repository/financial_goal_repository.dart';

/// Loads the projection of one goal against the current net worth.
class GetGoalProjection {
  const GetGoalProjection(this._repository);

  final FinancialGoalRepository _repository;

  Future<Either<Failure, GoalProjection>> call(String goalId) =>
      _repository.getProjection(goalId);
}
