import 'dart:math' as math;

import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_level.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/reference_return.dart';

/// The formulas of the income based goals, identical to the backend's
/// (EPIC-015), for the live preview of the goal form. The backend stays
/// the source of truth: a saved goal shows the values it answers with.
///
/// Amounts are rounded to the cent, half up.
abstract final class GoalIncomePlan {
  /// The reference rate of return: 10 % effective annual.
  static const double referenceAnnualRate = 0.10;

  /// Years to reach a goal of an income mode when none is given.
  static const int defaultTargetYears = 16;

  static const int monthsPerYear = 12;

  /// Monthly rate equivalent to [referenceAnnualRate]:
  /// `1.10^(1/12) − 1`, about 0.7974 %.
  static final double referenceMonthlyRate = monthlyRate(referenceAnnualRate);

  /// Monthly rate compounding to [annualRate] in a year:
  /// `(1 + annualRate)^(1/12) − 1`.
  static double monthlyRate(double annualRate) =>
      math.pow(1 + annualRate, 1 / monthsPerYear) - 1;

  /// Times the current monthly income that a goal of [level] aims to earn
  /// in the current income mode. Same values as the backend.
  static double incomeFactorOf(GoalLevel level) => switch (level) {
        GoalLevel.financialSecurity => 0.6,
        GoalLevel.financialIndependence => 1,
        GoalLevel.financialFreedom => 2,
        GoalLevel.absoluteFreedom => 4,
      };

  /// [monthlyIncome] times [factor].
  static Money desiredIncomeOf(Money monthlyIncome, double factor) =>
      _money(monthlyIncome.cents * factor);

  /// The capital that, yielding [referenceAnnualRate], pays
  /// [desiredMonthlyIncome] every month without being consumed:
  /// `desiredMonthlyIncome / r_ref`.
  static Money targetFor(Money desiredMonthlyIncome) =>
      _money(desiredMonthlyIncome.cents / referenceMonthlyRate);

  /// Investment at the end of every month that grows [currentNetWorth]
  /// into [target] in [targetYears] at [annualReturn]:
  /// `max(0, (target − PV·(1+r)^n) · r / ((1+r)^n − 1))`, with
  /// `n = targetYears × 12` and `r` the [monthlyRate] of [annualReturn].
  static Money requiredMonthlyInvestment({
    required Money target,
    required Money currentNetWorth,
    required double annualReturn,
    required int targetYears,
  }) {
    final months = targetYears * monthsPerYear;
    final rate = monthlyRate(annualReturn);
    final missing = rate == 0
        ? (target.cents - currentNetWorth.cents) / months
        : _annuity(target, currentNetWorth, rate, months);
    return missing <= 0 ? Money.zero : _money(missing);
  }

  static double _annuity(Money target, Money present, double rate, int n) {
    final growth = math.pow(1 + rate, n).toDouble();
    return (target.cents - present.cents * growth) * rate / (growth - 1);
  }

  /// What [target] yields at [referenceAnnualRate]: `target × 0.10` a year
  /// and `target × r_ref` a month.
  static ReferenceReturn referenceReturnOf(Money target) => ReferenceReturn(
        annualRate: referenceAnnualRate,
        annualAmount: _money(target.cents * referenceAnnualRate),
        monthlyAmount: _money(target.cents * referenceMonthlyRate),
      );

  /// Amount of [cents], rounded half up.
  static Money _money(double cents) => Money.fromCents(cents.round());
}
