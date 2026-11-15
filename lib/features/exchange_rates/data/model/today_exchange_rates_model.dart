import 'package:json_annotation/json_annotation.dart';
import 'package:pennypincher_pro/core/time/api_date.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/exchange_rates/domain/entity/today_exchange_rates_entity.dart';

part 'today_exchange_rates_model.g.dart';

Money _money(Object? json) => Money.fromJson(json);

/// JSON shape of one rate: `{rate, source, updatedAt}`. Only the rate is
/// read.
@JsonSerializable(createToJson: false)
class ExchangeRateQuoteModel {
  const ExchangeRateQuoteModel({required this.rate});

  factory ExchangeRateQuoteModel.fromJson(Map<String, dynamic> json) =>
      _$ExchangeRateQuoteModelFromJson(json);

  @JsonKey(fromJson: _money)
  final Money rate;

  /// The rate, or `null` when it is not a usable price (zero or less).
  Money? get usableRate => rate.isNegative || rate.isZero ? null : rate;
}

/// JSON shape of `GET /exchange-rates/today`. Either rate is `null` when
/// the backend could not obtain it.
@JsonSerializable(createToJson: false)
class TodayExchangeRatesModel {
  const TodayExchangeRatesModel({
    required this.date,
    this.usdCop,
    this.eurCop,
    this.stale = false,
  });

  factory TodayExchangeRatesModel.fromJson(Map<String, dynamic> json) =>
      _$TodayExchangeRatesModelFromJson(json);

  final String date;
  final ExchangeRateQuoteModel? usdCop;
  final ExchangeRateQuoteModel? eurCop;
  @JsonKey(defaultValue: false)
  final bool stale;

  TodayExchangeRates toEntity() => TodayExchangeRates(
        date: ApiDate.parse(date),
        usdCop: usdCop?.usableRate,
        eurCop: eurCop?.usableRate,
        stale: stale,
      );
}
