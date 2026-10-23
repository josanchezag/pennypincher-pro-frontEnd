import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/error/app_exception.dart';
import 'package:pennypincher_pro/core/error/error_codes.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/net_worth/data/datasource/net_worth_remote_datasource.dart';

import '../../../helpers/fake_http_adapter.dart';
import '../../../helpers/net_worth_fixtures.dart';

void main() {
  late FakeHttpAdapter adapter;
  late NetWorthRemoteDataSource dataSource;

  setUp(() {
    adapter = FakeHttpAdapter(
      (_) async => FakeResponse(200, envelope(septemberJson)),
    );
    dataSource = NetWorthRemoteDataSource(fakeDio(adapter));
  });

  test('lists every snapshot without a date range', () async {
    adapter.handler = (_) async => FakeResponse(
          200,
          envelope([septemberJson]),
        );

    final snapshots = await dataSource.getSnapshots();

    expect(adapter.requests.single.method, 'GET');
    expect(adapter.requests.single.path, '/net-worth/snapshots');
    expect(adapter.requests.single.queryParameters, isEmpty);
    expect(snapshots.single.toEntity(), september);
  });

  test('reads the live totals, including a negative net worth', () async {
    adapter.handler = (_) async => FakeResponse(
          200,
          envelope({
            'totalAssets': 5000000.00,
            'totalLiabilities': 7500000.50,
            'netWorth': -2500000.50,
          }),
        );

    final summary = (await dataSource.getCurrent()).toEntity();

    expect(adapter.requests.single.path, '/net-worth/current');
    expect(summary.netWorth, const Money.fromCents(-250000050));
    expect(summary.totalLiabilities, const Money.fromCents(750000050));
  });

  test('posts the first day of the month for a new snapshot', () async {
    final snapshot = await dataSource.createSnapshot(DateTime(2026, 9, 18));

    final request = adapter.requests.single;
    expect(request.method, 'POST');
    expect(request.path, '/net-worth/snapshots');
    expect(request.data, {'snapshotDate': '2026-09-01'});
    expect(snapshot.toEntity(), september);
  });

  test('rejects a snapshot with an invalid date', () {
    adapter.handler = (_) async => FakeResponse(
          201,
          envelope({...septemberJson, 'snapshotDate': 'September'}),
        );

    expect(
      () => dataSource.createSnapshot(DateTime(2026, 9)),
      throwsA(
        isA<AppException>()
            .having((e) => e.code, 'code', ErrorCodes.invalidResponse),
      ),
    );
  });

  group('trend report', () {
    test('asks for monthly points since the first day of a month', () async {
      adapter.handler = (_) async => FakeResponse(
            200,
            envelope([
              trendPointJson(9, assets: 200000000.50, liabilities: 0),
            ]),
          );

      final points = await dataSource.getTrend(from: DateTime(2025, 11));

      final request = adapter.requests.single;
      expect(request.method, 'GET');
      expect(request.path, '/reports/net-worth-trend');
      expect(request.queryParameters, {
        'from': '2025-11-01',
        'groupBy': 'month',
      });
      expect(
        points.single.toEntity().totalAssets,
        const Money.fromCents(20000000050),
      );
    });

    test('asks for the whole history without a start', () async {
      adapter.handler = (_) async => FakeResponse(200, envelope([]));

      final points = await dataSource.getTrend();

      expect(adapter.requests.single.queryParameters, {'groupBy': 'month'});
      expect(points, isEmpty);
    });

    test('reads a null delta for the first point and a negative one', () async {
      adapter.handler = (_) async => FakeResponse(
            200,
            envelope([
              trendPointJson(8, assets: 150000000, liabilities: 50000000),
              trendPointJson(
                9,
                assets: 100000000,
                liabilities: 50000000,
                delta: -50000000,
              ),
            ]),
          );

      final points = [
        for (final model in await dataSource.getTrend()) model.toEntity(),
      ];

      expect(points.first.delta, isNull);
      expect(points.first.month, DateTime(2026, 8));
      expect(points.last.delta, const Money.fromPesos(-50000000));
      expect(points.last.netWorth, const Money.fromPesos(50000000));
    });

    test('rejects a point without its net worth', () {
      adapter.handler = (_) async => FakeResponse(
            200,
            envelope([
              {
                ...trendPointJson(8, assets: 1, liabilities: 0),
                'netWorth': null,
              },
            ]),
          );

      expect(
        dataSource.getTrend,
        throwsA(
          isA<AppException>()
              .having((e) => e.code, 'code', ErrorCodes.invalidResponse),
        ),
      );
    });
  });
}
