import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/income_source_entity.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/monthly_budget_entity.dart';

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
