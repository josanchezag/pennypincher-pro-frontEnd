import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/constants/app_constants.dart';
import 'package:pennypincher_pro/core/crud/domain/usecase/crud_use_cases.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/core/time/calendar_month.dart';
import 'package:pennypincher_pro/core/time/clock.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/income_source_entity.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/monthly_budget_entity.dart';
import 'package:pennypincher_pro/features/budget/domain/usecase/monthly_budget_use_cases.dart';

part 'monthly_budget_event.dart';
part 'monthly_budget_state.dart';

/// State of the budget overview. A new instance is created per screen and
/// opens on the current month. Results that arrive after the user moved to
/// another month are dropped, and changes run one at a time.
@injectable
class MonthlyBudgetBloc extends Bloc<MonthlyBudgetEvent, MonthlyBudgetState> {
  MonthlyBudgetBloc(
    this._getBudget,
    this._createBudget,
    this._updateBudget,
    this._recalculateBudget,
    this._getIncomeSources,
    Clock clock,
  ) : super(MonthlyBudgetState(month: CalendarMonth.of(clock.now()))) {
    on<MonthlyBudgetStarted>((_, emit) => _load(state.month, emit));
    on<MonthlyBudgetReloadRequested>((_, emit) => _load(state.month, emit));
    on<MonthlyBudgetIncomeReloadRequested>(_onIncomeReloadRequested);
    on<MonthlyBudgetMonthChanged>(_onMonthChanged);
    on<MonthlyBudgetCreateRequested>(_onCreateRequested);
    on<MonthlyBudgetSettingsChanged>(_onSettingsChanged);
    on<MonthlyBudgetRecalculateRequested>(_onRecalculateRequested);
  }

  final GetMonthlyBudget _getBudget;
  final CreateMonthlyBudget _createBudget;
  final UpdateMonthlyBudget _updateBudget;
  final RecalculateBudget _recalculateBudget;
  final GetItems<IncomeSource, IncomeCategory> _getIncomeSources;

  /// Loads the budget of [month] and the income sources in parallel. A
  /// failure of the income sources only affects their section, and they
  /// are kept even when the user already moved to another month.
  Future<void> _load(DateTime month, Emitter<MonthlyBudgetState> emit) async {
    _showLoading(month, emit);
    final incomeRequest = _getIncomeSources();
    final budget = await _getBudget(month);
    final income = await incomeRequest;
    final current = state.month == month ? _withBudget(budget) : state;
    emit(_withIncome(current, income));
  }

  Future<void> _onIncomeReloadRequested(
    MonthlyBudgetIncomeReloadRequested event,
    Emitter<MonthlyBudgetState> emit,
  ) async {
    if (state.incomeSources != null || state.incomeError == null) {
      return;
    }
    emit(state.copyWith(incomeError: () => null));
    emit(_withIncome(state, await _getIncomeSources()));
  }

  static MonthlyBudgetState _withIncome(
    MonthlyBudgetState current,
    Either<Failure, List<IncomeSource>> income,
  ) =>
      current.copyWith(
        incomeSources: () => income.fold((_) => null, (sources) => sources),
        incomeError: () =>
            income.fold((failure) => failure.message, (_) => null),
      );

  Future<void> _onMonthChanged(
    MonthlyBudgetMonthChanged event,
    Emitter<MonthlyBudgetState> emit,
  ) async {
    final month = CalendarMonth.of(event.month);
    if (state.isBusy || month == state.month) {
      return;
    }
    _showLoading(month, emit);
    final budget = await _getBudget(month);
    if (state.month == month) {
      emit(_withBudget(budget));
    }
  }

  void _showLoading(DateTime month, Emitter<MonthlyBudgetState> emit) => emit(
        state.copyWith(
          month: month,
          status: BudgetLoadStatus.loading,
          budget: () => null,
          loadError: () => null,
        ),
      );

  MonthlyBudgetState _withBudget(Either<Failure, MonthlyBudget?> result) =>
      result.fold(
        (failure) => state.copyWith(
          status: BudgetLoadStatus.failure,
          loadError: () => failure.message,
        ),
        (budget) => state.copyWith(
          status: BudgetLoadStatus.loaded,
          budget: () => budget,
        ),
      );

  Future<void> _onCreateRequested(
    MonthlyBudgetCreateRequested event,
    Emitter<MonthlyBudgetState> emit,
  ) async {
    if (state.canCreate) {
      final month = state.month;
      await _change(emit, BudgetAction.create, () => _createOrFind(month));
    }
  }

  /// Creates the budget of [month]. When another tab or device created it
  /// first (409), that budget is loaded and shown instead.
  Future<Either<Failure, _Outcome>> _createOrFind(DateTime month) async {
    final created = await _createBudget(month);
    if (!created.fold(_isConflict, (_) => false)) {
      return created.map(_changed);
    }
    final existing = await _getBudget(month);
    return existing.fold(
      (_) => created.map(_changed),
      (budget) => budget == null
          ? created.map(_changed)
          : Right((budget: budget, alreadyExisted: true)),
    );
  }

  static _Outcome _changed(MonthlyBudget budget) =>
      (budget: budget, alreadyExisted: false);

  static bool _isConflict(Failure failure) =>
      failure is ServerFailure && failure.code == ApiErrorCodes.conflict;

  Future<void> _onSettingsChanged(
    MonthlyBudgetSettingsChanged event,
    Emitter<MonthlyBudgetState> emit,
  ) =>
      _changeBudget(
        emit,
        BudgetAction.update,
        (id) => _updateBudget(id, event.settings),
      );

  Future<void> _onRecalculateRequested(
    MonthlyBudgetRecalculateRequested event,
    Emitter<MonthlyBudgetState> emit,
  ) =>
      _changeBudget(emit, BudgetAction.recalculate, _recalculateBudget.call);

  Future<void> _changeBudget(
    Emitter<MonthlyBudgetState> emit,
    BudgetAction action,
    Future<Either<Failure, MonthlyBudget>> Function(String id) request,
  ) async {
    final budget = state.budget;
    if (budget == null || state.isBusy) {
      return;
    }
    await _change(
      emit,
      action,
      () async => (await request(budget.id)).map(_changed),
    );
  }

  /// Runs [request] for the month shown and applies its result. The month
  /// cannot change meanwhile: navigation is ignored while a change runs.
  Future<void> _change(
    Emitter<MonthlyBudgetState> emit,
    BudgetAction action,
    Future<Either<Failure, _Outcome>> Function() request,
  ) async {
    emit(state.copyWith(runningAction: () => action));
    final result = await request();
    emit(
      result.fold(
        (failure) => state.copyWith(
          runningAction: () => null,
          finishedAction: action,
          actionError: failure.message,
        ),
        (outcome) => state.copyWith(
          budget: () => outcome.budget,
          runningAction: () => null,
          finishedAction: action,
          alreadyExisted: outcome.alreadyExisted,
        ),
      ),
    );
  }
}

/// Budget a change left on screen; [alreadyExisted] when a create found the
/// month's budget created elsewhere.
typedef _Outcome = ({MonthlyBudget budget, bool alreadyExisted});
