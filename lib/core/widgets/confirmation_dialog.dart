import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';

/// Asks the user to confirm a destructive action.
abstract final class ConfirmationDialog {
  static const String cancelLabel = 'Cancel';

  /// Resolves to true only when the user pressed [confirmLabel].
  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(cancelLabel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }
}
