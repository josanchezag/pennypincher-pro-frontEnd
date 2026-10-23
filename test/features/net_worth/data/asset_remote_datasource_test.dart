import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/error/app_exception.dart';
import 'package:pennypincher_pro/core/error/error_codes.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/net_worth/data/datasource/asset_remote_datasource.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/asset_entity.dart';

import '../../../helpers/fake_http_adapter.dart';
import '../../../helpers/net_worth_fixtures.dart';

const CategorizedDraft<AssetCategory> _draft = CategorizedDraft(
  name: 'Apto Madera',
  amount: Money.fromCents(35000000050),
  category: AssetCategory.realEstate,
);

void main() {
  late FakeHttpAdapter adapter;
  late AssetRemoteDataSource dataSource;

  setUp(() {
    adapter = FakeHttpAdapter(
      (_) async => FakeResponse(200, envelope(apartmentJson)),
    );
    dataSource = AssetRemoteDataSource(fakeDio(adapter));
  });

  test('lists the assets', () async {
    adapter.handler = (_) async => FakeResponse(
          200,
          envelope([
            apartmentJson,
            {
              'id': 'a2',
              'name': 'Carro Mazda',
              'value': '62000000.00',
              'category': 'VEHICLE',
            },
          ]),
        );

    final assets = await dataSource.getAll();

    expect(adapter.requests.single.method, 'GET');
    expect(adapter.requests.single.path, '/assets');
    expect(assets, [apartment, car]);
  });

  test('creates an asset with its value as a JSON number', () async {
    final asset = await dataSource.create(_draft);

    final request = adapter.requests.single;
    expect(request.method, 'POST');
    expect(request.path, '/assets');
    expect(request.data, {
      'name': 'Apto Madera',
      'value': 350000000.5,
      'category': 'REAL_ESTATE',
    });
    expect(asset, apartment);
  });

  test('updates and deletes an asset by id', () async {
    await dataSource.update('a1', _draft);
    adapter.handler = (_) async => const FakeResponse(204);
    await dataSource.delete('a1');

    expect(adapter.requests.first.method, 'PUT');
    expect(adapter.requests.first.path, '/assets/a1');
    expect(adapter.requests.last.method, 'DELETE');
    expect(adapter.requests.last.path, '/assets/a1');
  });

  test('maps an unknown category to other', () async {
    adapter.handler = (_) async => FakeResponse(
          200,
          envelope({...apartmentJson, 'category': 'CRYPTO'}),
        );

    final asset = await dataSource.create(_draft);

    expect(asset.category, AssetCategory.other);
  });

  test('rejects an asset with an invalid value', () {
    adapter.handler = (_) async => FakeResponse(
          200,
          envelope({...apartmentJson, 'value': 'lots'}),
        );

    expect(
      () => dataSource.create(_draft),
      throwsA(
        isA<AppException>()
            .having((e) => e.code, 'code', ErrorCodes.invalidResponse),
      ),
    );
  });

  test('surfaces the backend error and status', () {
    adapter.handler = (_) async => FakeResponse(
          404,
          errorEnvelope('NOT_FOUND', 'Asset not found'),
        );

    expect(
      () => dataSource.delete('missing'),
      throwsA(
        isA<AppException>()
            .having((e) => e.code, 'code', 'NOT_FOUND')
            .having((e) => e.statusCode, 'statusCode', 404),
      ),
    );
  });
}
