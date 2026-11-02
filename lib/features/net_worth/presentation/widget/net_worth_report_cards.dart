import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/widgets/chart_legend.dart';
import 'package:pennypincher_pro/core/widgets/report_section_card.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/net_worth_trend_entity.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/widget/full_history_chart.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/widget/net_worth_report_table.dart';

/// The full history chart with its legend.
class NetWorthReportChartCard extends StatelessWidget {
  const NetWorthReportChartCard({required this.trend, super.key});

  static List<LegendEntry> legend(AppLocalizations l10n) => [
        LegendEntry(
          color: FullHistoryChart.netWorthColor,
          label: l10n.netWorth,
        ),
        LegendEntry(
          color: FullHistoryChart.assetsColor,
          label: l10n.totalAssets,
        ),
        LegendEntry(
          color: FullHistoryChart.liabilitiesColor,
          label: l10n.totalLiabilities,
        ),
        LegendEntry(
          color: FullHistoryChart.bestColor,
          label: l10n.netWorthBestMonth,
        ),
      ];

  /// Must not be empty.
  final NetWorthTrend trend;

  @override
  Widget build(BuildContext context) {
    return ReportSectionCard(
      title: context.l10n.netWorthHistory,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ChartLegend(entries: legend(context.l10n)),
          const SizedBox(height: AppSpacing.md),
          FullHistoryChart(trend: trend),
        ],
      ),
    );
  }
}

/// The month-by-month table.
class NetWorthReportTableCard extends StatelessWidget {
  const NetWorthReportTableCard({required this.trend, super.key});

  final NetWorthTrend trend;

  @override
  Widget build(BuildContext context) {
    return ReportSectionCard(
      title: context.l10n.monthByMonth,
      child: NetWorthReportTable(trend: trend),
    );
  }
}
