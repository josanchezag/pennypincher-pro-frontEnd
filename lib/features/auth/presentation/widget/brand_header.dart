import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/constants/app_constants.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';

/// App logo, name and tagline in the brand colors.
class BrandHeader extends StatelessWidget {
  const BrandHeader({this.titleStyle = AppTypography.heading1, super.key});

  static const IconData logo = Icons.account_balance_wallet_outlined;
  static const double logoSize = AppSpacing.xxxl;

  final TextStyle titleStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(logo, size: logoSize, color: AppColors.accentGold),
        const SizedBox(height: AppSpacing.md),
        Text(
          AppConstants.appName,
          style: titleStyle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xs),
        const Text(
          AppConstants.tagline,
          style: AppTypography.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
