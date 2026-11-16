import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/constants/app_constants.dart';
import 'package:pennypincher_pro/core/network/api_envelope.dart';
import 'package:pennypincher_pro/features/exchange_rates/data/model/today_exchange_rates_model.dart';

/// `/exchange-rates` endpoints, called with the authenticated client.
/// Every method throws `AppException` on failure.
@lazySingleton
class ExchangeRateRemoteDataSource {
  ExchangeRateRemoteDataSource(this._dio);

  final Dio _dio;

  /// `GET /exchange-rates/today`. Fails with status 503 and code
  /// `EXCHANGE_RATE_UNAVAILABLE` when no rate at all is known.
  Future<TodayExchangeRatesModel> getToday() async {
    final response = await ApiEnvelope.send(
      () => _dio.get<Object?>(ApiPaths.exchangeRatesToday),
    );
    return ApiEnvelope.parseData(
      response.data,
      TodayExchangeRatesModel.fromJson,
    );
  }
}
