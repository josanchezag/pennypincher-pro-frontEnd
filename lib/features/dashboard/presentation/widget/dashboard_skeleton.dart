import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/widgets/loading_skeleton.dart';
import 'package:pennypincher_pro/core/widgets/responsive_card_row.dart';
import 'package:pennypincher_pro/features/dashboard/presentation/dashboard_texts.dart';
import 'package:pennypincher_pro/features/dashboard/presentation/widget/goal_progress_chip.dart';
import 'package:pennypincher_pro/features/dashboard/presentation/widget/user_avatar.dart';

/// Placeholders with the shape of every dashboard section, announced to
/// screen readers as loading.
class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

  static const double cardHeight = 240;
  static const double actionsHeight = 96;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: DashboardTexts.loadingLabel,
      liveRegion: true,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.md),
        children: const [
          _HeaderSkeleton(),
          SizedBox(height: AppSpacing.lg),
          ResponsiveCardRow(
            children: [
              SkeletonBox(height: cardHeight),
              SkeletonBox(height: cardHeight),
            ],
          ),
          SizedBox(height: AppSpacing.lg),
          SkeletonBox(height: GoalProgressChip.height),
          SizedBox(height: AppSpacing.lg),
          SkeletonBox(height: actionsHeight),
        ],
      ),
    );
  }
}

/// Placeholder of the avatar and greeting.
class _HeaderSkeleton extends StatelessWidget {
  const _HeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        SkeletonBox(
          height: UserAvatar.radius * 2,
          width: UserAvatar.radius * 2,
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(child: SkeletonBox(height: AppSpacing.xl)),
      ],
    );
  }
}
