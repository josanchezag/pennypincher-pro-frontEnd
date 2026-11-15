import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/shortcuts/ant_expense_shortcut.dart';
import 'package:pennypincher_pro/core/theme/app_breakpoints.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/widgets/app_snackbar.dart';
import 'package:pennypincher_pro/core/widgets/button_progress_icon.dart';
import 'package:pennypincher_pro/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:pennypincher_pro/features/dashboard/presentation/widget/dashboard_section.dart';

/// The five quick actions: add an ant expense without leaving the
/// dashboard, record this month's snapshot (disabled while the dashboard
/// is busy), add an expense and open the two reports. On mobile the ant
/// expense takes the whole first row and the other four go two per row;
/// on wider screens all five share one row.
class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({required this.state, super.key});

  static const Key antExpenseKey = Key('dashboard-add-ant-expense');
  static const Key recordSnapshotKey = Key('dashboard-record-snapshot');
  static const int mobileColumns = 2;
  static const int wideColumns = 5;

  final DashboardState state;

  @override
  Widget build(BuildContext context) {
    return DashboardSection(
      title: context.l10n.dashboardQuickActions,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final antExpense = _antExpense(context);
          final others = _others(context);
          if (ScreenSize.fromWidth(constraints.maxWidth) != ScreenSize.mobile) {
            return TileGrid(
              columns: wideColumns,
              children: [antExpense, ...others],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              antExpense,
              const SizedBox(height: TileGrid.gap),
              TileGrid(columns: mobileColumns, children: others),
            ],
          );
        },
      ),
    );
  }

  Widget _antExpense(BuildContext context) => _QuickAction(
        key: antExpenseKey,
        icon: Icons.local_cafe_outlined,
        label: context.l10n.dashboardAntExpense,
        onTap: () => _addAntExpense(context),
      );

  /// Opens the ant expense add sheet over the dashboard and confirms a
  /// saved expense; a failed save stays in the sheet.
  static Future<void> _addAntExpense(BuildContext context) async {
    final saved = await context.read<AntExpenseShortcut>().addExpense(context);
    if (saved && context.mounted) {
      AppSnackbar.showSuccess(context, context.l10n.dashboardAntExpenseAdded);
    }
  }

  List<Widget> _others(BuildContext context) => [
        _QuickAction(
          key: recordSnapshotKey,
          icon: Icons.add_chart,
          label: context.l10n.recordSnapshot,
          busy: state.recordingSnapshot,
          onTap: state.isBusy
              ? null
              : () => context
                  .read<DashboardBloc>()
                  .add(const DashboardSnapshotRequested()),
        ),
        _link(
          context,
          Icons.receipt_long_outlined,
          context.l10n.dashboardAddExpense,
          AppRoute.expenses,
        ),
        _link(
          context,
          Icons.show_chart,
          context.l10n.dashboardNetWorthReport,
          AppRoute.netWorthReport,
        ),
        _link(
          context,
          Icons.bar_chart,
          context.l10n.dashboardBudgetComparison,
          AppRoute.budgetComparison,
        ),
      ];

  static Widget _link(
    BuildContext context,
    IconData icon,
    String label,
    AppRoute route,
  ) =>
      _QuickAction(
        icon: icon,
        label: label,
        onTap: () => context.goNamed(route.name),
      );
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.busy = false,
    super.key,
  });

  /// Height at the default text size, for a label on two lines.
  static const double height = 96;
  static const int labelLines = 2;

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.textScalerOf(context).scale(height),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Semantics(
          button: true,
          enabled: onTap != null,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: _QuickActionContent(
                icon: icon,
                label: label,
                enabled: onTap != null,
                busy: busy,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Icon (or spinner while [busy]) above the label, dimmed when disabled.
class _QuickActionContent extends StatelessWidget {
  const _QuickActionContent({
    required this.icon,
    required this.label,
    required this.enabled,
    required this.busy,
  });

  final IconData icon;
  final String label;
  final bool enabled;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        busy
            ? const ButtonProgressIcon()
            : Icon(
                icon,
                color:
                    enabled ? AppColors.brandPrimary : AppColors.textTertiary,
              ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: AppTypography.bodyMedium.copyWith(
            color: enabled ? AppColors.textPrimary : null,
          ),
          textAlign: TextAlign.center,
          maxLines: _QuickAction.labelLines,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
