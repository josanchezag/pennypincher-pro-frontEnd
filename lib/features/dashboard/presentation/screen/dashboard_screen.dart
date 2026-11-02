import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/time/month_format.dart';
import 'package:pennypincher_pro/core/widgets/app_snackbar.dart';
import 'package:pennypincher_pro/core/widgets/status_message.dart';
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
        final month = state.summary!.referenceMonth;
        AppSnackbar.showSuccess(
          context,
          context.l10n.snapshotSaved(MonthFormat.long.format(month)),
        );
      case DashboardNotice.snapshotFailed:
        AppSnackbar.showError(context, message);
      case DashboardNotice.refreshFailed:
        AppSnackbar.showError(
          context,
          context.l10n.dashboardRefreshFailed(message),
        );
    }
  }
}
