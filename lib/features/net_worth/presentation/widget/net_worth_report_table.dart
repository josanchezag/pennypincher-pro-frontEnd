import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/time/month_format.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/utils/money_formatter.dart';
import 'package:pennypincher_pro/core/widgets/money_format_scope.dart';
import 'package:pennypincher_pro/core/widgets/report_table.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/net_worth_trend_entity.dart';

/// Every month of a net worth report, newest first, with its change
/// against the month before and the best month highlighted.
class NetWorthReportTable extends StatelessWidget {
  const NetWorthReportTable({required this.trend, super.key});

  static List<String> columns(AppLocalizations l10n) => [
        l10n.tableMonth,
        l10n.assets,
        l10n.liabilities,
        l10n.netWorth,
        l10n.netWorthDelta,
      ];

  final NetWorthTrend trend;

  @override
  Widget build(BuildContext context) {
    final best = trend.best;
    return ReportTable(
      columns: columns(context.l10n),
      rows: [
        for (final point in trend.points.reversed)
          ReportRow(
            highlight:
                identical(point, best) ? context.l10n.netWorthBest : null,
            cells: _cells(context.money, point),
          ),
      ],
    );
  }

  static List<ReportCell> _cells(
    MoneyFormatter money,
    NetWorthTrendPoint point,
  ) =>
      [
        ReportCell(MonthFormat.short.format(point.month)),
        ReportCell(money.format(point.totalAssets)),
        ReportCell(money.format(point.totalLiabilities)),
        ReportCell(money.format(point.netWorth)),
        deltaCell(money, point.delta),
      ];

  /// Signed change, green when up, red when down, plain when unchanged,
  /// and a dash for the first month.
  static ReportCell deltaCell(MoneyFormatter money, Money? delta) {
    if (delta == null) {
      return const ReportCell(ReportTable.noValue);
    }
    return ReportCell(
      money.formatSigned(delta),
      color: delta.isZero
          ? null
          : delta.isNegative
              ? AppColors.error
              : AppColors.success,
    );
  }
}
