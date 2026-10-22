import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/asset_entity.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/liability_entity.dart';

const Asset apartment = Asset(
  id: 'a1',
  name: 'Apto Madera',
  value: Money.fromPesos(350000000),
  category: AssetCategory.realEstate,
);

const Asset car = Asset(
  id: 'a2',
  name: 'Carro Mazda',
  value: Money.fromPesos(62000000),
  category: AssetCategory.vehicle,
);

const Asset wallet = Asset(
  id: 'a3',
  name: 'Billetera',
  value: Money.fromCents(15000050),
  category: AssetCategory.cash,
);

const Map<String, Object?> apartmentJson = {
  'id': 'a1',
  'name': 'Apto Madera',
  'value': 350000000.00,
  'category': 'REAL_ESTATE',
  'isActive': true,
  'createdAt': '2026-10-01T12:00:00Z',
  'updatedAt': '2026-10-01T12:00:00Z',
};

const Liability nuCard = Liability(
  id: 'l1',
  name: 'Tarjeta Nu Bank',
  currentBalance: Money.fromPesos(3200000),
  category: LiabilityCategory.creditCard,
);

const Liability davivienda = Liability(
  id: 'l2',
  name: 'Prestamo Davivienda 7141',
  currentBalance: Money.fromCents(4550000025),
  category: LiabilityCategory.bankLoan,
);

const Map<String, Object?> nuCardJson = {
  'id': 'l1',
  'name': 'Tarjeta Nu Bank',
  'currentBalance': 3200000,
  'category': 'CREDIT_CARD',
};
