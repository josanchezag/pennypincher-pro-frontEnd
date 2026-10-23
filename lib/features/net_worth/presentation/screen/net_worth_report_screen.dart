import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/widgets/loading_skeleton.dart';
import 'package:pennypincher_pro/core/widgets/screen_title_row.dart';
import 'package:pennypincher_pro/core/widgets/status_message.dart';
import 'package:pennypincher_pro/core/widgets/time_range_selector.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/net_worth_trend_entity.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/bloc/net_worth_report_bloc.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/net_worth_texts.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/widget/full_history_chart.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/widget/net_worth_report_cards.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/widget/net_worth_report_summary.dart';

/// `/net-worth/report`: the net worth history of a time range as summary
/// cards, a full chart and a month-by-month table. Expects a
/// [NetWorthReportBloc] above it.
class NetWorthReportScreen extends StatelessWidget {
  const NetWorthReportScreen({super.key});

  static const Key retryKey = Key('net-worth-report-retry');
  static const Key recordSnapshotKey = Key('net-worth-report-record');
  static const List<double> skeletonHeights = [
    AppSpacing.xxxl + AppSpacing.lg,
    FullHistoryChart.height,
    AppSpacing.xxxl + AppSpacing.lg,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<NetWorthReportBloc, NetWorthReportState>(
        builder: (context, state) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Header(state: state),
            Expanded(child: _body(context, state)),
          ],
        ),
      ),
    );
  }

  static Widget _body(BuildContext context, NetWorthReportState state) {
    final trend = state.trend;
    return switch (state.status) {
      ReportStatus.loading => const LoadingSkeleton(
          heights: skeletonHeights,
          label: NetWorthTexts.reportLoadingLabel,
        ),
      ReportStatus.failure => _scrollable(
          StatusMessage(
            icon: Icons.cloud_off_outlined,
            title: NetWorthTexts.reportLoadErrorTitle,
            message: state.error ?? '',
            action: FilledButton.icon(
              key: retryKey,
              onPressed: () => context
                  .read<NetWorthReportBloc>()
                  .add(const NetWorthReportLoadRequested()),
              icon: const Icon(Icons.refresh),
              label: const Text(NetWorthTexts.retry),
            ),
          ),
        ),
      ReportStatus.loaded when trend == null || trend.isEmpty =>
        _scrollable(const _EmptyReport()),
      ReportStatus.loaded => _Report(trend: trend!),
    };
  }

  static Widget _scrollable(Widget child) =>
      SingleChildScrollView(child: child);
}

class _Header extends StatelessWidget {
  const _Header({required this.state});

  final NetWorthReportState state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ScreenTitleRow(
            title: AppRoute.netWorthReport.title,
            backTooltip: NetWorthTexts.backToNetWorth,
            parent: AppRoute.netWorth.name,
          ),
          const SizedBox(height: AppSpacing.sm),
          TimeRangeSelector(
            selected: state.range,
            onChanged: (selected) => context
                .read<NetWorthReportBloc>()
                .add(NetWorthReportRangeChanged(selected)),
          ),
        ],
      ),
    );
  }
}

class _EmptyReport extends StatelessWidget {
  const _EmptyReport();

  @override
  Widget build(BuildContext context) {
    return StatusMessage(
      icon: Icons.show_chart,
      title: NetWorthTexts.reportEmptyTitle,
      message: NetWorthTexts.reportEmptyMessage,
      action: FilledButton.icon(
        key: NetWorthReportScreen.recordSnapshotKey,
        onPressed: () => context.goNamed(AppRoute.netWorth.name),
        icon: const Icon(Icons.add_chart),
        label: const Text(NetWorthTexts.recordSnapshot),
      ),
    );
  }
}

class _Report extends StatelessWidget {
  const _Report({required this.trend});

  final NetWorthTrend trend;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        NetWorthReportSummary(trend: trend),
        const SizedBox(height: AppSpacing.md),
        NetWorthReportChartCard(trend: trend),
        const SizedBox(height: AppSpacing.md),
        NetWorthReportTableCard(trend: trend),
      ],
    );
  }
}
