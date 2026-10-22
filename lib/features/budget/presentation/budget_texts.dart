import 'package:pennypincher_pro/features/budget/domain/entity/monthly_budget_entity.dart';

/// Texts of the budget overview.
abstract final class BudgetTexts {
  static const String loadingLabel = 'Loading budget';
  static const String loadErrorTitle = 'Could not load the budget';
  static const String retry = 'Retry';

  static const String noBudgetTitlePrefix = 'No budget for';
  static const String noBudgetMessage =
      "Create a budget to calculate this month's income, expenses and cash "
      'flow from your current income sources and expenses.';
  static const String createBudget = 'Create Budget';

  static const String totalIncome = 'Total income';
  static const String totalExpenses = 'Total expenses';
  static const String cashFlow = 'Cash flow';

  static const String breakdownTitle = 'Where your income goes';
  static const String ofIncome = 'of income';
  static const String idealPrefix = 'ideal';
  static const String noIdeal = 'no target';
  static const String onTarget = 'within target';
  static const String slightlyOver = 'slightly over target';
  static const String over = 'over target';
  static const String slightlyUnder = 'slightly under target';
  static const String under = 'under target';
  static const int _tolerance = BudgetLimits.targetTolerancePercent;
  static const String legend = 'Each row shows the share of your income and '
      'then the ideal share. Credit cards: green at or below the ideal, amber '
      'up to $_tolerance% above it, red further above. Savings and charity: '
      'green at or above the ideal, amber down to $_tolerance% below it, red '
      'further below.';

  static const String detailsTitle = 'Month details';
  static const String exchangeRate = 'TRM (USD/COP)';
  static const String workDays = 'Work days';
  static const String notSet = 'Not set';
  static const String editPrefix = 'Edit';
  static const String save = 'Save';
  static const String cancel = 'Cancel';
  static const String clearHint = 'Leave empty to clear it.';
  static const String exchangeRateInvalid =
      'Enter a rate greater than zero, like 3.950 or 3.950,25.';
  static const String workDaysInvalid =
      'Enter a whole number from 0 to ${BudgetLimits.maxWorkDays}.';

  static const String incomeTitle = 'Income sources';
  static const String incomeNote = 'This budget uses your income and '
      'expenses as of its last calculation. Recalculate it after changing '
      'them.';
  static const String incomeChanged =
      'Your current income differs from this budget.';
  static const String noIncome = 'You have no income sources yet.';
  static const String currentTotal = 'Current total';
  static const String manageIncome = 'Manage';
  static const String recalculate = 'Recalculate';
  static const String recalculateTitlePrefix = 'Recalculate';
  static const String recalculateMessage = 'The budget will be updated with '
      'your current income sources and expenses.';

  static const String createdPrefix = 'Budget created for';
  static const String existingPrefix = 'Budget for';
  static const String existingSuffix = 'already existed and was loaded';
  static const String updated = 'Budget updated';
  static const String recalculated = 'Budget recalculated';

  static const Map<BudgetComponentType, String> componentLabels = {
    BudgetComponentType.creditCards: 'Credit cards',
    BudgetComponentType.loans: 'Loans',
    BudgetComponentType.monthlyExpenses: 'Monthly expenses',
    BudgetComponentType.savings: 'Savings',
    BudgetComponentType.charity: 'Charity',
  };
}
