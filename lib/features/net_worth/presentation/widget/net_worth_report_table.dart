import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/time/month_format.dart';
import 'package:pennypincher_pro/core/utils/currency_formatter.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/widgets/report_table.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/net_worth_trend_entity.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/net_worth_texts.dart';

/// Every month of a net worth report, newest first, with its change
/// against the month before and the best month highlighted.
class NetWorthReportTable extends StatelessWidget {
  const NetWorthReportTable({required this.trend, super.key});

  static const List<String> columns = [
    NetWorthTexts.month,
    NetWorthTexts.assets,
    NetWorthTexts.liabilities,
    NetWorthTexts.netWorth,
    NetWorthTexts.delta,
  ];

  final NetWorthTrend trend;

  @override
  Widget build(BuildContext context) {
    final best = trend.best;
    return ReportTable(
      columns: columns,
      rows: [
        for (final point in trend.points.reversed)
          ReportRow(
            highlight: identical(point, best) ? NetWorthTexts.best : null,
            cells: _cells(point),
          ),
      ],
    );
  }

  static List<ReportCell> _cells(NetWorthTrendPoint point) => [
        ReportCell(MonthFormat.short.format(point.month)),
        ReportCell(CurrencyFormatter.format(point.totalAssets)),
        ReportCell(CurrencyFormatter.format(point.totalLiabilities)),
        ReportCell(CurrencyFormatter.format(point.netWorth)),
        deltaCell(point.delta),
      ];

  /// Signed change, green when up, red when down, plain when unchanged,
  /// and a dash for the first month.
  static ReportCell deltaCell(Money? delta) {
    if (delta == null) {
      return const ReportCell(NetWorthTexts.noDelta);
    }
    return ReportCell(
      CurrencyFormatter.formatSigned(delta),
      color: delta.isZero
          ? null
          : delta.isNegative
              ? AppColors.error
              : AppColors.success,
    );
  }
}
