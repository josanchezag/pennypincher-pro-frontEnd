import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/ant_expenses/domain/entity/ant_expense_entity.dart';
import 'package:pennypincher_pro/features/ant_expenses/domain/entity/ant_expense_report_entity.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/bloc/ant_insights_cubit.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/bloc/ant_section.dart';

/// The day the ant expense tests run on: Thursday, November 5, 2026.
final DateTime antToday = DateTime(2026, 11, 5);

const String octoberBudgetId = 'a1b2c3d4-0000-4000-8000-000000000010';

final AntExpense coffee = AntExpense(
  id: 'ae-1',
  amount: const Money.fromUnits(3500),
  category: AntExpenseCategory.coffeeAndDrinks,
  spentOn: DateTime(2026, 11, 5),
  description: 'Tinto en la oficina',
  createdAt: DateTime.utc(2026, 11, 5, 13),
);

final AntExpense taxi = AntExpense(
  id: 'ae-2',
  amount: const Money.fromUnits(14500),
  category: AntExpenseCategory.transport,
  spentOn: DateTime(2026, 11, 5),
  description: 'Taxi a casa',
  createdAt: DateTime.utc(2026, 11, 5, 23),
);

/// Without a description: named by its category.
final AntExpense empanadas = AntExpense(
  id: 'ae-3',
  amount: const Money.fromUnits(9000),
  category: AntExpenseCategory.fastFood,
  spentOn: DateTime(2026, 11, 4),
  createdAt: DateTime.utc(2026, 11, 4, 18),
);

/// Taken by the October cut.
final AntExpense octoberSnack = AntExpense(
  id: 'ae-9',
  amount: const Money.fromCents(250050),
  category: AntExpenseCategory.snacksAndSweets,
  spentOn: DateTime(2026, 10, 20),
  description: 'Galletas',
  open: false,
  budgetId: octoberBudgetId,
  createdAt: DateTime.utc(2026, 10, 20, 15),
);

final List<AntExpense> openExpenses = [taxi, coffee, empanadas];

const Map<String, Object?> coffeeJson = {
  'id': 'ae-1',
  'amount': 3500.00,
  'description': 'Tinto en la oficina',
  'category': 'COFFEE_AND_DRINKS',
  'spentOn': '2026-11-05',
  'open': true,
  'budgetId': null,
  'createdAt': '2026-11-05T13:00:00Z',
  'updatedAt': '2026-11-05T13:00:00Z',
};

const Map<String, Object?> octoberSnackJson = {
  'id': 'ae-9',
  'amount': 2500.50,
  'description': 'Galletas',
  'category': 'SNACKS_AND_SWEETS',
  'spentOn': '2026-10-20',
  'open': false,
  'budgetId': octoberBudgetId,
  'createdAt': '2026-10-20T15:00:00Z',
  'updatedAt': '2026-10-20T15:00:00Z',
};

final AntSummary antSummary = AntSummary(
  total: const Money.fromUnits(27000),
  count: 3,
  days: 6,
  dailyAverage: const Money.fromUnits(4500),
  periodStart: DateTime(2026, 10, 31),
  topCategory: AntExpenseCategory.transport,
  byCategory: const [
    AntCategoryShare(
      category: AntExpenseCategory.coffeeAndDrinks,
      total: Money.fromUnits(3500),
      count: 1,
      percentage: 12.96,
    ),
    AntCategoryShare(
      category: AntExpenseCategory.fastFood,
      total: Money.fromUnits(9000),
      count: 1,
      percentage: 33.33,
    ),
    AntCategoryShare(
      category: AntExpenseCategory.transport,
      total: Money.fromUnits(14500),
      count: 1,
      percentage: 53.70,
    ),
  ],
  lastCut: AntLastCut(
    budgetId: octoberBudgetId,
    month: DateTime(2026, 10),
    cutAt: DateTime.utc(2026, 10, 31, 22, 10),
  ),
  daysSinceLastCut: 5,
  limit: const AntLimitUsage(
    monthlyLimit: Money.fromUnits(150000),
    usedPercentage: 18,
    remaining: Money.fromUnits(123000),
  ),
);

const Map<String, Object?> antSummaryJson = {
  'total': 27000.00,
  'count': 3,
  'periodStart': '2026-10-31',
  'days': 6,
  'dailyAverage': 4500.00,
  'topCategory': 'TRANSPORT',
  'byCategory': [
    {
      'category': 'COFFEE_AND_DRINKS',
      'total': 3500.00,
      'count': 1,
      'percentage': 12.96,
    },
    {
      'category': 'FAST_FOOD',
      'total': 9000.00,
      'count': 1,
      'percentage': 33.33,
    },
    {
      'category': 'TRANSPORT',
      'total': 14500.00,
      'count': 1,
      'percentage': 53.7,
    },
  ],
  'lastCut': {
    'budgetId': octoberBudgetId,
    'year': 2026,
    'month': 10,
    'cutAt': '2026-10-31T22:10:00Z',
  },
  'daysSinceLastCut': 5,
  'limit': {
    'monthlyLimit': 150000.00,
    'usedPercentage': 18.00,
    'remaining': 123000,
  },
};

/// A user who never added an ant expense nor made a budget.
const Map<String, Object?> emptySummaryJson = {
  'total': 0.00,
  'count': 0,
  'periodStart': null,
  'days': 0,
  'dailyAverage': 0.00,
  'topCategory': null,
  'byCategory': <Object?>[],
  'lastCut': null,
  'daysSinceLastCut': null,
  'limit': null,
};

const AntSummary emptySummary = AntSummary(
  total: Money.zero,
  count: 0,
  days: 0,
  dailyAverage: Money.zero,
  byCategory: [],
);

final AntCut octoberCut = AntCut(
  budgetId: octoberBudgetId,
  month: DateTime(2026, 10),
  cutAt: DateTime.utc(2026, 10, 31, 22, 10),
  periodStart: DateTime(2026, 10),
  periodEnd: DateTime(2026, 10, 31),
  total: const Money.fromUnits(212000),
  count: 41,
  topCategory: AntExpenseCategory.fastFood,
  byCategory: const [
    AntCategoryShare(
      category: AntExpenseCategory.coffeeAndDrinks,
      total: Money.fromUnits(52000),
      count: 20,
      percentage: 24.53,
    ),
    AntCategoryShare(
      category: AntExpenseCategory.fastFood,
      total: Money.fromUnits(120000),
      count: 12,
      percentage: 56.60,
    ),
    AntCategoryShare(
      category: AntExpenseCategory.transport,
      total: Money.fromUnits(40000),
      count: 9,
      percentage: 18.87,
    ),
  ],
);

const Map<String, Object?> octoberCutJson = {
  'budgetId': octoberBudgetId,
  'year': 2026,
  'month': 10,
  'cutAt': '2026-10-31T22:10:00Z',
  'periodStart': '2026-10-01',
  'periodEnd': '2026-10-31',
  'total': 212000.00,
  'count': 41,
  'topCategory': 'FAST_FOOD',
  'byCategory': [
    {
      'category': 'COFFEE_AND_DRINKS',
      'total': 52000.00,
      'count': 20,
      'percentage': 24.53,
    },
    {
      'category': 'FAST_FOOD',
      'total': 120000.00,
      'count': 12,
      'percentage': 56.6,
    },
    {
      'category': 'TRANSPORT',
      'total': 40000.00,
      'count': 9,
      'percentage': 18.87,
    },
  ],
};

final List<AntTrendMonth> antTrend = [
  for (final (index, total)
      in [180500, 0, 150200, 160000, 212000, 27000].indexed)
    AntTrendMonth(
      month: DateTime(2026, 6 + index),
      total: Money.fromUnits(total),
      count: total == 0 ? 0 : 10 + index,
    ),
];

/// Every part of the screen loaded.
final AntInsightsState antInsightsLoaded = AntInsightsState(
  today: antToday,
  summary: AntSectionLoaded(antSummary),
  trend: AntSectionLoaded(antTrend),
  cuts: AntSectionLoaded([octoberCut]),
);
