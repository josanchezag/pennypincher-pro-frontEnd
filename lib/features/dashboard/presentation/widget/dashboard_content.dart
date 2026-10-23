import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/widgets/responsive_card_row.dart';
import 'package:pennypincher_pro/features/dashboard/domain/entity/dashboard_summary_entity.dart';
import 'package:pennypincher_pro/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:pennypincher_pro/features/dashboard/presentation/dashboard_texts.dart';
import 'package:pennypincher_pro/features/dashboard/presentation/widget/budget_summary_card.dart';
import 'package:pennypincher_pro/features/dashboard/presentation/widget/dashboard_action_card.dart';
import 'package:pennypincher_pro/features/dashboard/presentation/widget/dashboard_header.dart';
import 'package:pennypincher_pro/features/dashboard/presentation/widget/goals_section.dart';
import 'package:pennypincher_pro/features/dashboard/presentation/widget/net_worth_summary_card.dart';
import 'package:pennypincher_pro/features/dashboard/presentation/widget/quick_actions_row.dart';

/// The loaded dashboard, refreshed by pulling it down: the header, the net
/// worth and budget cards (side by side from tablet up), the goals and
/// the quick actions. A user without any data sees an onboarding card
/// instead of the cards and goals.
class DashboardContent extends StatelessWidget {
  const DashboardContent({required this.state, super.key});

  static const Key onboardingKey = Key('dashboard-onboarding');

  final DashboardState state;

  @override
  Widget build(BuildContext context) {
    final summary = state.summary!;
    return RefreshIndicator(
      onRefresh: () => _refresh(context.read<DashboardBloc>()),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          DashboardHeader(state: state),
          const SizedBox(height: AppSpacing.lg),
          if (summary.isEmpty)
            const DashboardActionCard(
              key: onboardingKey,
              icon: Icons.account_balance_wallet_outlined,
              title: DashboardTexts.onboardingTitle,
              message: DashboardTexts.onboardingMessage,
              route: AppRoute.netWorthAssets,
            )
          else
            ..._overview(summary),
          const SizedBox(height: AppSpacing.lg),
          QuickActionsRow(state: state),
        ],
      ),
    );
  }

  static List<Widget> _overview(DashboardSummary summary) => [
        ResponsiveCardRow(
          children: [
            NetWorthSummaryCard(
              netWorth: summary.netWorth,
              sparkline: summary.sparkline,
            ),
            BudgetSummaryCard(budget: summary.budget),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        GoalsSection(goals: summary.goals),
      ];

  /// Completes once the refresh it starts has finished.
  static Future<void> _refresh(DashboardBloc bloc) async {
    bloc.add(const DashboardRefreshRequested());
    await bloc.stream.firstWhere(
      (state) => !state.isBusy,
      orElse: () => bloc.state,
    );
  }
}
