import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';

/// Static grey placeholder with the shape of content that is loading.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({required this.height, this.width, super.key});

  final double height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        color: AppColors.backgroundTertiary,
        borderRadius: BorderRadius.all(Radius.circular(AppSpacing.radiusCard)),
      ),
    );
  }
}

/// Column of [SkeletonBox]es announced to screen readers as [label].
class LoadingSkeleton extends StatelessWidget {
  const LoadingSkeleton({
    required this.heights,
    this.label = defaultLabel,
    super.key,
  });

  static const String defaultLabel = 'Loading';

  final List<double> heights;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      liveRegion: true,
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.md),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: heights.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
        itemBuilder: (_, index) => SkeletonBox(height: heights[index]),
      ),
    );
  }
}
