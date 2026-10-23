import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/widgets/chart_legend.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/net_worth_trend_entity.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/net_worth_texts.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/widget/full_history_chart.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/widget/net_worth_report_table.dart';

/// Card with a [title] heading above its [child].
class ReportSectionCard extends StatelessWidget {
  const ReportSectionCard({
    required this.title,
    required this.child,
    super.key,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              container: true,
              header: true,
              child: Text(title, style: AppTypography.heading3),
            ),
            const SizedBox(height: AppSpacing.md),
            child,
          ],
        ),
      ),
    );
  }
}

/// The full history chart with its legend.
class NetWorthReportChartCard extends StatelessWidget {
  const NetWorthReportChartCard({required this.trend, super.key});

  static const List<LegendEntry> legend = [
    LegendEntry(
      color: FullHistoryChart.netWorthColor,
      label: NetWorthTexts.netWorth,
    ),
    LegendEntry(
      color: FullHistoryChart.assetsColor,
      label: NetWorthTexts.totalAssets,
    ),
    LegendEntry(
      color: FullHistoryChart.liabilitiesColor,
      label: NetWorthTexts.totalLiabilities,
    ),
    LegendEntry(
      color: FullHistoryChart.bestColor,
      label: NetWorthTexts.bestMonth,
    ),
  ];

  /// Must not be empty.
  final NetWorthTrend trend;

  @override
  Widget build(BuildContext context) {
    return ReportSectionCard(
      title: NetWorthTexts.history,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ChartLegend(entries: legend),
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
      title: NetWorthTexts.monthByMonth,
      child: NetWorthReportTable(trend: trend),
    );
  }
}
