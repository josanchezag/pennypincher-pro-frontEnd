import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/crud/data/crud_repository_impl.dart';
import 'package:pennypincher_pro/core/error/app_exception.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/core/error/failure_guard.dart';
import 'package:pennypincher_pro/features/financial_goals/data/datasource/financial_goal_remote_datasource.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/financial_goal_entity.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_projection_entity.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/repository/financial_goal_repository.dart';

@LazySingleton(as: FinancialGoalRepository)
class FinancialGoalRepositoryImpl
    extends CrudRepositoryImpl<FinancialGoal, GoalDraft>
    implements FinancialGoalRepository {
  FinancialGoalRepositoryImpl(this._goals) : super(_goals);

  final FinancialGoalRemoteDataSource _goals;

  /// The goals and their projections, requested in parallel. When only
  /// the projections fail, the goals come without them.
  @override
  Future<Either<Failure, List<FinancialGoal>>> getAll() =>
      guardFailures(() async {
        final projections = _projectionsOrNone();
        final goals = await _goals.getAll();
        return withProjections(goals, await projections);
      });

  Future<List<GoalProjection>> _projectionsOrNone() async {
    try {
      return await _goals.getAllProjections();
    } on AppException {
      return const [];
    }
  }

  @override
  Future<Either<Failure, GoalProjection>> getProjection(String goalId) =>
      guardFailures(() => _goals.getProjection(goalId));

  @override
  Future<Either<Failure, List<FinancialGoal>>> createDefaults() =>
      guardFailures(_goals.createDefaults);

  /// [goals] with the projection of the same goal, when there is one.
  static List<FinancialGoal> withProjections(
    List<FinancialGoal> goals,
    List<GoalProjection> projections,
  ) {
    final byGoal = {
      for (final projection in projections) projection.goalId: projection,
    };
    return [
      for (final goal in goals) goal.copyWith(projection: byGoal[goal.id]),
    ];
  }
}
