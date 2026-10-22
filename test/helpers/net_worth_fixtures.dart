import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/asset_entity.dart';

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
