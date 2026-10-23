import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_projection_entity.dart';

/// Texts of the financial goals screens.
abstract final class GoalsTexts {
  static const String subtitle =
      'Your roadmap to financial independence, measured against your '
      'current net worth.';
  static const String loadingLabel = 'Loading goals';
  static const String loadErrorTitle = 'Could not load your goals';
  static const String retry = 'Retry';
  static const String addGoal = 'Add goal';
  static const String editGoal = 'Edit goal';
  static const String deleteGoal = 'Delete goal';
  static const String deleteTitle = 'Delete goal?';
  static const String deleteMessageSuffix =
      'will be removed for good, with its projection.';
  static const String delete = 'Delete';
  static const String emptyTitle = 'Start your financial roadmap';
  static const String firstGoal = 'Set your first financial goal';
  static const String emptyMessage =
      'Define the net worth you want to reach, invest toward it every month '
      'and see when you will get there.';
  static const String startWithStandard = 'Use the 4 standard goals';
  static const String target = 'Target';
  static const String currentNetWorth = 'Current net worth';
  static const String remaining = 'Remaining';
  static const String projectedDate = 'Projected date';
  static const String monthlyInvestment = 'Monthly investment';
  static const String returnRate = 'Return rate';
  static const String expectedAnnualReturn = 'Expected annual return';
  static const String targetYears = 'Target years';
  static const String level = 'Level';
  static const String levelRequired = 'Choose a level.';
  static const String progress = 'Progress';
  static const String projectionsUnavailable =
      'Progress and projected dates could not be loaded.';
  static const String goalReached = 'Goal reached';
  static const String notReachable =
      'Not reachable within ${GoalProjection.maxHorizonYears} years';
  static const String halfwayThere = 'Halfway there!';
  static const String percentSuffix = '%';
  static const String returnRequired = 'Enter the expected annual return.';
  static const String returnInvalid =
      'Enter a percentage above 0 and up to 100, like 11 or 11,5.';
  static const String returnHelper = 'Yearly, in percent. Example: 11 or 11,5';
  static const String targetYearsInvalid =
      'Enter a whole number from 1 to 100.';
  static const String targetYearsHelper = 'Optional. From 1 to 100';
  static const String yearsSuffix = 'years';
}
