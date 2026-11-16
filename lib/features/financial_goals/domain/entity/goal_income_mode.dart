/// Where the desired monthly income of a goal comes from, and with it its
/// target and monthly investment.
enum GoalIncomeMode {
  /// The user's current monthly income times the factor of the goal level;
  /// the backend reads the income again on every request.
  currentIncome,

  /// A monthly income the user typed.
  desiredIncome,

  /// The user sets the target and the monthly investment by hand, as every
  /// goal did before the income modes existed.
  manual;

  /// Whether the target and the investment derive from an income.
  bool get derivesFromIncome => this != manual;
}
