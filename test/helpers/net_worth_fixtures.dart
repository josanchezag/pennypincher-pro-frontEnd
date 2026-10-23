import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/asset_entity.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/liability_entity.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/net_worth_snapshot_entity.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/net_worth_summary_entity.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/net_worth_trend_entity.dart';

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

NetWorthSnapshot snapshotOf(int year, int month, int netWorthPesos) =>
    NetWorthSnapshot(
      id: 's-$year-$month',
      snapshotDate: DateTime(year, month),
      totalAssets: Money.fromPesos(netWorthPesos + 10000000),
      totalLiabilities: const Money.fromPesos(10000000),
      netWorth: Money.fromPesos(netWorthPesos),
    );

final NetWorthSnapshot august = snapshotOf(2026, 8, 165000000);
final NetWorthSnapshot september = snapshotOf(2026, 9, 170550000);

const NetWorthSummary currentSummary = NetWorthSummary(
  totalAssets: Money.fromPesos(185000000),
  totalLiabilities: Money.fromPesos(12000000),
  netWorth: Money.fromPesos(173000000),
);

const Map<String, Object?> septemberJson = {
  'id': 's-2026-9',
  'snapshotDate': '2026-09-01',
  'totalAssets': 180550000.00,
  'totalLiabilities': 10000000.00,
  'netWorth': 170550000.00,
  'createdAt': '2026-09-01T12:00:00Z',
  'updatedAt': '2026-09-01T12:00:00Z',
};

/// Point of the trend report of [month] of 2026.
Map<String, Object?> trendPointJson(
  int month, {
  required num assets,
  required num liabilities,
  num? delta,
}) =>
    {
      'periodStart': '2026-${month.toString().padLeft(2, '0')}-01',
      'totalAssets': assets,
      'totalLiabilities': liabilities,
      'netWorth': assets - liabilities,
      'monthOverMonthDelta': delta,
    };

NetWorthTrendPoint trendPointOf(
  int month, {
  required int assets,
  required int liabilities,
  int? delta,
}) =>
    NetWorthTrendPoint(
      month: DateTime(2026, month),
      totalAssets: Money.fromPesos(assets),
      totalLiabilities: Money.fromPesos(liabilities),
      netWorth: Money.fromPesos(assets - liabilities),
      delta: delta == null ? null : Money.fromPesos(delta),
    );

/// August to October 2026: net worth 100, 160 (the best) and 130 million.
final NetWorthTrend threeMonthTrend = NetWorthTrend([
  trendPointOf(8, assets: 150000000, liabilities: 50000000),
  trendPointOf(
    9,
    assets: 200000000,
    liabilities: 40000000,
    delta: 60000000,
  ),
  trendPointOf(
    10,
    assets: 160000000,
    liabilities: 30000000,
    delta: -30000000,
  ),
]);
