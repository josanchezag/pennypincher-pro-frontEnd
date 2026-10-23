import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/features/dashboard/domain/entity/dashboard_summary_entity.dart';

/// Google picture of the user over a disc with their initials, which stay
/// visible when there is no picture or it cannot be loaded. Decorative for
/// screen readers: the greeting next to it names the user.
class UserAvatar extends StatelessWidget {
  const UserAvatar({required this.profile, super.key});

  static const double radius = AppSpacing.lg;

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final url = profile.pictureUrl;
    return ExcludeSemantics(
      child: CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.brandPrimary,
        foregroundImage: url == null ? null : NetworkImage(url),
        onForegroundImageError: url == null ? null : _keepInitials,
        child: Text(
          profile.initials,
          style: AppTypography.heading3.copyWith(color: AppColors.textOnBrand),
        ),
      ),
    );
  }

  /// A picture that fails to load is not drawn, so the initials show.
  static void _keepInitials(Object error, StackTrace? stackTrace) {}
}
