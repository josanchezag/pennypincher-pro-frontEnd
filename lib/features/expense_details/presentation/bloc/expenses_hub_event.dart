part of 'expenses_hub_bloc.dart';

/// Inputs of the [ExpensesHubBloc].
sealed class ExpensesHubEvent extends Equatable {
  const ExpensesHubEvent();

  @override
  List<Object?> get props => const [];
}

/// The hub opened: load the totals of every list.
final class ExpensesHubStarted extends ExpensesHubEvent {
  const ExpensesHubStarted();
}

/// Load again the totals of [kind] after they failed.
final class ExpenseSummaryRetried extends ExpensesHubEvent {
  const ExpenseSummaryRetried(this.kind);

  final ExpenseKind kind;

  @override
  List<Object?> get props => [kind];
}
