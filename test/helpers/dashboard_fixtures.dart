import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/dashboard/domain/entity/dashboard_summary_entity.dart';
import 'package:pennypincher_pro/features/dashboard/domain/entity/part_of_day.dart';
import 'package:pennypincher_pro/features/dashboard/presentation/bloc/dashboard_bloc.dart';

/// Dashboard of October 2026 with the figures of the Excel.

const Map<String, Object?> dashboardNetWorthJson = {
  'current': 423282773.00,
  'totalAssets': 707363354.00,
  'totalLiabilities': 284080581.00,
  'previousMonth': 418000000.00,
  'previousMonthDate': '2026-09-01',
  'delta': 5282773.00,
  'deltaPercentage': 1.26,
};

const Map<String, Object?> dashboardBudgetJson = {
  'year': 2026,
  'month': 10,
  'exists': true,
  'totalIncome': 37152922.36,
  'totalExpenses': 19135201.00,
  'monthlyCashFlow': 18017721.36,
  'cashFlowPercentage': 48.50,
};

const Map<String, Object?> dashboardJson = {
  'referenceMonth': '2026-10-01',
  'netWorth': dashboardNetWorthJson,
  'currentMonthBudget': dashboardBudgetJson,
  'expenseSummary': {
    'totalCreditCardPayments': 0.00,
    'totalLoanPayments': 3280231.00,
    'totalFixedExpenses': 13357550.00,
    'totalVariableExpenses': 2497420.00,
    'totalSavingsContributions': 0.00,
  },
  'goalsSummary': [
    {
      'goalId': 'g1',
      'name': 'Seguridad Financiera',
      'level': 'FINANCIAL_SECURITY',
      'progressPercentage': 69.96,
      'reachable': true,
      'projectedAchievementDate': '2029-05-01',
    },
  ],
  'recentNetWorthSnapshots': [
    {
      'snapshotDate': '2026-08-01',
      'totalAssets': 690000000.00,
      'totalLiabilities': 280000000.00,
      'netWorth': 410000000.00,
    },
    {
      'snapshotDate': '2026-09-01',
      'totalAssets': 700000000.00,
      'totalLiabilities': 282000000.00,
      'netWorth': 418000000.00,
    },
  ],
  'userProfile': {
    'name': 'Josimar Sanchez',
    'email': 'josimar@example.com',
    'pictureUrl': 'https://lh3.googleusercontent.com/a/josimar',
  },
};

/// What a brand-new user gets: zeros, nulls and empty lists.
const Map<String, Object?> newUserJson = {
  'referenceMonth': '2026-10-01',
  'netWorth': {
    'current': 0.00,
    'totalAssets': 0.00,
    'totalLiabilities': 0.00,
    'previousMonth': null,
    'previousMonthDate': null,
    'delta': null,
    'deltaPercentage': null,
  },
  'currentMonthBudget': {
    'year': 2026,
    'month': 10,
    'exists': false,
    'totalIncome': null,
    'totalExpenses': null,
    'monthlyCashFlow': null,
    'cashFlowPercentage': null,
  },
  'expenseSummary': {
    'totalCreditCardPayments': 0.00,
    'totalLoanPayments': 0.00,
    'totalFixedExpenses': 0.00,
    'totalVariableExpenses': 0.00,
    'totalSavingsContributions': 0.00,
  },
  'goalsSummary': <Object?>[],
  'recentNetWorthSnapshots': <Object?>[],
  'userProfile': {
    'name': 'Ada',
    'email': 'ada@example.com',
    'pictureUrl': null,
  },
};

final DashboardSummary dashboardSummary = DashboardSummary(
  referenceMonth: DateTime(2026, 10),
  netWorth: NetWorthOverview(
    current: const Money.fromPesos(423282773),
    totalAssets: const Money.fromPesos(707363354),
    totalLiabilities: const Money.fromPesos(284080581),
    change: NetWorthChange(
      previous: const Money.fromPesos(418000000),
      previousDate: DateTime(2026, 9),
      delta: const Money.fromPesos(5282773),
      percentage: 1.26,
    ),
  ),
  budget: MonthBudgetOverview(
    month: DateTime(2026, 10),
    figures: const BudgetFigures(
      totalIncome: Money.fromCents(3715292236),
      totalExpenses: Money.fromPesos(19135201),
      monthlyCashFlow: Money.fromCents(1801772136),
      cashFlowPercentage: 48.50,
    ),
  ),
  goals: const [
    GoalSummary(
      goalId: 'g1',
      name: 'Seguridad Financiera',
      progressPercentage: 69.96,
    ),
  ],
  recentSnapshots: [
    NetWorthPoint(
      date: DateTime(2026, 8),
      netWorth: const Money.fromPesos(410000000),
    ),
    NetWorthPoint(
      date: DateTime(2026, 9),
      netWorth: const Money.fromPesos(418000000),
    ),
  ],
  user: const UserProfile(
    name: 'Josimar Sanchez',
    pictureUrl: 'https://lh3.googleusercontent.com/a/josimar',
  ),
);

final DashboardSummary newUserSummary = DashboardSummary(
  referenceMonth: DateTime(2026, 10),
  netWorth: const NetWorthOverview(
    current: Money.zero,
    totalAssets: Money.zero,
    totalLiabilities: Money.zero,
  ),
  budget: MonthBudgetOverview(month: DateTime(2026, 10)),
  goals: const [],
  recentSnapshots: const [],
  user: const UserProfile(name: 'Ada'),
);

const List<GoalSummary> fourGoals = [
  GoalSummary(
    goalId: 'g1',
    name: 'Seguridad Financiera',
    progressPercentage: 69.96,
  ),
  GoalSummary(
    goalId: 'g2',
    name: 'Independencia Financiera',
    progressPercentage: 41.66,
  ),
  GoalSummary(
    goalId: 'g3',
    name: 'Libertad Financiera',
    progressPercentage: 20.49,
  ),
  GoalSummary(
    goalId: 'g4',
    name: 'Libertad Absoluta',
    progressPercentage: 9.69,
  ),
];

/// Loaded dashboard state of [summary] in the morning.
DashboardState loadedDashboard(
  DashboardSummary summary, {
  PartOfDay period = PartOfDay.morning,
  bool refreshing = false,
  bool recordingSnapshot = false,
  DashboardNotice? notice,
  String? noticeMessage,
}) =>
    DashboardState(
      period: period,
      status: DashboardStatus.loaded,
      summary: summary,
      refreshing: refreshing,
      recordingSnapshot: recordingSnapshot,
      notice: notice,
      noticeMessage: noticeMessage,
    );
