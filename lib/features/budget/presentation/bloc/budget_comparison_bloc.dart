import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/time/calendar_month.dart';
import 'package:pennypincher_pro/core/time/clock.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/monthly_comparison_entity.dart';
import 'package:pennypincher_pro/features/budget/domain/usecase/monthly_budget_use_cases.dart';

part 'budget_comparison_event.dart';
part 'budget_comparison_state.dart';

/// State of the budget comparison: the last
/// [GetMonthlyComparison.defaultMonths] months up to the current month of
/// the device's local clock. A new instance is created per screen.
@injectable
class BudgetComparisonBloc
    extends Bloc<BudgetComparisonEvent, BudgetComparisonState> {
  BudgetComparisonBloc(this._getComparison, this._clock)
      : super(const BudgetComparisonState()) {
    on<BudgetComparisonLoadRequested>(_onLoad);
  }

  final GetMonthlyComparison _getComparison;
  final Clock _clock;

  Future<void> _onLoad(
    BudgetComparisonLoadRequested event,
    Emitter<BudgetComparisonState> emit,
  ) async {
    emit(const BudgetComparisonState());
    final result = await _getComparison(CalendarMonth.of(_clock.now()));
    emit(
      result.fold(
        (failure) => BudgetComparisonState(
          status: ComparisonStatus.failure,
          error: failure.message,
        ),
        (months) => BudgetComparisonState(
          status: ComparisonStatus.loaded,
          months: months,
        ),
      ),
    );
  }
}
