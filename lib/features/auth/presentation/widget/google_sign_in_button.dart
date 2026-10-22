import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';

/// Full-width primary button that starts the Google sign-in flow. It is
/// disabled and shows a spinner while [isLoading].
class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({
    required this.onPressed,
    this.isLoading = false,
    super.key,
  });

  static const String label = 'Sign in with Google';
  static const String progressLabel = 'Signing in';
  static const double height = AppSpacing.xxl;
  static const double spinnerSize = AppSpacing.md;
  static const double spinnerStrokeWidth = 2;

  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: FilledButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading ? const _Spinner() : const Icon(Icons.login),
        label: const Text(label),
      ),
    );
  }
}

class _Spinner extends StatelessWidget {
  const _Spinner();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.square(
      dimension: GoogleSignInButton.spinnerSize,
      child: CircularProgressIndicator(
        semanticsLabel: GoogleSignInButton.progressLabel,
        strokeWidth: GoogleSignInButton.spinnerStrokeWidth,
        color: AppColors.textSecondary,
      ),
    );
  }
}
