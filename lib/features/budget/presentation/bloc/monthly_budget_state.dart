part of 'monthly_budget_bloc.dart';

/// Progress of loading the month shown.
enum BudgetLoadStatus { loading, loaded, failure }

/// Changes the user can make to the budget shown.
enum BudgetAction { create, update, recalculate }

/// State of the budget overview for [month] (its first day).
///
/// Once [status] is loaded, [budget] is the month's budget or `null` when
/// it has none. [incomeSources] are the current income sources, or `null`
/// with [incomeError] when they could not be loaded. While [runningAction]
/// is set a change is being saved; [finishedAction] and [actionError]
/// report the change that just ended, for one state only, and
/// [alreadyExisted] tells that a create found the month's budget already
/// created elsewhere (for example in another tab) and loaded it instead.
final class MonthlyBudgetState extends Equatable {
  const MonthlyBudgetState({
    required this.month,
    this.status = BudgetLoadStatus.loading,
    this.budget,
    this.loadError,
    this.incomeSources,
    this.incomeError,
    this.runningAction,
    this.finishedAction,
    this.actionError,
    this.alreadyExisted = false,
  });

  final DateTime month;
  final BudgetLoadStatus status;
  final MonthlyBudget? budget;
  final String? loadError;
  final List<IncomeSource>? incomeSources;
  final String? incomeError;
  final BudgetAction? runningAction;
  final BudgetAction? finishedAction;
  final String? actionError;
  final bool alreadyExisted;

  bool get isBusy => runningAction != null;

  /// The month is loaded, has no budget and nothing else is running.
  bool get canCreate =>
      status == BudgetLoadStatus.loaded && budget == null && !isBusy;

  /// A copy without the report of a finished change.
  MonthlyBudgetState copyWith({
    DateTime? month,
    BudgetLoadStatus? status,
    MonthlyBudget? Function()? budget,
    String? Function()? loadError,
    List<IncomeSource>? Function()? incomeSources,
    String? Function()? incomeError,
    BudgetAction? Function()? runningAction,
    BudgetAction? finishedAction,
    String? actionError,
    bool alreadyExisted = false,
  }) =>
      MonthlyBudgetState(
        month: month ?? this.month,
        status: status ?? this.status,
        budget: budget == null ? this.budget : budget(),
        loadError: loadError == null ? this.loadError : loadError(),
        incomeSources:
            incomeSources == null ? this.incomeSources : incomeSources(),
        incomeError: incomeError == null ? this.incomeError : incomeError(),
        runningAction:
            runningAction == null ? this.runningAction : runningAction(),
        finishedAction: finishedAction,
        actionError: actionError,
        alreadyExisted: alreadyExisted,
      );

  @override
  List<Object?> get props => [
        month,
        status,
        budget,
        loadError,
        incomeSources,
        incomeError,
        runningAction,
        finishedAction,
        actionError,
        alreadyExisted,
      ];
}
