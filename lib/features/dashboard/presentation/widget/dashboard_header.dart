import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/time/month_format.dart';
import 'package:pennypincher_pro/core/widgets/button_progress_icon.dart';
import 'package:pennypincher_pro/features/dashboard/domain/entity/dashboard_summary_entity.dart';
import 'package:pennypincher_pro/features/dashboard/domain/entity/part_of_day.dart';
import 'package:pennypincher_pro/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:pennypincher_pro/features/dashboard/presentation/dashboard_texts.dart';
import 'package:pennypincher_pro/features/dashboard/presentation/widget/user_avatar.dart';

/// Avatar, greeting with the user's first name, the month shown and a
/// refresh button, disabled while the dashboard is busy.
class DashboardHeader extends StatelessWidget {
  const DashboardHeader({required this.state, super.key});

  static const Key refreshKey = Key('dashboard-refresh');

  final DashboardState state;

  /// `Good morning, Josimar`, or only the greeting without a name.
  static String greeting(PartOfDay period, UserProfile user) {
    final hello = DashboardTexts.greeting(period);
    final name = user.firstName;
    return name.isEmpty ? hello : '$hello, $name';
  }

  @override
  Widget build(BuildContext context) {
    final summary = state.summary!;
    return Row(
      children: [
        UserAvatar(profile: summary.user),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _Greeting(
            greeting: greeting(state.period, summary.user),
            month: summary.referenceMonth,
          ),
        ),
        _RefreshButton(state: state),
      ],
    );
  }
}

/// The greeting heading and the month shown.
class _Greeting extends StatelessWidget {
  const _Greeting({required this.greeting, required this.month});

  final String greeting;
  final DateTime month;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(greeting, style: AppTypography.heading1),
        ),
        Text(
          '${DashboardTexts.overviewPrefix} ${MonthFormat.long.format(month)}',
          style: AppTypography.bodyMedium,
        ),
      ],
    );
  }
}

/// Reloads the dashboard; a spinner while refreshing.
class _RefreshButton extends StatelessWidget {
  const _RefreshButton({required this.state});

  final DashboardState state;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: DashboardHeader.refreshKey,
      tooltip: DashboardTexts.refresh,
      onPressed: state.isBusy
          ? null
          : () => context
              .read<DashboardBloc>()
              .add(const DashboardRefreshRequested()),
      icon: state.refreshing
          ? const ButtonProgressIcon()
          : const Icon(Icons.refresh),
    );
  }
}
