import 'package:equatable/equatable.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/financial_goal_entity.dart';

/// What the goal form previews a plan from: the user's current monthly
/// income (the sum of their income sources) and current net worth. Either
/// is null while it is unknown.
final class GoalPlanBasis extends Equatable {
  const GoalPlanBasis({this.monthlyIncome, this.currentNetWorth});

  /// The income and net worth the loaded [goals] carry: the income basis
  /// of a goal based on the income and the net worth of a projection.
  factory GoalPlanBasis.ofGoals(Iterable<FinancialGoal> goals) => GoalPlanBasis(
        monthlyIncome: _first(goals.map((goal) => goal.monthlyIncomeBasis)),
        currentNetWorth: _first(
          goals.map((goal) => goal.projection?.currentNetWorth),
        ),
      );

  static const GoalPlanBasis unknown = GoalPlanBasis();

  static Money? _first(Iterable<Money?> amounts) =>
      amounts.whereType<Money>().firstOrNull;

  final Money? monthlyIncome;
  final Money? currentNetWorth;

  /// This basis with the values it does not know taken from [other].
  GoalPlanBasis orElse(GoalPlanBasis other) => GoalPlanBasis(
        monthlyIncome: monthlyIncome ?? other.monthlyIncome,
        currentNetWorth: currentNetWorth ?? other.currentNetWorth,
      );

  @override
  List<Object?> get props => [monthlyIncome, currentNetWorth];
}
