import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/error/app_exception.dart';
import 'package:pennypincher_pro/core/error/error_codes.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/exchange_rates/data/datasource/exchange_rate_remote_datasource.dart';
import 'package:pennypincher_pro/features/exchange_rates/domain/entity/today_exchange_rates_entity.dart';

import '../../../helpers/exchange_rate_fixtures.dart';
import '../../../helpers/fake_http_adapter.dart';

void main() {
  late FakeHttpAdapter adapter;
  late ExchangeRateRemoteDataSource dataSource;

  setUp(() {
    adapter = FakeHttpAdapter(
      (_) async => FakeResponse(200, envelope(todayRatesJson)),
    );
    dataSource = ExchangeRateRemoteDataSource(fakeDio(adapter));
  });

  Future<TodayExchangeRates> answer(Object? body) async {
    adapter.handler = (_) async => FakeResponse(200, body);
    return (await dataSource.getToday()).toEntity();
  }

  test("gets today's rates", () async {
    final rates = (await dataSource.getToday()).toEntity();

    expect(adapter.requests.single.method, 'GET');
    expect(adapter.requests.single.path, '/exchange-rates/today');
    expect(adapter.requests.single.queryParameters, isEmpty);
    expect(rates, freshRates);
  });

  test('rejects rates outside the envelope', () async {
    adapter.handler = (_) async => const FakeResponse(200, todayRatesJson);

    expect(
      dataSource.getToday(),
      throwsA(
        isA<AppException>()
            .having((e) => e.code, 'code', ErrorCodes.invalidResponse),
      ),
    );
  });

  test('reads a missing rate and stale rates', () async {
    final rates = await answer(
      envelope({...todayRatesJson, 'eurCop': null, 'stale': true}),
    );

    expect(rates.usdCop, todayTrm);
    expect(rates.eurCop, isNull);
    expect(rates.stale, isTrue);
    expect(rates.hasFreshUsdCop, isFalse);
  });

  test('reads a missing stale flag as fresh', () async {
    final json = Map.of(todayRatesJson)..remove('stale');

    expect((await answer(envelope(json))).stale, isFalse);
  });

  test('drops a rate that is not a price', () async {
    final rates = await answer(
      envelope({
        ...todayRatesJson,
        'usdCop': {'rate': 0, 'source': 'OFFICIAL_TRM'},
      }),
    );

    expect(rates.usdCop, isNull);
    expect(rates.eurCop, const Money.fromCents(363210));
  });

  test('rejects an answer without a date', () async {
    final json = Map.of(todayRatesJson)..remove('date');
    adapter.handler = (_) async => FakeResponse(200, envelope(json));

    expect(
      dataSource.getToday(),
      throwsA(
        isA<AppException>()
            .having((e) => e.code, 'code', ErrorCodes.invalidResponse),
      ),
    );
  });

  test('throws the backend error when no rate is known', () async {
    adapter.handler = (_) async => FakeResponse(
          503,
          errorEnvelope('EXCHANGE_RATE_UNAVAILABLE', 'No exchange rate'),
        );

    expect(
      dataSource.getToday(),
      throwsA(
        isA<AppException>()
            .having((e) => e.code, 'code', 'EXCHANGE_RATE_UNAVAILABLE')
            .having((e) => e.statusCode, 'statusCode', 503),
      ),
    );
  });
}
