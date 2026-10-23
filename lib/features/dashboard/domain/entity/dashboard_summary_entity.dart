import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pennypincher_pro/core/utils/money.dart';

part 'dashboard_summary_entity.freezed.dart';

/// Everything the dashboard shows, loaded at once: the live net worth, the
/// budget of [referenceMonth], the goals, the net worth history of the
/// last months and the signed-in user.
@freezed
class DashboardSummary with _$DashboardSummary {
  const factory DashboardSummary({
    /// First day of the month the budget belongs to.
    required DateTime referenceMonth,
    required NetWorthOverview netWorth,
    required MonthBudgetOverview budget,
    required List<GoalSummary> goals,

    /// Up to the last 12 monthly snapshots, from the oldest.
    required List<NetWorthPoint> recentSnapshots,
    required UserProfile user,
  }) = _DashboardSummary;

  const DashboardSummary._();

  /// Months of history drawn by the sparkline.
  static const int sparklineMonths = 6;

  /// The user has not recorded anything yet: no assets or liabilities, no
  /// snapshots, no goals and no budget for the month.
  bool get isEmpty =>
      netWorth.totalAssets.isZero &&
      netWorth.totalLiabilities.isZero &&
      recentSnapshots.isEmpty &&
      goals.isEmpty &&
      !budget.exists;

  /// The latest [sparklineMonths] snapshots, from the oldest.
  List<NetWorthPoint> get sparkline => recentSnapshots.length > sparklineMonths
      ? recentSnapshots.sublist(recentSnapshots.length - sparklineMonths)
      : recentSnapshots;
}

/// Live net worth and its [change] since the latest snapshot before the
/// reference month, when there is one.
@freezed
class NetWorthOverview with _$NetWorthOverview {
  const factory NetWorthOverview({
    required Money current,
    required Money totalAssets,
    required Money totalLiabilities,
    NetWorthChange? change,
  }) = _NetWorthOverview;
}

/// Difference between the live net worth and the snapshot of
/// [previousDate]. [percentage] is in percent units and `null` when the
/// previous net worth was zero.
@freezed
class NetWorthChange with _$NetWorthChange {
  const factory NetWorthChange({
    required Money previous,
    required DateTime previousDate,
    required Money delta,
    double? percentage,
  }) = _NetWorthChange;
}

/// Budget of [month] (its first day); [figures] is `null` when the month
/// has no budget yet.
@freezed
class MonthBudgetOverview with _$MonthBudgetOverview {
  const factory MonthBudgetOverview({
    required DateTime month,
    BudgetFigures? figures,
  }) = _MonthBudgetOverview;

  const MonthBudgetOverview._();

  bool get exists => figures != null;
}

/// Totals of a stored budget. [cashFlowPercentage] is the cash flow as a
/// share of the income, in percent units.
@freezed
class BudgetFigures with _$BudgetFigures {
  const factory BudgetFigures({
    required Money totalIncome,
    required Money totalExpenses,
    required Money monthlyCashFlow,
    required double cashFlowPercentage,
  }) = _BudgetFigures;
}

/// Progress toward one goal, from 0 to 100 percent.
@freezed
class GoalSummary with _$GoalSummary {
  const factory GoalSummary({
    required String goalId,
    required String name,
    required double progressPercentage,
  }) = _GoalSummary;
}

/// Net worth of the snapshot of [date] (first day of its month).
@freezed
class NetWorthPoint with _$NetWorthPoint {
  const factory NetWorthPoint({
    required DateTime date,
    required Money netWorth,
  }) = _NetWorthPoint;
}

/// Name and Google picture of the signed-in user.
@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String name,
    String? pictureUrl,
  }) = _UserProfile;

  const UserProfile._();

  static final RegExp _whitespace = RegExp(r'\s+');

  List<String> get _words =>
      name.trim().split(_whitespace).where((w) => w.isNotEmpty).toList();

  /// First word of [name]: `Josimar` for `Josimar Sanchez`; empty when the
  /// name is blank.
  String get firstName => _words.isEmpty ? '' : _words.first;

  /// Upper-case initials of the first and last words: `JS`.
  String get initials {
    final words = _words;
    if (words.isEmpty) {
      return '';
    }
    final last = words.length > 1 ? _initial(words.last) : '';
    return '${_initial(words.first)}$last'.toUpperCase();
  }

  static String _initial(String word) => String.fromCharCode(word.runes.first);
}
