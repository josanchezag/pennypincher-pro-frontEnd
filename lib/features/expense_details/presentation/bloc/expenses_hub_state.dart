part of 'expenses_hub_bloc.dart';

/// Loading state of the totals of one expense list.
sealed class SummaryStatus extends Equatable {
  const SummaryStatus();

  @override
  List<Object?> get props => const [];
}

final class SummaryLoading extends SummaryStatus {
  const SummaryLoading();
}

/// The totals could not be loaded; they can be retried.
final class SummaryLoadFailure extends SummaryStatus {
  const SummaryLoadFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class SummaryLoaded extends SummaryStatus {
  const SummaryLoaded(this.summary);

  final ExpenseSummary summary;

  @override
  List<Object?> get props => [summary];
}

/// The totals of every expense list; a list missing from [statuses] is
/// still loading.
final class ExpensesHubState extends Equatable {
  const ExpensesHubState({this.statuses = const {}});

  final Map<ExpenseKind, SummaryStatus> statuses;

  SummaryStatus statusOf(ExpenseKind kind) =>
      statuses[kind] ?? const SummaryLoading();

  ExpensesHubState withStatus(ExpenseKind kind, SummaryStatus status) =>
      ExpensesHubState(statuses: {...statuses, kind: status});

  @override
  List<Object?> get props => [statuses];
}
