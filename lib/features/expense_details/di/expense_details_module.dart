import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/crud/domain/balance_item.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/crud/domain/usecase/crud_use_cases.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/credit_card_entity.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/fixed_expense_entity.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/loan_entity.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/variable_expense_entity.dart';
import 'package:pennypincher_pro/features/expense_details/domain/repository/credit_card_repository.dart';
import 'package:pennypincher_pro/features/expense_details/domain/repository/expense_summary_repository.dart';
import 'package:pennypincher_pro/features/expense_details/domain/repository/fixed_expense_repository.dart';
import 'package:pennypincher_pro/features/expense_details/domain/repository/loan_repository.dart';
import 'package:pennypincher_pro/features/expense_details/domain/repository/variable_expense_repository.dart';
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

  @injectable
  GetItems<FixedExpense, CategorizedDraft<FixedExpenseCategory>>
      getFixedExpenses(FixedExpenseRepository repository) =>
          GetItems(repository);

  @injectable
  SaveItem<FixedExpense, CategorizedDraft<FixedExpenseCategory>>
      saveFixedExpense(FixedExpenseRepository repository) =>
          SaveItem(repository);

  @injectable
  DeleteItem<FixedExpense, CategorizedDraft<FixedExpenseCategory>>
      deleteFixedExpense(FixedExpenseRepository repository) =>
          DeleteItem(repository);

  @injectable
  GetItems<VariableExpense, CategorizedDraft<VariableExpenseCategory>>
      getVariableExpenses(VariableExpenseRepository repository) =>
          GetItems(repository);

  @injectable
  SaveItem<VariableExpense, CategorizedDraft<VariableExpenseCategory>>
      saveVariableExpense(VariableExpenseRepository repository) =>
          SaveItem(repository);

  @injectable
  DeleteItem<VariableExpense, CategorizedDraft<VariableExpenseCategory>>
      deleteVariableExpense(VariableExpenseRepository repository) =>
          DeleteItem(repository);
}
