import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/features/ant_expenses/domain/entity/ant_expense_entity.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/bloc/ant_cut_items_cubit.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/bloc/ant_expense_bloc.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/bloc/ant_insights_cubit.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/bloc/ant_section.dart';

import 'net_worth_mocks.dart';

class MockAntExpenseBloc
    extends MockBloc<CrudEvent<AntExpenseDraft>, CrudState<AntExpense>>
    implements AntExpenseBloc {}

MockAntExpenseBloc registerAntExpenseBloc(
  CrudState<AntExpense> state, {
  Stream<CrudState<AntExpense>> stream = const Stream.empty(),
}) =>
    registerBloc<AntExpenseBloc, CrudState<AntExpense>>(
      MockAntExpenseBloc(),
      state,
      stream: stream,
    ) as MockAntExpenseBloc;

class MockAntInsightsCubit extends MockCubit<AntInsightsState>
    implements AntInsightsCubit {}

/// Registers a cubit double in [state] whose actions complete at once.
MockAntInsightsCubit registerAntInsightsCubit(
  AntInsightsState state, {
  Stream<AntInsightsState> stream = const Stream.empty(),
}) {
  final cubit = MockAntInsightsCubit();
  when(cubit.load).thenAnswer((_) async {});
  when(cubit.retrySummary).thenAnswer((_) async {});
  when(cubit.retryTrend).thenAnswer((_) async {});
  when(cubit.retryCuts).thenAnswer((_) async {});
  when(cubit.refreshPeriod).thenAnswer((_) async {});
  when(() => cubit.changeTrendMonths(any())).thenAnswer((_) async {});
  when(() => cubit.saveLimit(any())).thenAnswer((_) async {});
  return registerBloc<AntInsightsCubit, AntInsightsState>(
    cubit,
    state,
    stream: stream,
  ) as MockAntInsightsCubit;
}

class MockAntCutItemsCubit extends MockCubit<AntSection<List<AntExpense>>>
    implements AntCutItemsCubit {}

MockAntCutItemsCubit registerAntCutItemsCubit(
  AntSection<List<AntExpense>> state, {
  Stream<AntSection<List<AntExpense>>> stream = const Stream.empty(),
}) {
  final cubit = MockAntCutItemsCubit();
  when(() => cubit.load(any())).thenAnswer((_) async {});
  return registerBloc<AntCutItemsCubit, AntSection<List<AntExpense>>>(
    cubit,
    state,
    stream: stream,
  ) as MockAntCutItemsCubit;
}
