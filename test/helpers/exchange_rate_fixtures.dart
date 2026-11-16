import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/exchange_rates/domain/entity/today_exchange_rates_entity.dart';

const Money todayTrm = Money.fromCents(331670);
const Money todayEurCop = Money.fromCents(363210);

/// Rates of 22 October 2026, the day of the budget tests' clock.
final TodayExchangeRates freshRates = TodayExchangeRates(
  date: DateTime(2026, 10, 22),
  usdCop: todayTrm,
  eurCop: todayEurCop,
);

/// [freshRates] when the source failed and an earlier day's are returned.
final TodayExchangeRates staleRates = freshRates.copyWith(stale: true);

/// `GET /exchange-rates/today` as the contract describes it.
const Map<String, Object?> todayRatesJson = {
  'date': '2026-10-22',
  'usdCop': {
    'rate': 3316.70,
    'source': 'OFFICIAL_TRM',
    'updatedAt': '2026-10-22T18:01:08.326Z',
  },
  'eurCop': {
    'rate': 3632.10,
    'source': 'MARKET_CLOSE',
    'updatedAt': '2026-10-21T20:02:47.945Z',
  },
  'stale': false,
};
