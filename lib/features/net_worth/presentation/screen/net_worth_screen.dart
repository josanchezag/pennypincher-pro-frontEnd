import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/time/month_format.dart';
import 'package:pennypincher_pro/core/widgets/app_snackbar.dart';
import 'package:pennypincher_pro/core/widgets/button_progress_icon.dart';
import 'package:pennypincher_pro/core/widgets/loading_skeleton.dart';
import 'package:pennypincher_pro/core/widgets/status_message.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/bloc/net_worth_bloc.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/net_worth_texts.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/widget/net_worth_chart.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/widget/net_worth_history_card.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/widget/net_worth_links.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/widget/net_worth_stat_cards.dart';

/// `/net-worth`: live totals, the monthly history chart and links to the
/// assets and liabilities. Expects a [NetWorthBloc] above it.
class NetWorthScreen extends StatelessWidget {
  const NetWorthScreen({super.key});

  static const Key createSnapshotKey = Key('create-snapshot-button');
  static const List<double> skeletonHeights = [
    AppSpacing.xxl,
    AppSpacing.xxxl + AppSpacing.lg,
    AppSpacing.xxxl + AppSpacing.lg,
    AppSpacing.xxxl + AppSpacing.lg,
    NetWorthChart.height,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<NetWorthBloc, NetWorthState>(
        listenWhen: _snapshotFinished,
        listener: _reportSnapshot,
        builder: (context, state) => switch (state) {
          NetWorthLoading() => const LoadingSkeleton(
              heights: skeletonHeights,
              label: NetWorthTexts.loadingLabel,
            ),
          NetWorthLoadFailure(:final message) => StatusMessage(
              icon: Icons.cloud_off_outlined,
              title: NetWorthTexts.loadErrorTitle,
              message: message,
              action: FilledButton.icon(
                onPressed: () => context
                    .read<NetWorthBloc>()
                    .add(const NetWorthLoadRequested()),
                icon: const Icon(Icons.refresh),
                label: const Text(NetWorthTexts.retry),
              ),
            ),
          final NetWorthLoaded loaded => _Overview(state: loaded),
        },
      ),
    );
  }

  static bool _snapshotFinished(
    NetWorthState previous,
    NetWorthState current,
  ) =>
      previous is NetWorthLoaded &&
      previous.creatingSnapshot &&
      current is NetWorthLoaded &&
      !current.creatingSnapshot;

  static void _reportSnapshot(BuildContext context, NetWorthState state) {
    final loaded = state as NetWorthLoaded;
    final error = loaded.errorMessage;
    if (error != null) {
      AppSnackbar.showError(context, error);
      return;
    }
    AppSnackbar.showSuccess(
      context,
      '${NetWorthTexts.snapshotSavedPrefix} '
      '${MonthFormat.long.format(loaded.month)}',
    );
  }
}

class _Overview extends StatelessWidget {
  const _Overview({required this.state});

  final NetWorthLoaded state;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        _Header(creating: state.creatingSnapshot),
        const SizedBox(height: AppSpacing.md),
        NetWorthStatCards(
          current: state.current,
          baseline: state.baseline,
          change: state.change,
        ),
        const SizedBox(height: AppSpacing.md),
        NetWorthHistoryCard(history: state.history),
        const SizedBox(height: AppSpacing.md),
        const NetWorthLinks(),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.creating});

  final bool creating;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.sm,
      children: [
        Semantics(
          container: true,
          header: true,
          child: Text(AppRoute.netWorth.title, style: AppTypography.heading1),
        ),
        Semantics(container: true, child: _snapshotButton(context)),
      ],
    );
  }

  Widget _snapshotButton(BuildContext context) => Tooltip(
        message: NetWorthTexts.createSnapshotHint,
        child: FilledButton.icon(
          key: NetWorthScreen.createSnapshotKey,
          onPressed: creating
              ? null
              : () => context
                  .read<NetWorthBloc>()
                  .add(const NetWorthSnapshotRequested()),
          icon: creating
              ? const ButtonProgressIcon()
              : const Icon(Icons.add_chart),
          label: const Text(NetWorthTexts.createSnapshot),
        ),
      );
}
