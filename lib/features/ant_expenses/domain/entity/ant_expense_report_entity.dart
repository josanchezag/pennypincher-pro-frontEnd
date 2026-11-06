import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/ant_expenses/domain/entity/ant_expense_entity.dart';

part 'ant_expense_report_entity.freezed.dart';

/// What one category adds up to within a period, with its [percentage] of
/// the period total in percent units.
@freezed
class AntCategoryShare with _$AntCategoryShare {
  const factory AntCategoryShare({
    required AntExpenseCategory category,
    required Money total,
    required int count,
    required double percentage,
  }) = _AntCategoryShare;
}

/// The latest budget cut: the budget of [month] and when it was last
/// calculated.
@freezed
class AntLastCut with _$AntLastCut {
  const factory AntLastCut({
    required String budgetId,

    /// First day of the month of the budget.
    required DateTime month,
    required DateTime cutAt,
  }) = _AntLastCut;
}

/// How much of the monthly soft limit the current period has used. Both
/// figures go past the limit: [usedPercentage] above 100 and [remaining]
/// below zero.
@freezed
class AntLimitUsage with _$AntLimitUsage {
  const factory AntLimitUsage({
    required Money monthlyLimit,
    required double usedPercentage,
    required Money remaining,
  }) = _AntLimitUsage;

  const AntLimitUsage._();

  bool get exceeded => remaining.isNegative;
}

/// The current period: the open ant expenses since the last cut.
@freezed
class AntSummary with _$AntSummary {
  const factory AntSummary({
    required Money total,
    required int count,

    /// Days from [periodStart] to today, both included; 0 without a start.
    required int days,
    required Money dailyAverage,

    /// Only the categories with expenses, in the order of
    /// [AntExpenseCategory.values].
    required List<AntCategoryShare> byCategory,
    DateTime? periodStart,
    AntExpenseCategory? topCategory,
    AntLastCut? lastCut,
    int? daysSinceLastCut,
    AntLimitUsage? limit,
  }) = _AntSummary;
}

/// One past cut: the ant expenses the budget of [month] took.
@freezed
class AntCut with _$AntCut {
  const factory AntCut({
    required String budgetId,

    /// First day of the month of the budget.
    required DateTime month,
    required DateTime cutAt,

    /// Oldest and newest purchase among the expenses of the cut.
    required DateTime periodStart,
    required DateTime periodEnd,
    required Money total,
    required int count,
    required List<AntCategoryShare> byCategory,
    AntExpenseCategory? topCategory,
  }) = _AntCut;
}

/// Spending on ant expenses in one calendar month of purchase.
@freezed
class AntTrendMonth with _$AntTrendMonth {
  const factory AntTrendMonth({
    /// First day of the month.
    required DateTime month,
    required Money total,
    required int count,
  }) = _AntTrendMonth;
}

/// Limits the backend accepts for ant expenses.
abstract final class AntExpenseLimits {
  static final DateTime firstDay = DateTime(2000);

  /// Months the trend can show.
  static const int shortTrendMonths = 6;
  static const int longTrendMonths = 12;
}
