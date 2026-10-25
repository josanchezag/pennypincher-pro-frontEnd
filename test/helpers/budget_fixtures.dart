import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/income_source_entity.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/monthly_budget_entity.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/monthly_comparison_entity.dart';

const IncomeSource avenueCode = IncomeSource(
  id: 'i1',
  name: 'AvenueCode',
  amount: Money.fromCents(2415292236),
  category: IncomeCategory.employment,
);

const IncomeSource remoti = IncomeSource(
  id: 'i2',
  name: 'Remoti',
  amount: Money.fromPesos(9000000),
  category: IncomeCategory.employment,
);

const IncomeSource arriendoMadera = IncomeSource(
  id: 'i3',
  name: 'Arriendo Madera',
  amount: Money.fromPesos(4000000),
  category: IncomeCategory.rental,
);

const Map<String, Object?> avenueCodeJson = {
  'id': 'i1',
  'name': 'AvenueCode',
  'amount': 24152922.36,
  'category': 'EMPLOYMENT',
  'currency': 'COP',
  'createdAt': '2026-10-01T12:00:00Z',
  'updatedAt': '2026-10-01T12:00:00Z',
};

final MonthlyBudget octoberBudget = MonthlyBudget(
  id: 'b-2026-10',
  month: DateTime(2026, 10),
  settings: const BudgetSettings(
    exchangeRate: Money.fromPesos(3300),
    workDays: 22,
  ),
  totalIncome: const Money.fromCents(3715292236),
  totalExpenses: const Money.fromCents(1913520117),
  monthlyCashFlow: const Money.fromCents(1801772119),
  components: const [
    BudgetComponent(
      type: BudgetComponentType.creditCards,
      amount: Money.zero,
      percentage: 0,
      idealPercentage: 20,
    ),
    BudgetComponent(
      type: BudgetComponentType.loans,
      amount: Money.fromPesos(3280231),
      percentage: 8.83,
    ),
    BudgetComponent(
      type: BudgetComponentType.monthlyExpenses,
      amount: Money.fromCents(1585497017),
      percentage: 42.67,
    ),
    BudgetComponent(
      type: BudgetComponentType.savings,
      amount: Money.zero,
      percentage: 0,
      idealPercentage: 10,
    ),
    BudgetComponent(
      type: BudgetComponentType.charity,
      amount: Money.zero,
      percentage: 0,
      idealPercentage: 10,
    ),
  ],
);

/// [octoberBudget] in a month with more expenses than income.
final MonthlyBudget novemberDeficit = octoberBudget.copyWith(
  id: 'b-2026-11',
  month: DateTime(2026, 11),
  settings: const BudgetSettings(),
  totalExpenses: const Money.fromPesos(40000000),
  monthlyCashFlow: const Money.fromCents(-284707764),
);

const Map<String, Object?> octoberBudgetJson = {
  'id': 'b-2026-10',
  'year': 2026,
  'month': 10,
  'exchangeRate': 3300.00,
  'workDays': 22,
  'totalIncome': 37152922.36,
  'totalExpenses': 19135201.17,
  'monthlyCashFlow': 18017721.19,
  'creditCardPercentage': 0.00,
  'loanPercentage': 8.83,
  'expensePercentage': 42.67,
  'savingsPercentage': 0.00,
  'charityPercentage': 0.00,
  'components': [
    {
      'component': 'CREDIT_CARDS',
      'amount': 0.00,
      'percentage': 0.00,
      'idealPercentage': 20.00,
    },
    {
      'component': 'LOANS',
      'amount': 3280231.00,
      'percentage': 8.83,
      'idealPercentage': null,
    },
    {
      'component': 'MONTHLY_EXPENSES',
      'amount': 15854970.17,
      'percentage': 42.67,
      'idealPercentage': null,
    },
    {
      'component': 'SAVINGS',
      'amount': 0.00,
      'percentage': 0.00,
      'idealPercentage': 10.00,
    },
    {
      'component': 'CHARITY',
      'amount': 0.00,
      'percentage': 0.00,
      'idealPercentage': 10.00,
    },
  ],
  'createdAt': '2026-10-22T12:00:00Z',
  'updatedAt': '2026-10-22T12:00:00Z',
};

/// Entry of the monthly comparison report of [month] of 2026, without a
/// budget when [income] is null.
Map<String, Object?> comparisonJson(
  int month, {
  num? income,
  num? expenses,
  double? percentage,
}) =>
    {
      'year': 2026,
      'month': month,
      'exists': income != null,
      'totalIncome': income,
      'totalExpenses': expenses,
      'monthlyCashFlow':
          income == null || expenses == null ? null : income - expenses,
      'cashFlowPercentage': percentage,
    };

MonthComparison comparisonOf(
  int month, {
  int? income,
  int? expenses,
  double? percentage,
}) =>
    MonthComparison(
      month: DateTime(2026, month),
      figures: income == null || expenses == null
          ? null
          : ComparisonFigures(
              totalIncome: Money.fromPesos(income),
              totalExpenses: Money.fromPesos(expenses),
              cashFlow: Money.fromPesos(income - expenses),
              cashFlowPercentage: percentage,
            ),
    );

/// May to October 2026; July has no budget and September a negative cash
/// flow.
final List<MonthComparison> sixMonthComparison = [
  comparisonOf(5, income: 30000000, expenses: 20000000, percentage: 33.33),
  comparisonOf(6, income: 30000000, expenses: 27000000, percentage: 10),
  comparisonOf(7),
  comparisonOf(8, income: 30000000, expenses: 21000000, percentage: 30),
  comparisonOf(9, income: 30000000, expenses: 33000000, percentage: -10),
  comparisonOf(10, income: 37152922, expenses: 19135201, percentage: 48.5),
];
