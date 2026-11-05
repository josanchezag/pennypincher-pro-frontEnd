import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/time/month_format.dart';
import 'package:pennypincher_pro/core/utils/money_formatter.dart';
import 'package:pennypincher_pro/core/widgets/money_format_scope.dart';
import 'package:pennypincher_pro/features/dashboard/domain/entity/dashboard_summary_entity.dart';

/// Small line of the net worth of [points] (at least two, from the oldest
/// month), without axes: green when it ends at or above where it started,
/// red otherwise.
class MiniSparkline extends StatelessWidget {
  const MiniSparkline({required this.points, super.key});

  static const double height = AppSpacing.xxl;
  static const double fillOpacity = 0.2;
  static const int monthsPerYear = 12;

  /// Vertical room around a flat line, in whole units of the currency.
  static const double flatPadding = 1;

  final List<NetWorthPoint> points;

  bool get rising => points.last.netWorth.compareTo(points.first.netWorth) >= 0;

  Color get color =>
      rising ? AppColors.chartLinePositive : AppColors.chartLineNegative;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: _description(context.l10n, context.money),
      child: ExcludeSemantics(
        child: SizedBox(height: height, child: LineChart(_data())),
      ),
    );
  }

  String _description(AppLocalizations l10n, MoneyFormatter money) {
    final first = points.first;
    final last = points.last;
    return l10n.dashboardSparklineLabel(
      money.format(first.netWorth),
      MonthFormat.short.format(first.date),
      money.format(last.netWorth),
      MonthFormat.short.format(last.date),
    );
  }

  LineChartData _data() {
    final values = [for (final point in points) point.netWorth.units];
    final low = values.reduce((a, b) => a < b ? a : b);
    final high = values.reduce((a, b) => a > b ? a : b);
    final flat = low == high;
    return LineChartData(
      minY: flat ? low - flatPadding : low,
      maxY: flat ? high + flatPadding : high,
      lineTouchData: const LineTouchData(enabled: false),
      titlesData: const FlTitlesData(show: false),
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),
      lineBarsData: [_line()],
    );
  }

  LineChartBarData _line() => LineChartBarData(
        spots: [
          for (final point in points)
            FlSpot(_monthIndex(point.date), point.netWorth.units),
        ],
        color: color,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [color.withOpacity(fillOpacity), color.withOpacity(0)],
          ),
        ),
      );

  double _monthIndex(DateTime date) {
    final first = points.first.date;
    return ((date.year - first.year) * monthsPerYear + date.month - first.month)
        .toDouble();
  }
}
