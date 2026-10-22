import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';

/// Consistent snack bars of the design system.
abstract final class AppSnackbar {
  /// Replaces any visible snack bar with an error [message].
  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.errorMuted,
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
