import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/expense_summary_entity.dart';
import 'package:pennypincher_pro/features/expense_details/domain/usecase/get_expense_summary.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/bloc/expenses_hub_bloc.dart';

import '../../../../helpers/expense_fixtures.dart';

class _MockGetSummary extends Mock implements GetExpenseSummary {}

void main() {
  late _MockGetSummary getSummary;

  setUpAll(() => registerFallbackValue(ExpenseKind.loans));

  setUp(() {
    getSummary = _MockGetSummary();
    when(() => getSummary(any()))
        .thenAnswer((_) async => const Right(fixedSummary));
  });

  ExpensesHubBloc buildBloc() => ExpensesHubBloc(getSummary);

  test('compares events by value', () {
    expect(const ExpensesHubStarted(), const ExpensesHubStarted());
    expect(
      const ExpenseSummaryRetried(ExpenseKind.loans),
      isNot(const ExpenseSummaryRetried(ExpenseKind.savings)),
    );
  });

  test('starts with every total loading', () {
    final state = buildBloc().state;

    for (final kind in ExpenseKind.values) {
      expect(state.statusOf(kind), const SummaryLoading());
    }
  });

  blocTest<ExpensesHubBloc, ExpensesHubState>(
    'loads the totals of every list, each as soon as it arrives',
    setUp: () => when(() => getSummary(ExpenseKind.creditCards))
        .thenAnswer((_) async => const Right(cardsSummary)),
    build: buildBloc,
    act: (bloc) => bloc.add(const ExpensesHubStarted()),
    expect: () => [
      const ExpensesHubState(
        statuses: {ExpenseKind.creditCards: SummaryLoaded(cardsSummary)},
      ),
      isA<ExpensesHubState>(),
      isA<ExpensesHubState>(),
      isA<ExpensesHubState>(),
      ExpensesHubState(
        statuses: {
          for (final kind in ExpenseKind.values)
            kind: SummaryLoaded(
              kind == ExpenseKind.creditCards ? cardsSummary : fixedSummary,
            ),
        },
      ),
    ],
    verify: (_) => verify(() => getSummary(any())).called(5),
  );

  blocTest<ExpensesHubBloc, ExpensesHubState>(
    'keeps the other totals when one list fails',
    setUp: () => when(() => getSummary(ExpenseKind.loans))
        .thenAnswer((_) async => const Left(NetworkFailure('Offline'))),
    build: buildBloc,
    act: (bloc) => bloc.add(const ExpensesHubStarted()),
    skip: 4,
    expect: () => [
      isA<ExpensesHubState>()
          .having(
            (state) => state.statusOf(ExpenseKind.loans),
            'loans',
            const SummaryLoadFailure('Offline'),
          )
          .having(
            (state) => state.statusOf(ExpenseKind.savings),
            'savings',
            const SummaryLoaded(fixedSummary),
          ),
    ],
  );

  blocTest<ExpensesHubBloc, ExpensesHubState>(
    'retries only the list that failed',
    build: buildBloc,
    seed: () => const ExpensesHubState(
      statuses: {
        ExpenseKind.loans: SummaryLoadFailure('Offline'),
        ExpenseKind.savings: SummaryLoaded(cardsSummary),
      },
    ),
    act: (bloc) => bloc.add(const ExpenseSummaryRetried(ExpenseKind.loans)),
    expect: () => const [
      ExpensesHubState(
        statuses: {
          ExpenseKind.loans: SummaryLoading(),
          ExpenseKind.savings: SummaryLoaded(cardsSummary),
        },
      ),
      ExpensesHubState(
        statuses: {
          ExpenseKind.loans: SummaryLoaded(fixedSummary),
          ExpenseKind.savings: SummaryLoaded(cardsSummary),
        },
      ),
    ],
    verify: (_) => verify(() => getSummary(ExpenseKind.loans)).called(1),
  );
}
