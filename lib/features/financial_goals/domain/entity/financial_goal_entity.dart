import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pennypincher_pro/core/crud/domain/crud_item.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_level.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_projection_entity.dart';

part 'financial_goal_entity.freezed.dart';

/// A financial milestone: the net worth to reach, what the user invests
/// toward it each month and the yearly return expected on it, plus its
/// live [projection] once loaded.
@freezed
class FinancialGoal with _$FinancialGoal implements CrudItem {
  const factory FinancialGoal({
    required String id,
    required String name,
    required GoalLevel level,
    required String levelDescription,
    required Money targetAmount,
    required Money monthlyInvestment,

    /// Fraction of one, such as `0.11` for 11 % a year.
    required double expectedAnnualReturn,

    /// Years the user wants to reach it in, when set.
    int? targetYears,

    /// Progress and projection against the current net worth; null until
    /// it is loaded.
    GoalProjection? projection,
  }) = _FinancialGoal;

  const FinancialGoal._();

  /// Share of the target already covered, from 0 to 100, when known.
  double? get progressPercentage => projection?.progressPercentage;
}

/// The editable fields of a [FinancialGoal], sent to create or update it.
final class GoalDraft extends Equatable {
  const GoalDraft({
    required this.name,
    required this.level,
    required this.targetAmount,
    required this.monthlyInvestment,
    required this.expectedAnnualReturn,
    this.targetYears,
  });

  /// Smallest and largest number of target years the backend accepts.
  static const int minTargetYears = 1;
  static const int maxTargetYears = 100;

  final String name;
  final GoalLevel level;
  final Money targetAmount;
  final Money monthlyInvestment;

  /// Fraction of one, above 0 and at most 1, with up to four decimals.
  final double expectedAnnualReturn;
  final int? targetYears;

  @override
  List<Object?> get props => [
        name,
        level,
        targetAmount,
        monthlyInvestment,
        expectedAnnualReturn,
        targetYears,
      ];
}
