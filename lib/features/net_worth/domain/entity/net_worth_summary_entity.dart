import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pennypincher_pro/core/utils/money.dart';

part 'net_worth_summary_entity.freezed.dart';

/// Live totals of the user's current assets and liabilities.
@freezed
class NetWorthSummary with _$NetWorthSummary {
  const factory NetWorthSummary({
    required Money totalAssets,
    required Money totalLiabilities,
    required Money netWorth,
  }) = _NetWorthSummary;
}
