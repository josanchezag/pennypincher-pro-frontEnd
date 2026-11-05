import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/widgets/loading_skeleton.dart';

/// Grey placeholder of a part of the screen that is loading, announced
/// to screen readers.
class AntSectionSkeleton extends StatelessWidget {
  const AntSectionSkeleton({required this.heights, super.key});

  final List<double> heights;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: context.l10n.commonLoading,
      liveRegion: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (index, height) in heights.indexed) ...[
            if (index > 0) const SizedBox(height: AppSpacing.xs),
            SkeletonBox(height: height),
          ],
        ],
      ),
    );
  }
}

/// A part of the screen that could not load: what failed, why, and a
/// retry button.
class AntSectionError extends StatelessWidget {
  const AntSectionError({
    required this.title,
    required this.message,
    required this.onRetry,
    super.key,
  });

  final String title;
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      liveRegion: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.bodyMedium),
          Text(
            message,
            style: AppTypography.bodySmall.copyWith(color: AppColors.error),
          ),
          const SizedBox(height: AppSpacing.xs),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: Text(context.l10n.commonRetry),
          ),
        ],
      ),
    );
  }
}
