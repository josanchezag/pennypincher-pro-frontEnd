import 'package:pennypincher_pro/features/financial_goals/domain/entity/financial_goal_entity.dart';

/// The moment a goal passes half of its target, celebrated once when a
/// reload shows it.
abstract final class HalfwayMilestone {
  static const double percent = 50;

  /// Ids of the goals of [current] that reached [percent] while their
  /// value in [previous] was below it. Goals that are new or had no
  /// progress before are left out.
  static Set<String> crossedBetween(
    List<FinancialGoal> previous,
    List<FinancialGoal> current,
  ) {
    final before = {
      for (final goal in previous)
        if (goal.progressPercentage case final progress?) goal.id: progress,
    };
    return {
      for (final goal in current)
        if (_crossed(before[goal.id], goal.progressPercentage)) goal.id,
    };
  }

  static bool _crossed(double? before, double? after) =>
      before != null && after != null && before < percent && after >= percent;
}
