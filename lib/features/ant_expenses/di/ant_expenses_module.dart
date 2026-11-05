import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/crud/domain/usecase/crud_use_cases.dart';
import 'package:pennypincher_pro/features/ant_expenses/domain/entity/ant_expense_entity.dart';
import 'package:pennypincher_pro/features/ant_expenses/domain/repository/ant_expense_repository.dart';
import 'package:pennypincher_pro/features/ant_expenses/domain/usecase/ant_expense_use_cases.dart';

/// Registers the ant expense use cases, keeping the domain layer free of
/// dependency injection annotations.
@module
abstract class AntExpensesModule {
  @injectable
  GetItems<AntExpense, AntExpenseDraft> getAntExpenses(
    AntExpenseRepository repository,
  ) =>
      GetItems(repository);

  @injectable
  SaveItem<AntExpense, AntExpenseDraft> saveAntExpense(
    AntExpenseRepository repository,
  ) =>
      SaveItem(repository);

  @injectable
  DeleteItem<AntExpense, AntExpenseDraft> deleteAntExpense(
    AntExpenseRepository repository,
  ) =>
      DeleteItem(repository);

  @injectable
  GetAntSummary getAntSummary(AntExpenseRepository repository) =>
      GetAntSummary(repository);

  @injectable
  GetAntCuts getAntCuts(AntExpenseRepository repository) =>
      GetAntCuts(repository);

  @injectable
  GetAntCutItems getAntCutItems(AntExpenseRepository repository) =>
      GetAntCutItems(repository);

  @injectable
  GetAntTrend getAntTrend(AntExpenseRepository repository) =>
      GetAntTrend(repository);

  @injectable
  SaveAntLimit saveAntLimit(AntExpenseRepository repository) =>
      SaveAntLimit(repository);
}
