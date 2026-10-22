import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/crud/domain/balance_item.dart';
import 'package:pennypincher_pro/core/crud/domain/usecase/crud_use_cases.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/credit_card_entity.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/loan_entity.dart';
import 'package:pennypincher_pro/features/expense_details/domain/repository/credit_card_repository.dart';
import 'package:pennypincher_pro/features/expense_details/domain/repository/expense_summary_repository.dart';
import 'package:pennypincher_pro/features/expense_details/domain/repository/loan_repository.dart';
import 'package:pennypincher_pro/features/expense_details/domain/usecase/get_expense_summary.dart';

/// Registers the expense details use cases, keeping the domain layer free
/// of dependency injection annotations.
@module
abstract class ExpenseDetailsModule {
  @injectable
  GetExpenseSummary getExpenseSummary(ExpenseSummaryRepository repository) =>
      GetExpenseSummary(repository);

  @injectable
  GetItems<CreditCard, BalanceDraft> getCreditCards(
    CreditCardRepository repository,
  ) =>
      GetItems(repository);

  @injectable
  SaveItem<CreditCard, BalanceDraft> saveCreditCard(
    CreditCardRepository repository,
  ) =>
      SaveItem(repository);

  @injectable
  DeleteItem<CreditCard, BalanceDraft> deleteCreditCard(
    CreditCardRepository repository,
  ) =>
      DeleteItem(repository);

  @injectable
  GetItems<Loan, BalanceDraft> getLoans(LoanRepository repository) =>
      GetItems(repository);

  @injectable
  SaveItem<Loan, BalanceDraft> saveLoan(LoanRepository repository) =>
      SaveItem(repository);

  @injectable
  DeleteItem<Loan, BalanceDraft> deleteLoan(LoanRepository repository) =>
      DeleteItem(repository);
}
