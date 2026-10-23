import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/financial_goal_entity.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_level.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_projection_entity.dart';

/// Financial goals of the Excel with their projections against a net
/// worth of $ 423.282.773 in October 2026.

const Money netWorth = Money.fromPesos(423282773);

const String securityDescription =
    'Expenses covered for 6 months without income';

GoalProjection projection({
  required String goalId,
  required String name,
  required int target,
  GoalLevel level = GoalLevel.financialSecurity,
  required double percent,
  int monthly = 1470000,
  int? months,
  DateTime? date,
  Money current = netWorth,
}) =>
    GoalProjection(
      goalId: goalId,
      name: name,
      level: level,
      targetAmount: Money.fromPesos(target),
      currentNetWorth: current,
      progressAmount: current,
      progressPercentage: percent,
      remainingAmount: Money.fromPesos(target) - current,
      monthlyInvestment: Money.fromPesos(monthly),
      expectedAnnualReturn: 0.11,
      targetYears: 16,
      reachable: months != null,
      projectedMonthsToGoal: months,
      projectedYearsToGoal: months == null ? null : months / 12,
      projectedAchievementDate: date,
      dataPoints: [
        ProjectionPoint(
          month: 0,
          date: DateTime(2026, 10),
          projectedValue: current,
        ),
        ProjectionPoint(
          month: 1,
          date: DateTime(2026, 11),
          projectedValue: current + Money.fromPesos(monthly),
        ),
      ],
    );

final FinancialGoal security = FinancialGoal(
  id: 'g1',
  name: 'Seguridad Financiera',
  level: GoalLevel.financialSecurity,
  levelDescription: securityDescription,
  targetAmount: const Money.fromPesos(605000000),
  monthlyInvestment: const Money.fromPesos(1470000),
  expectedAnnualReturn: 0.11,
  targetYears: 16,
  projection: projection(
    goalId: 'g1',
    name: 'Seguridad Financiera',
    target: 605000000,
    percent: 69.97,
    months: 38,
    date: DateTime(2029, 12),
  ),
);

final FinancialGoal independence = FinancialGoal(
  id: 'g2',
  name: 'Independencia Financiera',
  level: GoalLevel.financialIndependence,
  levelDescription: 'Passive income covers all basic expenses',
  targetAmount: const Money.fromPesos(1016000000),
  monthlyInvestment: const Money.fromPesos(3040000),
  expectedAnnualReturn: 0.11,
  targetYears: 16,
  projection: projection(
    goalId: 'g2',
    level: GoalLevel.financialIndependence,
    name: 'Independencia Financiera',
    target: 1016000000,
    monthly: 3040000,
    percent: 41.66,
    months: 96,
    date: DateTime(2034, 10),
  ),
);

final FinancialGoal freedom = FinancialGoal(
  id: 'g3',
  name: 'Libertad Financiera',
  level: GoalLevel.financialFreedom,
  levelDescription: 'Passive income covers desired lifestyle',
  targetAmount: const Money.fromPesos(2066000000),
  monthlyInvestment: const Money.fromPesos(7000000),
  expectedAnnualReturn: 0.11,
  targetYears: 16,
  projection: projection(
    goalId: 'g3',
    level: GoalLevel.financialFreedom,
    name: 'Libertad Financiera',
    target: 2066000000,
    monthly: 7000000,
    percent: 20.49,
    months: 150,
    date: DateTime(2039, 4),
  ),
);

final FinancialGoal absolute = FinancialGoal(
  id: 'g4',
  name: 'Libertad Absoluta',
  level: GoalLevel.absoluteFreedom,
  levelDescription: 'Unlimited financial choices',
  targetAmount: const Money.fromPesos(4366000000),
  monthlyInvestment: const Money.fromPesos(15850000),
  expectedAnnualReturn: 0.115,
  projection: projection(
    goalId: 'g4',
    level: GoalLevel.absoluteFreedom,
    name: 'Libertad Absoluta',
    target: 4366000000,
    monthly: 15850000,
    percent: 9.69,
  ),
);

final List<FinancialGoal> excelGoals = [
  security,
  independence,
  freedom,
  absolute,
];

/// [goal] with its progress at [percent].
FinancialGoal withProgress(FinancialGoal goal, double percent) => goal.copyWith(
      projection: goal.projection!.copyWith(progressPercentage: percent),
    );

/// API JSON of [security] without its projection.
const Map<String, Object?> securityJson = {
  'id': 'g1',
  'name': 'Seguridad Financiera',
  'level': 'FINANCIAL_SECURITY',
  'levelDescription': securityDescription,
  'targetAmount': 605000000,
  'monthlyInvestment': 1470000.00,
  'expectedAnnualReturn': 0.1100,
  'targetYears': 16,
  'createdAt': '2026-10-23T10:00:00Z',
  'updatedAt': '2026-10-23T10:00:00Z',
};

/// API JSON of the projection of [security].
const Map<String, Object?> securityProjectionJson = {
  'goalId': 'g1',
  'name': 'Seguridad Financiera',
  'level': 'FINANCIAL_SECURITY',
  'targetAmount': 605000000.00,
  'currentNetWorth': 423282773.00,
  'progressAmount': 423282773.00,
  'progressPercentage': 69.97,
  'remainingAmount': 181717227.00,
  'monthlyInvestment': 1470000.00,
  'expectedAnnualReturn': 0.1100,
  'targetYears': 16,
  'reachable': true,
  'projectedMonthsToGoal': 38,
  'projectedYearsToGoal': 3.17,
  'projectedAchievementDate': '2029-12-01',
  'projectionDataPoints': [
    {'month': 0, 'date': '2026-10-01', 'projectedValue': 423282773.00},
    {'month': 1, 'date': '2026-11-01', 'projectedValue': 428040373.36},
  ],
};
