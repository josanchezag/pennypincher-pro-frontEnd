import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/crud/domain/usecase/crud_use_cases.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/income_source_entity.dart';
import 'package:pennypincher_pro/features/budget/domain/repository/income_source_repository.dart';

/// Registers the budget use cases, keeping the domain layer free of
/// dependency injection annotations.
@module
abstract class BudgetModule {
  @injectable
  GetItems<IncomeSource, IncomeCategory> getIncomeSources(
    IncomeSourceRepository repository,
  ) =>
      GetItems(repository);

  @injectable
  SaveItem<IncomeSource, IncomeCategory> saveIncomeSource(
    IncomeSourceRepository repository,
  ) =>
      SaveItem(repository);

  @injectable
  DeleteItem<IncomeSource, IncomeCategory> deleteIncomeSource(
    IncomeSourceRepository repository,
  ) =>
      DeleteItem(repository);
}
