import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pennypincher_pro/core/utils/money.dart';

part 'net_worth_trend_entity.freezed.dart';

/// Net worth of the snapshot of [month] (its first day) and its [delta]
/// against the previous point of the report, `null` for the first one.
@freezed
class NetWorthTrendPoint with _$NetWorthTrendPoint {
  const factory NetWorthTrendPoint({
    required DateTime month,
    required Money totalAssets,
    required Money totalLiabilities,
    required Money netWorth,
    Money? delta,
  }) = _NetWorthTrendPoint;
}

/// The monthly points of a net worth report, from the oldest month.
@freezed
class NetWorthTrend with _$NetWorthTrend {
  const factory NetWorthTrend(List<NetWorthTrendPoint> points) = _NetWorthTrend;

  const NetWorthTrend._();

  static const int _percent = 100;

  bool get isEmpty => points.isEmpty;

  /// The month with the highest net worth; the latest one on a tie.
  NetWorthTrendPoint? get best => points.isEmpty
      ? null
      : points.reduce((a, b) => b.netWorth.compareTo(a.netWorth) >= 0 ? b : a);

  /// Net worth gained (or lost) from the first to the last month.
  Money? get change =>
      points.isEmpty ? null : points.last.netWorth - points.first.netWorth;

  /// [change] in percent of the first net worth (of its absolute value), or
  /// `null` when that was zero.
  double? get changePercentage {
    final difference = change;
    final start = points.isEmpty ? Money.zero : points.first.netWorth;
    return difference == null || start.isZero
        ? null
        : difference.cents / start.cents.abs() * _percent;
  }
}
