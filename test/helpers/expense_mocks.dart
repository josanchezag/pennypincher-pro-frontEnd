import 'package:bloc_test/bloc_test.dart';
import 'package:pennypincher_pro/core/crud/domain/balance_item.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/credit_card_entity.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/bloc/credit_card_bloc.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/bloc/expenses_hub_bloc.dart';

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
