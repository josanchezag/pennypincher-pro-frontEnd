import 'dart:math' as math;

import 'package:pennypincher_pro/core/utils/chart_axis.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/net_worth_snapshot_entity.dart';

/// Axes of the net worth chart: one x unit per month counted from
/// [firstMonth], and a y range rounded to [interval] steps that always
/// includes zero.
class ChartScale {
  const ChartScale._({
    required this.firstMonth,
    required this.minX,
    required this.maxX,
    required this.minY,
    required this.maxY,
    required this.interval,
  });

  /// Scale of [history] (sorted, not empty) showing at least
  /// [minVisibleMonths], ending at the latest snapshot.
  factory ChartScale.of(List<NetWorthSnapshot> history) {
    final firstMonth = history.first.snapshotDate;
    final maxX = monthsBetween(firstMonth, history.last.snapshotDate);
    final values = history.map((snapshot) => snapshot.netWorth.pesos);
    final low = math.min(0, values.reduce(math.min)).toDouble();
    final high = math.max(0, values.reduce(math.max)).toDouble();
    final interval = ChartAxis.niceInterval(high - low);
    return ChartScale._(
      firstMonth: firstMonth,
      minX: math.min(0, maxX - (minVisibleMonths - 1)).toDouble(),
      maxX: maxX.toDouble(),
      minY: (low / interval).floorToDouble() * interval,
      maxY: math.max((high / interval).ceilToDouble() * interval, interval),
      interval: interval,
    );
  }

  static const int minVisibleMonths = 6;
  static const int monthsPerYear = 12;

  final DateTime firstMonth;
  final double minX;
  final double maxX;
  final double minY;
  final double maxY;
  final double interval;

  int get visibleMonths => (maxX - minX).round() + 1;

  double xOf(DateTime month) => monthsBetween(firstMonth, month).toDouble();

  DateTime monthAt(double x) =>
      DateTime(firstMonth.year, firstMonth.month + x.round());

  static int monthsBetween(DateTime from, DateTime to) =>
      (to.year - from.year) * monthsPerYear + to.month - from.month;
}
