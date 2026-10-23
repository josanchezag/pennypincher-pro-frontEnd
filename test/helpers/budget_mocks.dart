import 'package:bloc_test/bloc_test.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/income_source_entity.dart';
import 'package:pennypincher_pro/features/budget/presentation/bloc/income_source_bloc.dart';
import 'package:pennypincher_pro/features/budget/presentation/bloc/monthly_budget_bloc.dart';

import 'net_worth_mocks.dart';

class MockIncomeSourceBloc extends MockBloc<
    CrudEvent<CategorizedDraft<IncomeCategory>>,
    CrudState<IncomeSource>> implements IncomeSourceBloc {}

MockIncomeSourceBloc registerIncomeSourceBloc(
  CrudState<IncomeSource> state, {
  Stream<CrudState<IncomeSource>> stream = const Stream.empty(),
}) =>
    registerBloc<IncomeSourceBloc, CrudState<IncomeSource>>(
      MockIncomeSourceBloc(),
      state,
      stream: stream,
    ) as MockIncomeSourceBloc;

class MockMonthlyBudgetBloc
    extends MockBloc<MonthlyBudgetEvent, MonthlyBudgetState>
    implements MonthlyBudgetBloc {}

MockMonthlyBudgetBloc registerMonthlyBudgetBloc(
  MonthlyBudgetState state, {
  Stream<MonthlyBudgetState> stream = const Stream.empty(),
}) =>
    registerBloc<MonthlyBudgetBloc, MonthlyBudgetState>(
      MockMonthlyBudgetBloc(),
      state,
      stream: stream,
    ) as MockMonthlyBudgetBloc;
