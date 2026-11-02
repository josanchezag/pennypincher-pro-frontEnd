import 'package:pennypincher_pro/core/constants/app_constants.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';

/// Every screen of the application with its URL path and title.
///
/// Paths are absolute so deep links map one-to-one to screens. Navigate
/// with `context.goNamed(AppRoute.x.name)`.
enum AppRoute {
  splash('/'),
  login('/login'),
  dashboard('/dashboard'),
  netWorth('/net-worth'),
  netWorthAssets('/net-worth/assets'),
  netWorthLiabilities('/net-worth/liabilities'),
  netWorthReport('/net-worth/report'),
  budget('/budget'),
  budgetOverview('/budget/overview'),
  budgetIncome('/budget/income'),
  budgetComparison('/budget/comparison'),
  expenses('/expenses'),
  expensesCreditCards('/expenses/credit-cards'),
  expensesLoans('/expenses/loans'),
  expensesFixed('/expenses/fixed'),
  expensesVariable('/expenses/variable'),
  expensesSavings('/expenses/savings'),
  goals('/goals'),
  goalProjection('/goals/:$goalIdParam/projection'),
  settings('/settings'),
  settingsProfile('/settings/profile');

  const AppRoute(this.path);

  /// Path parameter that identifies a financial goal.
  static const String goalIdParam = 'goalId';

  final String path;

  /// Title of the screen in the language of [l10n].
  String title(AppLocalizations l10n) => switch (this) {
        splash => AppConstants.appName,
        login => l10n.routeLogin,
        dashboard => l10n.routeDashboard,
        netWorth => l10n.routeNetWorth,
        netWorthAssets => l10n.routeNetWorthAssets,
        netWorthLiabilities => l10n.routeNetWorthLiabilities,
        netWorthReport => l10n.routeNetWorthReport,
        budget => l10n.routeBudget,
        budgetOverview => l10n.routeBudgetOverview,
        budgetIncome => l10n.routeBudgetIncome,
        budgetComparison => l10n.routeBudgetComparison,
        expenses => l10n.routeExpenses,
        expensesCreditCards => l10n.routeExpensesCreditCards,
        expensesLoans => l10n.routeExpensesLoans,
        expensesFixed => l10n.routeExpensesFixed,
        expensesVariable => l10n.routeExpensesVariable,
        expensesSavings => l10n.routeExpensesSavings,
        goals => l10n.routeGoals,
        goalProjection => l10n.routeGoalProjection,
        settings => l10n.routeSettings,
        settingsProfile => l10n.routeSettingsProfile,
      };

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
