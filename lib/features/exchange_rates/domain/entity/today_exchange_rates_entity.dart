import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pennypincher_pro/core/utils/money.dart';

part 'today_exchange_rates_entity.freezed.dart';

/// Colombian pesos per US dollar and per euro of one day, as the backend
/// takes them from an online source. [usdCop] is the official TRM and
/// [eurCop] the last market close of the euro (there is no official TRM
/// for it); either is `null` when it could not be obtained.
@freezed
class TodayExchangeRates with _$TodayExchangeRates {
  const factory TodayExchangeRates({
    /// Day the rates were asked for, in Colombian time.
    required DateTime date,
    Money? usdCop,
    Money? eurCop,

    /// The source failed and these are the last good rates of an earlier
    /// day.
    @Default(false) bool stale,
  }) = _TodayExchangeRates;

  const TodayExchangeRates._();

  /// The TRM can replace a stored one: it is today's and not missing.
  bool get hasFreshUsdCop => !stale && usdCop != null;

  /// Both rates are today's: nothing better can be fetched later today.
  bool get isComplete => hasFreshUsdCop && eurCop != null;
}
