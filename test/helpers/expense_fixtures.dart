import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/credit_card_entity.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/expense_summary_entity.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/fixed_expense_entity.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/loan_entity.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/savings_account_entity.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/variable_expense_entity.dart';

const CreditCard nuCard = CreditCard(
  id: 'c1',
  name: 'Tarjeta Nu Bank',
  monthlyPayment: Money.zero,
  totalBalance: Money.fromPesos(12407700),
);

const CreditCard visaCard = CreditCard(
  id: 'c2',
  name: 'Visa Bancolombia',
  monthlyPayment: Money.fromCents(125000050),
  totalBalance: Money.fromPesos(30549222),
);

const CreditCard amexCard = CreditCard(
  id: 'c3',
  name: 'amex Platinum',
  monthlyPayment: Money.fromPesos(800000),
  totalBalance: Money.fromPesos(4000000),
);

const Map<String, Object?> nuCardJson = {
  'id': 'c1',
  'name': 'Tarjeta Nu Bank',
  'monthlyPayment': 0,
  'totalBalance': 12407700.00,
  'createdAt': '2026-10-22T12:00:00Z',
  'updatedAt': '2026-10-22T12:00:00Z',
};

const ExpenseSummary cardsSummary = ExpenseSummary(
  monthlyTotal: Money.fromCents(125000050),
  balanceTotal: Money.fromPesos(42956922),
  count: 2,
);

const ExpenseSummary fixedSummary = ExpenseSummary(
  monthlyTotal: Money.fromPesos(2347709),
  count: 1,
);

/// Tracked loan, 40 % paid.
const Loan carLoan = Loan(
  id: 'l1',
  name: 'Prestamo carro',
  monthlyPayment: Money.fromPesos(1200000),
  totalBalance: Money.fromPesos(30000000),
  originalAmount: Money.fromPesos(50000000),
);

/// Loan without its original amount.
const Loan davivienda = Loan(
  id: 'l2',
  name: 'Davivienda 7141',
  monthlyPayment: Money.fromPesos(2080231),
  totalBalance: Money.fromCents(4550000025),
);

/// Loan that owes more than it started with (interest), 0 % paid.
const Loan familyLoan = Loan(
  id: 'l3',
  name: 'Familia',
  monthlyPayment: Money.zero,
  totalBalance: Money.fromPesos(11000000),
  originalAmount: Money.fromPesos(10000000),
);

const Map<String, Object?> carLoanJson = {
  'id': 'l1',
  'name': 'Prestamo carro',
  'monthlyPayment': 1200000.00,
  'totalBalance': 30000000.00,
  'originalAmount': 50000000.00,
  'createdAt': '2026-10-22T12:00:00Z',
  'updatedAt': '2026-10-22T12:00:00Z',
};

const FixedExpense schoolAna = FixedExpense(
  id: 'f1',
  name: 'Colegio Ana',
  monthlyAmount: Money.fromPesos(1347709),
  category: FixedExpenseCategory.education,
);

const FixedExpense englishClasses = FixedExpense(
  id: 'f2',
  name: 'clases de ingles',
  monthlyAmount: Money.fromPesos(1000000),
  category: FixedExpenseCategory.education,
);

const FixedExpense rent = FixedExpense(
  id: 'f3',
  name: 'Arriendo',
  monthlyAmount: Money.fromCents(320000050),
  category: FixedExpenseCategory.housing,
);

const FixedExpense tithe = FixedExpense(
  id: 'f4',
  name: 'Diezmo',
  monthlyAmount: Money.fromPesos(3715292),
  category: FixedExpenseCategory.charity,
);

const Map<String, Object?> schoolAnaJson = {
  'id': 'f1',
  'name': 'Colegio Ana',
  'monthlyAmount': 1347709.00,
  'category': 'EDUCATION',
  'createdAt': '2026-10-22T12:00:00Z',
  'updatedAt': '2026-10-22T12:00:00Z',
};

const VariableExpense netflix = VariableExpense(
  id: 'v1',
  name: 'Netflix',
  monthlyAmount: Money.fromPesos(44900),
  category: VariableExpenseCategory.streaming,
);

const VariableExpense nanny = VariableExpense(
  id: 'v2',
  name: 'Empleada',
  monthlyAmount: Money.fromPesos(1800000),
  category: VariableExpenseCategory.householdStaff,
);

const VariableExpense restaurants = VariableExpense(
  id: 'v3',
  name: 'Restaurantes',
  monthlyAmount: Money.fromPesos(600000),
  category: VariableExpenseCategory.dining,
);

const Map<String, Object?> nannyJson = {
  'id': 'v2',
  'name': 'Empleada',
  'monthlyAmount': 1800000,
  'category': 'HOUSEHOLD_STAFF',
};

const SavingsAccount emergencyFund = SavingsAccount(
  id: 's1',
  name: 'Fondo de emergencia',
  monthlyContribution: Money.fromPesos(500000),
  currentBalance: Money.fromCents(850000050),
);

const SavingsAccount cdt = SavingsAccount(
  id: 's2',
  name: 'CDT Bancolombia',
  monthlyContribution: Money.zero,
  currentBalance: Money.fromPesos(20000000),
);

const SavingsAccount vacations = SavingsAccount(
  id: 's3',
  name: 'Vacaciones',
  monthlyContribution: Money.fromPesos(300000),
  currentBalance: Money.fromPesos(1200000),
);

const Map<String, Object?> emergencyFundJson = {
  'id': 's1',
  'name': 'Fondo de emergencia',
  'monthlyContribution': 500000,
  'currentBalance': 8500000.5,
};
