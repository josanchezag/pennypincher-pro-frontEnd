import 'package:bloc_test/bloc_test.dart';
import 'package:pennypincher_pro/core/crud/domain/balance_item.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/credit_card_entity.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/fixed_expense_entity.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/loan_entity.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/variable_expense_entity.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/bloc/credit_card_bloc.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/bloc/expenses_hub_bloc.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/bloc/fixed_expense_bloc.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/bloc/loan_bloc.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/bloc/variable_expense_bloc.dart';

import 'net_worth_mocks.dart';

class MockExpensesHubBloc extends MockBloc<ExpensesHubEvent, ExpensesHubState>
    implements ExpensesHubBloc {}

MockExpensesHubBloc registerExpensesHubBloc(
  ExpensesHubState state, {
  Stream<ExpensesHubState> stream = const Stream.empty(),
}) =>
    registerBloc<ExpensesHubBloc, ExpensesHubState>(
      MockExpensesHubBloc(),
      state,
      stream: stream,
    ) as MockExpensesHubBloc;

class MockCreditCardBloc
    extends MockBloc<CrudEvent<BalanceDraft>, CrudState<CreditCard>>
    implements CreditCardBloc {}

MockCreditCardBloc registerCreditCardBloc(
  CrudState<CreditCard> state, {
  Stream<CrudState<CreditCard>> stream = const Stream.empty(),
}) =>
    registerBloc<CreditCardBloc, CrudState<CreditCard>>(
      MockCreditCardBloc(),
      state,
      stream: stream,
    ) as MockCreditCardBloc;

class MockLoanBloc extends MockBloc<CrudEvent<BalanceDraft>, CrudState<Loan>>
    implements LoanBloc {}

MockLoanBloc registerLoanBloc(
  CrudState<Loan> state, {
  Stream<CrudState<Loan>> stream = const Stream.empty(),
}) =>
    registerBloc<LoanBloc, CrudState<Loan>>(
      MockLoanBloc(),
      state,
      stream: stream,
    ) as MockLoanBloc;

class MockFixedExpenseBloc extends MockBloc<
    CrudEvent<CategorizedDraft<FixedExpenseCategory>>,
    CrudState<FixedExpense>> implements FixedExpenseBloc {}

MockFixedExpenseBloc registerFixedExpenseBloc(
  CrudState<FixedExpense> state, {
  Stream<CrudState<FixedExpense>> stream = const Stream.empty(),
}) =>
    registerBloc<FixedExpenseBloc, CrudState<FixedExpense>>(
      MockFixedExpenseBloc(),
      state,
      stream: stream,
    ) as MockFixedExpenseBloc;

class MockVariableExpenseBloc extends MockBloc<
    CrudEvent<CategorizedDraft<VariableExpenseCategory>>,
    CrudState<VariableExpense>> implements VariableExpenseBloc {}

MockVariableExpenseBloc registerVariableExpenseBloc(
  CrudState<VariableExpense> state, {
  Stream<CrudState<VariableExpense>> stream = const Stream.empty(),
}) =>
    registerBloc<VariableExpenseBloc, CrudState<VariableExpense>>(
      MockVariableExpenseBloc(),
      state,
      stream: stream,
    ) as MockVariableExpenseBloc;
