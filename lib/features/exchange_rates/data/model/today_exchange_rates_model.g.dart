// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'today_exchange_rates_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExchangeRateQuoteModel _$ExchangeRateQuoteModelFromJson(
        Map<String, dynamic> json) =>
    ExchangeRateQuoteModel(
      rate: _money(json['rate']),
    );

TodayExchangeRatesModel _$TodayExchangeRatesModelFromJson(
        Map<String, dynamic> json) =>
    TodayExchangeRatesModel(
      date: json['date'] as String,
      usdCop: json['usdCop'] == null
          ? null
          : ExchangeRateQuoteModel.fromJson(
              json['usdCop'] as Map<String, dynamic>),
      eurCop: json['eurCop'] == null
          ? null
          : ExchangeRateQuoteModel.fromJson(
              json['eurCop'] as Map<String, dynamic>),
      stale: json['stale'] as bool? ?? false,
    );
