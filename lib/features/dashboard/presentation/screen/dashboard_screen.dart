import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/time/month_format.dart';
import 'package:pennypincher_pro/core/widgets/app_snackbar.dart';
import 'package:pennypincher_pro/core/widgets/money_format_scope.dart';
import 'package:pennypincher_pro/core/widgets/status_message.dart';
import 'package:pennypincher_pro/features/dashboard/domain/entity/snapshot_ant_cut_entity.dart';
import 'package:pennypincher_pro/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:pennypincher_pro/features/dashboard/presentation/widget/dashboard_content.dart';
import 'package:pennypincher_pro/features/dashboard/presentation/widget/dashboard_skeleton.dart';

/// `/dashboard`: the financial overview of the user, loaded with a single
/// request. Expects a [DashboardBloc] above it.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<DashboardBloc, DashboardState>(
        listenWhen: (_, current) => current.notice != null,
        listener: _report,
        builder: (context, state) => switch (state.status) {
          DashboardStatus.loading => const DashboardSkeleton(),
          DashboardStatus.failure => StatusMessage(
              icon: Icons.cloud_off_outlined,
              title: context.l10n.dashboardLoadErrorTitle,
              message: state.loadError ?? '',
              action: FilledButton.icon(
                onPressed: () => context
                    .read<DashboardBloc>()
                    .add(const DashboardLoadRequested()),
                icon: const Icon(Icons.refresh),
                label: Text(context.l10n.commonRetry),
              ),
            ),
          DashboardStatus.loaded => DashboardContent(state: state),
        },
      ),
    );
  }

  static void _report(BuildContext context, DashboardState state) {
    final message = state.noticeMessage ?? '';
    switch (state.notice!) {
      case DashboardNotice.snapshotSaved:
        _reportSnapshot(context, state);
      case DashboardNotice.snapshotFailed:
        AppSnackbar.showError(context, message);
      case DashboardNotice.refreshFailed:
        AppSnackbar.showError(
          context,
          context.l10n.dashboardRefreshFailed(message),
        );
    }
  }

  /// Confirms the snapshot and tells what happened to the ant expenses:
  /// how many went into the month's budget, or that the month needs a
  /// budget to close them (with a button that opens it). A cut that took
  /// nothing, or none reported, keeps the plain confirmation.
  static void _reportSnapshot(BuildContext context, DashboardState state) {
    final l10n = context.l10n;
    final cut = state.antCut;
    switch (cut) {
      case SnapshotAntCut(status: SnapshotAntCutStatus.noBudget):
        AppSnackbar.showSuccess(
          context,
          l10n.snapshotSavedNoBudget(MonthFormat.long.format(cut.month)),
          actionLabel: l10n.snapshotCreateBudget,
          onAction: () => context.goNamed(AppRoute.budgetOverview.name),
        );
      case SnapshotAntCut(tookExpenses: true):
        AppSnackbar.showSuccess(
          context,
          l10n.snapshotSavedAntCut(
            cut.itemsTaken,
            context.money.format(cut.amountTaken),
            MonthFormat.long.format(cut.month),
          ),
        );
      case _:
        AppSnackbar.showSuccess(
          context,
          l10n.snapshotSaved(
            MonthFormat.long.format(state.summary!.referenceMonth),
          ),
        );
    }
  }
}
