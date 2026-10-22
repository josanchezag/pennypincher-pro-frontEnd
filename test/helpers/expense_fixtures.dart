import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/credit_card_entity.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/expense_summary_entity.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/loan_entity.dart';

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
