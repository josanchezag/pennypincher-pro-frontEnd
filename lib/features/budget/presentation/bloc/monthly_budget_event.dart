part of 'monthly_budget_bloc.dart';

/// Inputs of [MonthlyBudgetBloc].
sealed class MonthlyBudgetEvent extends Equatable {
  const MonthlyBudgetEvent();

  @override
  List<Object?> get props => const [];
}

/// The screen opened: load the current month and the income sources.
final class MonthlyBudgetStarted extends MonthlyBudgetEvent {
  const MonthlyBudgetStarted();
}

/// Load (or reload after an error) the month shown and the income sources.
final class MonthlyBudgetReloadRequested extends MonthlyBudgetEvent {
  const MonthlyBudgetReloadRequested();
}

/// Load the income sources again after they failed.
final class MonthlyBudgetIncomeReloadRequested extends MonthlyBudgetEvent {
  const MonthlyBudgetIncomeReloadRequested();
}

/// Show the budget of the month of [month].
final class MonthlyBudgetMonthChanged extends MonthlyBudgetEvent {
  const MonthlyBudgetMonthChanged(this.month);

  final DateTime month;

  @override
  List<Object?> get props => [month];
}

/// Create the budget of the month shown.
final class MonthlyBudgetCreateRequested extends MonthlyBudgetEvent {
  const MonthlyBudgetCreateRequested();
}

/// Save new [settings] for the budget shown.
final class MonthlyBudgetSettingsChanged extends MonthlyBudgetEvent {
  const MonthlyBudgetSettingsChanged(this.settings);

  final BudgetSettings settings;

  @override
  List<Object?> get props => [settings];
}

/// Recalculate the budget shown from the current income and expenses
/// (already confirmed by the user).
final class MonthlyBudgetRecalculateRequested extends MonthlyBudgetEvent {
  const MonthlyBudgetRecalculateRequested();
}
