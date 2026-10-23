import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/crud/domain/usecase/crud_use_cases.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/financial_goal_entity.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/repository/financial_goal_repository.dart';

/// Registers the financial goal use cases, keeping the domain layer free
/// of dependency injection annotations.
@module
abstract class FinancialGoalsModule {
  @injectable
  GetItems<FinancialGoal, GoalDraft> getFinancialGoals(
    FinancialGoalRepository repository,
  ) =>
      GetItems(repository);

  @injectable
  SaveItem<FinancialGoal, GoalDraft> saveFinancialGoal(
    FinancialGoalRepository repository,
  ) =>
      SaveItem(repository);

  @injectable
  DeleteItem<FinancialGoal, GoalDraft> deleteFinancialGoal(
    FinancialGoalRepository repository,
  ) =>
      DeleteItem(repository);

  @injectable
  CreateDefaultItems<FinancialGoal> createDefaultFinancialGoals(
    FinancialGoalRepository repository,
  ) =>
      CreateDefaultItems(repository);
}
