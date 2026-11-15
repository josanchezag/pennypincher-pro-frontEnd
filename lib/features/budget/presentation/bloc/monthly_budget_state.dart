part of 'monthly_budget_bloc.dart';

/// Progress of loading the month shown.
enum BudgetLoadStatus { loading, loaded, failure }

/// Changes made to the budget shown: by the user, or [syncExchangeRate]
/// when the app saves today's TRM in the current month's budget itself.
enum BudgetAction { create, update, recalculate, syncExchangeRate }

/// How the TRM of the month shown is kept.
enum ExchangeRateMode {
  /// A past or future month: the stored TRM, edited by hand.
  manual,

  /// The current month while today's rates are being fetched.
  pending,

  /// The current month with today's TRM, saved automatically.
  automatic,

  /// The current month, but today's TRM could not be fetched or is not
  /// today's: nothing is overwritten and the TRM is edited by hand.
  unavailable,

  /// The current month, but saving today's TRM failed: it is edited by
  /// hand.
  saveFailed;

  /// Whether the user edits the TRM.
  bool get isEditable => this != pending && this != automatic;
}

/// State of the budget overview for [month] (its first day).
///
/// Once [status] is loaded, [budget] is the month's budget or `null` when
/// it has none. [incomeSources] are the current income sources, or `null`
/// with [incomeError] when they could not be loaded. While [runningAction]
/// is set a change is being saved; [finishedAction] and [actionError]
/// report the change that just ended, for one state only, and
/// [alreadyExisted] tells that a create found the month's budget already
/// created elsewhere (for example in another tab) and loaded it instead.
///
/// [currentMonth] is the month of the local clock at the last load, or
/// `null` before the first one. [todayRates] are today's exchange rates
/// once fetched, with [todayRatesFailed] when they could not be;
/// [exchangeRateSyncFailed] tells that saving today's TRM failed.
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
    this.currentMonth,
    this.todayRates,
    this.todayRatesFailed = false,
    this.exchangeRateSyncFailed = false,
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
  final DateTime? currentMonth;
  final TodayExchangeRates? todayRates;
  final bool todayRatesFailed;
  final bool exchangeRateSyncFailed;

  bool get isBusy => runningAction != null;

  /// The month is loaded, has no budget and nothing else is running.
  bool get canCreate =>
      status == BudgetLoadStatus.loaded && budget == null && !isBusy;

  bool get isCurrentMonth => month == currentMonth;

  /// How the TRM of the month shown is kept.
  ExchangeRateMode get exchangeRateMode {
    final rates = todayRates;
    if (!isCurrentMonth) {
      return ExchangeRateMode.manual;
    }
    if (todayRatesFailed) {
      return ExchangeRateMode.unavailable;
    }
    if (rates == null) {
      return ExchangeRateMode.pending;
    }
    if (!rates.hasFreshUsdCop) {
      return ExchangeRateMode.unavailable;
    }
    final saved = budget?.settings.exchangeRate == rates.usdCop;
    return exchangeRateSyncFailed && !saved
        ? ExchangeRateMode.saveFailed
        : ExchangeRateMode.automatic;
  }

  /// Today's EUR/COP close, shown in the current month only.
  Money? get eurCop => isCurrentMonth ? todayRates?.eurCop : null;

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
    DateTime? currentMonth,
    TodayExchangeRates? todayRates,
    bool? todayRatesFailed,
    bool? exchangeRateSyncFailed,
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
        currentMonth: currentMonth ?? this.currentMonth,
        todayRates: todayRates ?? this.todayRates,
        todayRatesFailed: todayRatesFailed ?? this.todayRatesFailed,
        exchangeRateSyncFailed:
            exchangeRateSyncFailed ?? this.exchangeRateSyncFailed,
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
        currentMonth,
        todayRates,
        todayRatesFailed,
        exchangeRateSyncFailed,
      ];
}
