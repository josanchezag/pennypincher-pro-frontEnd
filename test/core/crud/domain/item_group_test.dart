import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/crud/domain/item_group.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/asset_entity.dart';

import '../../../helpers/net_worth_fixtures.dart';

void main() {
  const house = Asset(
    id: 'a4',
    name: 'casa finca',
    value: Money.fromPesos(100000000),
    category: AssetCategory.realEstate,
  );

  test('groups by category order, sorted by name, with subtotals', () {
    final groups = ItemGroup.byCategory<Asset, AssetCategory>(
      [car, house, wallet, apartment],
      AssetCategory.values,
    );

    expect(groups.map((group) => group.category), [
      AssetCategory.realEstate,
      AssetCategory.vehicle,
      AssetCategory.cash,
    ]);
    expect(groups.first.items, [apartment, house]);
    expect(groups.first.subtotal, const Money.fromPesos(450000000));
    expect(groups.last.subtotal, const Money.fromCents(15000050));
  });

  test('returns no groups for an empty list', () {
    expect(
      ItemGroup.byCategory<Asset, AssetCategory>([], AssetCategory.values),
      isEmpty,
    );
  });

  test('totals every item exactly', () {
    expect(
      totalOf([apartment, car, wallet]),
      const Money.fromCents(41215000050),
    );
  });
}
