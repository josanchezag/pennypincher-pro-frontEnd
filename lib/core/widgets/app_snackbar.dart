import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';

/// Consistent snack bars of the design system.
abstract final class AppSnackbar {
  static const Duration _duration = Duration(milliseconds: 4000);
  static const Duration _durationWithAction = Duration(seconds: 8);

  /// Replaces any visible snack bar with an error [message].
  static void showError(BuildContext context, String message) =>
      _show(context, message, AppColors.errorMuted);

  /// Replaces any visible snack bar with a confirmation [message], with
  /// a button labelled [actionLabel] that runs [onAction] when both are
  /// given.
  static void showSuccess(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
  }) =>
      _show(
        context,
        message,
        AppColors.successMuted,
        action: actionLabel == null || onAction == null
            ? null
            : SnackBarAction(
                label: actionLabel,
                textColor: AppColors.textPrimary,
                onPressed: onAction,
              ),
      );

  static void _show(
    BuildContext context,
    String message,
    Color background, {
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: background,
          action: action,
          // Leaves time to read the message and reach its button.
          duration: action == null ? _duration : _durationWithAction,
          content: Text(
            message,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
      );
  }
}
