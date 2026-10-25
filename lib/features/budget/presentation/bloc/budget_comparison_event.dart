part of 'budget_comparison_bloc.dart';

/// Inputs of [BudgetComparisonBloc].
sealed class BudgetComparisonEvent extends Equatable {
  const BudgetComparisonEvent();

  @override
  List<Object?> get props => const [];
}

/// Load (or reload after an error) the comparison.
final class BudgetComparisonLoadRequested extends BudgetComparisonEvent {
  const BudgetComparisonLoadRequested();
}
