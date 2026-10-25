import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/crud/domain/usecase/crud_use_cases.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/income_source_entity.dart';
import 'package:pennypincher_pro/features/budget/domain/repository/income_source_repository.dart';
import 'package:pennypincher_pro/features/budget/domain/repository/monthly_budget_repository.dart';
import 'package:pennypincher_pro/features/budget/domain/usecase/monthly_budget_use_cases.dart';

/// Registers the budget use cases, keeping the domain layer free of
/// dependency injection annotations.
@module
abstract class BudgetModule {
  @injectable
  GetItems<IncomeSource, CategorizedDraft<IncomeCategory>> getIncomeSources(
    IncomeSourceRepository repository,
  ) =>
      GetItems(repository);

  @injectable
  SaveItem<IncomeSource, CategorizedDraft<IncomeCategory>> saveIncomeSource(
    IncomeSourceRepository repository,
  ) =>
      SaveItem(repository);

  @injectable
  DeleteItem<IncomeSource, CategorizedDraft<IncomeCategory>> deleteIncomeSource(
    IncomeSourceRepository repository,
  ) =>
      DeleteItem(repository);

  @injectable
  GetMonthlyBudget getMonthlyBudget(MonthlyBudgetRepository repository) =>
      GetMonthlyBudget(repository);

  @injectable
  CreateMonthlyBudget createMonthlyBudget(
    MonthlyBudgetRepository repository,
  ) =>
      CreateMonthlyBudget(repository);

  @injectable
  UpdateMonthlyBudget updateMonthlyBudget(
    MonthlyBudgetRepository repository,
  ) =>
      UpdateMonthlyBudget(repository);

  @injectable
  RecalculateBudget recalculateBudget(MonthlyBudgetRepository repository) =>
      RecalculateBudget(repository);

  @injectable
  GetMonthlyComparison getMonthlyComparison(
    MonthlyBudgetRepository repository,
  ) =>
      GetMonthlyComparison(repository);
}
