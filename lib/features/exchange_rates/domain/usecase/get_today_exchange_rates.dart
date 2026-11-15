import 'package:dartz/dartz.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/features/exchange_rates/domain/entity/today_exchange_rates_entity.dart';
import 'package:pennypincher_pro/features/exchange_rates/domain/repository/exchange_rate_repository.dart';

/// Loads today's USD/COP and EUR/COP rates.
class GetTodayExchangeRates {
  const GetTodayExchangeRates(this._repository);

  final ExchangeRateRepository _repository;

  Future<Either<Failure, TodayExchangeRates>> call() => _repository.getToday();
}
