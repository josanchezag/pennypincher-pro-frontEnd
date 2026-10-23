import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/theme/app_breakpoints.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/features/dashboard/domain/entity/dashboard_summary_entity.dart';
import 'package:pennypincher_pro/features/dashboard/presentation/dashboard_texts.dart';
import 'package:pennypincher_pro/features/dashboard/presentation/widget/dashboard_action_card.dart';
import 'package:pennypincher_pro/features/dashboard/presentation/widget/dashboard_section.dart';
import 'package:pennypincher_pro/features/dashboard/presentation/widget/goal_progress_chip.dart';

/// Progress of every goal: chips in a horizontal list on mobile screens and
/// in a grid on wider ones (two per row on tablet, four on desktop), or a
/// card that leads to the goals screen while there are none.
class GoalsSection extends StatelessWidget {
  const GoalsSection({required this.goals, super.key});

  static const Key listKey = Key('dashboard-goals-list');
  static const double mobileChipWidth = 200;
  static const int tabletColumns = 2;
  static const int desktopColumns = 4;

  final List<GoalSummary> goals;

  @override
  Widget build(BuildContext context) {
    return DashboardSection(
      title: DashboardTexts.goalsTitle,
      child: goals.isEmpty
          ? const DashboardActionCard(
              icon: Icons.flag_outlined,
              title: DashboardTexts.firstGoalTitle,
              message: DashboardTexts.firstGoalMessage,
              route: AppRoute.goals,
            )
          : _chips(
              context,
              ScreenSize.fromWidth(MediaQuery.sizeOf(context).width),
            ),
    );
  }

  Widget _chips(BuildContext context, ScreenSize size) {
    final extent = GoalProgressChip.extentOf(context);
    final chips = [
      for (final goal in goals)
        SizedBox(height: extent, child: GoalProgressChip(goal: goal)),
    ];
    return switch (size) {
      ScreenSize.mobile => SizedBox(
          height: extent,
          child: ListView.separated(
            key: listKey,
            scrollDirection: Axis.horizontal,
            itemCount: chips.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (_, index) =>
                SizedBox(width: mobileChipWidth, child: chips[index]),
          ),
        ),
      ScreenSize.tablet => TileGrid(columns: tabletColumns, children: chips),
      ScreenSize.desktop => TileGrid(columns: desktopColumns, children: chips),
    };
  }
}
