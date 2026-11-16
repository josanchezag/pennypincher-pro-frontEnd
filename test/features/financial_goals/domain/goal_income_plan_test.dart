import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_income_mode.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_income_plan.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_level.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/reference_return.dart';

/// Expected values computed by hand with 40 digit decimals from the
/// contract formulas, rounded half up to the cent; the required investment
/// is rounded up, as the backend does.
void main() {
  test('the reference monthly rate is the twelfth root of 1.10 minus one', () {
    expect(
      GoalIncomePlan.referenceMonthlyRate,
      closeTo(0.0079741404289, 1e-12),
    );
    expect(GoalIncomePlan.monthlyRate(0.11), closeTo(0.0087345938236, 1e-12));
  });

  test('the income factors keep the proportions of the Excel goals', () {
    expect(
      [
        for (final level in GoalLevel.values)
          GoalIncomePlan.incomeFactorOf(level),
      ],
      [0.6, 1, 2, 4],
    );
    expect(
      GoalIncomePlan.desiredIncomeOf(const Money.fromUnits(10000000), 0.6),
      const Money.fromUnits(6000000),
    );
  });

  final targets = {
    10000000: const Money.fromCents(125405366123),
    6000000: const Money.fromCents(75243219674),
    2500000: const Money.fromCents(31351341531),
  };
  for (final MapEntry(key: income, value: target) in targets.entries) {
    test('a desired income of $income needs a target of $target', () {
      expect(GoalIncomePlan.targetFor(Money.fromUnits(income)), target);
    });
  }

  test('the investment reaches the target from the current net worth', () {
    Money required(int pv, double rate, int years) =>
        GoalIncomePlan.requiredMonthlyInvestment(
          target: const Money.fromCents(125405366123),
          currentNetWorth: Money.fromUnits(pv),
          annualReturn: rate,
          targetYears: years,
        );

    expect(required(100000000, 0.10, 16), const Money.fromCents(176243439));
    expect(required(100000000, 0.11, 20), const Money.fromCents(55386225));
    // 100,000,000.000289 rounds up to the next cent.
    expect(required(0, 0.10, 1), const Money.fromCents(10000000001));
    // 2,781,662.0703 in the backend example.
    expect(required(0, 0.10, 16), const Money.fromCents(278166208));
  });

  test('the investment of a shorter, higher return plan', () {
    expect(
      GoalIncomePlan.requiredMonthlyInvestment(
        target: const Money.fromCents(75243219674),
        currentNetWorth: const Money.fromUnits(50000000),
        annualReturn: 0.12,
        targetYears: 10,
      ),
      const Money.fromCents(269066677),
    );
  });

  test('no investment is required once the net worth grows past the target',
      () {
    expect(
      GoalIncomePlan.requiredMonthlyInvestment(
        target: const Money.fromUnits(605000000),
        currentNetWorth: const Money.fromUnits(423282773),
        annualReturn: 0.11,
        targetYears: 16,
      ),
      Money.zero,
    );
  });

  test('the reference return is 10 % a year and r_ref a month', () {
    expect(
      GoalIncomePlan.referenceReturnOf(const Money.fromUnits(605000000)),
      const ReferenceReturn(
        annualRate: 0.10,
        annualAmount: Money.fromUnits(60500000),
        monthlyAmount: Money.fromCents(482435496),
      ),
    );
    expect(
      GoalIncomePlan.referenceReturnOf(const Money.fromCents(125405366123)),
      const ReferenceReturn(
        annualRate: 0.10,
        annualAmount: Money.fromCents(12540536612),
        monthlyAmount: Money.fromUnits(10000000),
      ),
    );
  });

  group('figures', () {
    test('of the current income: the income times the factor of the level', () {
      final figures = GoalIncomePlan.figures(
        mode: GoalIncomeMode.currentIncome,
        level: GoalLevel.financialIndependence,
        monthlyIncome: const Money.fromUnits(10000000),
        currentNetWorth: const Money.fromUnits(100000000),
        annualReturn: 0.10,
        targetYears: 16,
        manualTarget: const Money.fromUnits(1),
      );

      expect(
        figures,
        GoalPlanFigures(
          desiredMonthlyIncome: const Money.fromUnits(10000000),
          target: const Money.fromCents(125405366123),
          requiredMonthlyInvestment: const Money.fromCents(176243439),
          referenceReturn: GoalIncomePlan.referenceReturnOf(
            const Money.fromCents(125405366123),
          ),
        ),
      );
    });

    test('of a typed income', () {
      final figures = GoalIncomePlan.figures(
        mode: GoalIncomeMode.desiredIncome,
        level: GoalLevel.financialFreedom,
        monthlyIncome: const Money.fromUnits(10000000),
        typedDesiredIncome: const Money.fromUnits(6000000),
        currentNetWorth: const Money.fromUnits(50000000),
        annualReturn: 0.12,
        targetYears: 10,
      );

      expect(figures.desiredMonthlyIncome, const Money.fromUnits(6000000));
      expect(figures.target, const Money.fromCents(75243219674));
      expect(
        figures.requiredMonthlyInvestment,
        const Money.fromCents(269066677),
      );
    });

    test('of a manual goal: the typed target, no income', () {
      final figures = GoalIncomePlan.figures(
        mode: GoalIncomeMode.manual,
        level: GoalLevel.financialSecurity,
        monthlyIncome: const Money.fromUnits(10000000),
        manualTarget: const Money.fromUnits(605000000),
        currentNetWorth: const Money.fromUnits(423282773),
        annualReturn: 0.11,
      );

      expect(figures.desiredMonthlyIncome, isNull);
      expect(figures.target, const Money.fromUnits(605000000));
      expect(figures.requiredMonthlyInvestment, isNull);
      expect(
        figures.referenceReturn?.monthlyAmount,
        const Money.fromCents(482435496),
      );
    });

    test('are unknown while the income or the level is', () {
      expect(
        GoalIncomePlan.figures(mode: GoalIncomeMode.currentIncome),
        const GoalPlanFigures(),
      );
      expect(
        GoalIncomePlan.figures(
          mode: GoalIncomeMode.currentIncome,
          level: GoalLevel.financialSecurity,
          monthlyIncome: Money.zero,
        ).target,
        isNull,
      );
      expect(
        GoalIncomePlan.figures(
          mode: GoalIncomeMode.currentIncome,
          level: GoalLevel.financialSecurity,
          monthlyIncome: const Money.fromUnits(10000000),
          annualReturn: 0.10,
          targetYears: 16,
        ).requiredMonthlyInvestment,
        isNull,
      );
    });
  });
}
