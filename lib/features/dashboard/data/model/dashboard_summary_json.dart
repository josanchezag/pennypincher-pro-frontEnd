import 'package:pennypincher_pro/core/network/api_envelope.dart';
import 'package:pennypincher_pro/core/time/api_date.dart';
import 'package:pennypincher_pro/core/time/calendar_month.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/dashboard/domain/entity/dashboard_summary_entity.dart';

/// Keys of the dashboard summary JSON. Fields the dashboard does not show
/// (the expense totals, goal levels and dates, the email) are not read.
abstract final class DashboardJsonKeys {
  static const String referenceMonth = 'referenceMonth';
  static const String netWorth = 'netWorth';
  static const String current = 'current';
  static const String totalAssets = 'totalAssets';
  static const String totalLiabilities = 'totalLiabilities';
  static const String previousMonth = 'previousMonth';
  static const String previousMonthDate = 'previousMonthDate';
  static const String delta = 'delta';
  static const String deltaPercentage = 'deltaPercentage';
  static const String budget = 'currentMonthBudget';
  static const String year = 'year';
  static const String month = 'month';
  static const String exists = 'exists';
  static const String totalIncome = 'totalIncome';
  static const String totalExpenses = 'totalExpenses';
  static const String monthlyCashFlow = 'monthlyCashFlow';
  static const String cashFlowPercentage = 'cashFlowPercentage';
  static const String goals = 'goalsSummary';
  static const String goalId = 'goalId';
  static const String name = 'name';
  static const String progressPercentage = 'progressPercentage';
  static const String snapshots = 'recentNetWorthSnapshots';
  static const String snapshotDate = 'snapshotDate';
  static const String user = 'userProfile';
  static const String pictureUrl = 'pictureUrl';
}

/// Reads `GET /dashboard/summary` as the API sends it. Throws [TypeError]
/// or [FormatException] on an unexpected shape.
abstract final class DashboardSummaryJson {
  static DashboardSummary fromJson(JsonMap json) => DashboardSummary(
        referenceMonth: CalendarMonth.of(
          ApiDate.parse(json[DashboardJsonKeys.referenceMonth] as String),
        ),
        netWorth: _netWorth(_map(json[DashboardJsonKeys.netWorth])),
        budget: _budget(_map(json[DashboardJsonKeys.budget])),
        goals: [
          for (final goal in json[DashboardJsonKeys.goals] as List)
            _goal(_map(goal)),
        ],
        recentSnapshots: [
          for (final point in json[DashboardJsonKeys.snapshots] as List)
            _point(_map(point)),
        ],
        user: _user(_map(json[DashboardJsonKeys.user])),
      );

  static NetWorthOverview _netWorth(JsonMap json) => NetWorthOverview(
        current: Money.fromJson(json[DashboardJsonKeys.current]),
        totalAssets: Money.fromJson(json[DashboardJsonKeys.totalAssets]),
        totalLiabilities:
            Money.fromJson(json[DashboardJsonKeys.totalLiabilities]),
        change: json[DashboardJsonKeys.previousMonth] == null
            ? null
            : _change(json),
      );

  static NetWorthChange _change(JsonMap json) => NetWorthChange(
        previous: Money.fromJson(json[DashboardJsonKeys.previousMonth]),
        previousDate:
            ApiDate.parse(json[DashboardJsonKeys.previousMonthDate] as String),
        delta: Money.fromJson(json[DashboardJsonKeys.delta]),
        percentage: _optionalDouble(json[DashboardJsonKeys.deltaPercentage]),
      );

  static MonthBudgetOverview _budget(JsonMap json) => MonthBudgetOverview(
        month: DateTime(
          json[DashboardJsonKeys.year] as int,
          json[DashboardJsonKeys.month] as int,
        ),
        figures: json[DashboardJsonKeys.exists] as bool ? _figures(json) : null,
      );

  static BudgetFigures _figures(JsonMap json) => BudgetFigures(
        totalIncome: Money.fromJson(json[DashboardJsonKeys.totalIncome]),
        totalExpenses: Money.fromJson(json[DashboardJsonKeys.totalExpenses]),
        monthlyCashFlow:
            Money.fromJson(json[DashboardJsonKeys.monthlyCashFlow]),
        cashFlowPercentage:
            (json[DashboardJsonKeys.cashFlowPercentage] as num).toDouble(),
      );

  static GoalSummary _goal(JsonMap json) => GoalSummary(
        goalId: json[DashboardJsonKeys.goalId] as String,
        name: json[DashboardJsonKeys.name] as String,
        progressPercentage:
            (json[DashboardJsonKeys.progressPercentage] as num).toDouble(),
      );

  static NetWorthPoint _point(JsonMap json) => NetWorthPoint(
        date: ApiDate.parse(json[DashboardJsonKeys.snapshotDate] as String),
        netWorth: Money.fromJson(json[DashboardJsonKeys.netWorth]),
      );

  static UserProfile _user(JsonMap json) => UserProfile(
        name: json[DashboardJsonKeys.name] as String,
        pictureUrl: json[DashboardJsonKeys.pictureUrl] as String?,
      );

  static JsonMap _map(Object? json) => Map<String, dynamic>.from(json as Map);

  static double? _optionalDouble(Object? json) => (json as num?)?.toDouble();
}
