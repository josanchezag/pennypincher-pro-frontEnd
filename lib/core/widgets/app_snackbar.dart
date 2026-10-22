import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';

/// Consistent snack bars of the design system.
abstract final class AppSnackbar {
  /// Replaces any visible snack bar with an error [message].
  static void showError(BuildContext context, String message) =>
      _show(context, message, AppColors.errorMuted);

  /// Replaces any visible snack bar with a confirmation [message].
  static void showSuccess(BuildContext context, String message) =>
      _show(context, message, AppColors.successMuted);

  static void _show(BuildContext context, String message, Color background) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: background,
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
