import 'package:pennypincher_pro/features/dashboard/domain/entity/part_of_day.dart';

/// Texts of the dashboard.
abstract final class DashboardTexts {
  static String greeting(PartOfDay period) => switch (period) {
        PartOfDay.morning => 'Good morning',
        PartOfDay.afternoon => 'Good afternoon',
        PartOfDay.evening => 'Good evening',
      };

  static const String overviewPrefix = 'Your financial overview for';
  static const String refresh = 'Refresh';
  static const String loadingLabel = 'Loading dashboard';
  static const String loadErrorTitle = 'Could not load your dashboard';
  static const String retry = 'Retry';
  static const String refreshFailedPrefix = 'Could not refresh:';

  static const String netWorth = 'Net worth';
  static const String totalAssets = 'Total assets';
  static const String totalLiabilities = 'Total liabilities';
  static const String versus = 'vs';
  static const String noPreviousSnapshot = 'No previous snapshot';
  static const String sparklineLabel = 'Net worth of the last months';
  static const String inMonth = 'in';
  static const String sparklineHint =
      'Record a snapshot in two different months to see your trend here.';

  static const String budgetTitle = "This month's budget";
  static const String titleSeparator = ' · ';
  static const String income = 'Income';
  static const String expenses = 'Expenses';
  static const String cashFlow = 'Cash flow';
  static const String ofIncome = 'of income';
  static const String createBudgetTitle = "Create this month's budget";
  static const String createBudgetMessage =
      'See your income, expenses and cash flow for';

  static const String goalsTitle = 'Financial goals';
  static const String firstGoalTitle = 'Set your first financial goal';
  static const String firstGoalMessage =
      'Choose the net worth you want to reach and follow your progress here.';

  static const String quickActionsTitle = 'Quick actions';
  static const String recordSnapshot = 'Record snapshot';
  static const String addExpense = 'Add expense';
  static const String netWorthReport = 'Net worth report';
  static const String budgetComparison = 'Budget comparison';
  static const String snapshotSavedPrefix = 'Snapshot saved for';

  static const String onboardingTitle = 'Start by adding your assets';
  static const String onboardingMessage =
      'Add what you own and what you owe to see your net worth. Then create '
      'a budget and set your financial goals.';
}
