import 'package:dartz/dartz.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/features/exchange_rates/domain/entity/today_exchange_rates_entity.dart';

/// Daily USD/COP and EUR/COP rates.
abstract interface class ExchangeRateRepository {
  /// Today's rates. Asked to the backend at most once per local day while
  /// the answer is complete and fresh.
  Future<Either<Failure, TodayExchangeRates>> getToday();
}
