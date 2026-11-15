import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/features/exchange_rates/domain/repository/exchange_rate_repository.dart';
import 'package:pennypincher_pro/features/exchange_rates/domain/usecase/get_today_exchange_rates.dart';

/// Registers the exchange rate use cases, keeping the domain layer free of
/// dependency injection annotations.
@module
abstract class ExchangeRatesModule {
  @injectable
  GetTodayExchangeRates getTodayExchangeRates(
    ExchangeRateRepository repository,
  ) =>
      GetTodayExchangeRates(repository);
}
