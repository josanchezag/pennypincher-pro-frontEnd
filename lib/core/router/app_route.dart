/// Every screen of the application with its URL path and title.
///
/// Paths are absolute so deep links map one-to-one to screens. Navigate
/// with `context.goNamed(AppRoute.x.name)`.
enum AppRoute {
  splash('/', 'PennyPincher Pro'),
  login('/login', 'Sign in'),
  dashboard('/dashboard', 'Dashboard'),
  netWorth('/net-worth', 'Net Worth'),
  netWorthAssets('/net-worth/assets', 'Assets'),
  netWorthLiabilities('/net-worth/liabilities', 'Liabilities'),
  netWorthReport('/net-worth/report', 'Net Worth Report'),
  budget('/budget', 'Budget'),
  budgetOverview('/budget/overview', 'Budget Overview'),
  budgetIncome('/budget/income', 'Income Sources'),
  budgetComparison('/budget/comparison', 'Budget Comparison'),
  expenses('/expenses', 'Expenses'),
  expensesCreditCards('/expenses/credit-cards', 'Credit Cards'),
  expensesLoans('/expenses/loans', 'Loans'),
  expensesFixed('/expenses/fixed', 'Fixed Expenses'),
  expensesVariable('/expenses/variable', 'Variable Expenses'),
  expensesSavings('/expenses/savings', 'Savings'),
  goals('/goals', 'Goals'),
  goalProjection('/goals/:$goalIdParam/projection', 'Goal Projection'),
  settings('/settings', 'Settings'),
  settingsProfile('/settings/profile', 'Profile');

  const AppRoute(this.path, this.title);

  /// Path parameter that identifies a financial goal.
  static const String goalIdParam = 'goalId';

  final String path;
  final String title;

  /// Routes rendered without the navigation shell.
  static const Set<AppRoute> standalone = {splash, login};

  /// Routes rendered inside the responsive navigation shell.
  static Iterable<AppRoute> get shellRoutes =>
      values.where((route) => !standalone.contains(route));

  /// Route whose path pattern matches [path] exactly, if any.
  static AppRoute? matching(String path) {
    final actual = _segments(path);
    for (final route in values) {
      if (_matches(_segments(route.path), actual)) {
        return route;
      }
    }
    return null;
  }

  static List<String> _segments(String path) =>
      path.startsWith('/') ? path.substring(1).split('/') : const [];

  static bool _matches(List<String> pattern, List<String> actual) {
    if (actual.isEmpty || pattern.length != actual.length) {
      return false;
    }
    for (var index = 0; index < pattern.length; index++) {
      final expected = pattern[index];
      final isParam = expected.startsWith(':') && actual[index].isNotEmpty;
      if (!isParam && expected != actual[index]) {
        return false;
      }
    }
    return true;
  }
}
