import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';

/// Centered icon, title, message and optional action, used for empty,
/// placeholder and error views.
class StatusMessage extends StatelessWidget {
  const StatusMessage({
    required this.icon,
    required this.title,
    required this.message,
    this.action,
    this.illustration,
    super.key,
  });

  static const double iconSize = AppSpacing.xxl;

  final IconData icon;
  final String title;
  final String message;

  /// Optional button under the message, such as "Retry".
  final Widget? action;

  /// Optional artwork shown instead of [icon].
  final Widget? illustration;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            illustration ?? Icon(icon, size: iconSize, color: colors.primary),
            const SizedBox(height: AppSpacing.md),
            Text(
              title,
              style: AppTypography.heading1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              message,
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[
              const SizedBox(height: AppSpacing.lg),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
