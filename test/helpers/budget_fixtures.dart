import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/income_source_entity.dart';

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
