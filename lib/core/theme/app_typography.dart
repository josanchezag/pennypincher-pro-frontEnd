import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';

/// Type scale of the design system. Inter for text, Roboto Mono with
/// tabular figures for currency values and numbers.
abstract final class AppTypography {
  static const String fontFamily = 'Inter';
  static const String monoFontFamily = 'RobotoMono';

  static const double displaySize = 36;
  static const double heading1Size = 28;
  static const double heading2Size = 22;
  static const double heading3Size = 18;
  static const double bodyLargeSize = 16;
  static const double bodyMediumSize = 14;
  static const double bodySmallSize = 12;
  static const double labelSize = 11;
  static const double labelLetterSpacing = 0.5;

  static const List<FontFeature> _tabularFigures = [
    FontFeature.tabularFigures(),
  ];

  static const TextStyle display = TextStyle(
    fontFamily: fontFamily,
    fontSize: displaySize,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static const TextStyle heading1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: heading1Size,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static const TextStyle heading2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: heading2Size,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );
  static const TextStyle heading3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: heading3Size,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: bodyLargeSize,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: bodyMediumSize,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );
  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: bodySmallSize,
    fontWeight: FontWeight.w400,
    color: AppColors.textTertiary,
  );
  static const TextStyle monoLarge = TextStyle(
    fontFamily: monoFontFamily,
    fontSize: bodyLargeSize,
    fontFeatures: _tabularFigures,
    color: AppColors.textPrimary,
  );
  static const TextStyle monoMedium = TextStyle(
    fontFamily: monoFontFamily,
    fontSize: bodyMediumSize,
    fontFeatures: _tabularFigures,
    color: AppColors.textPrimary,
  );
  static const TextStyle monoSmall = TextStyle(
    fontFamily: monoFontFamily,
    fontSize: bodySmallSize,
    fontFeatures: _tabularFigures,
    color: AppColors.textSecondary,
  );
  static const TextStyle label = TextStyle(
    fontFamily: fontFamily,
    fontSize: labelSize,
    fontWeight: FontWeight.w600,
    letterSpacing: labelLetterSpacing,
    color: AppColors.textSecondary,
  );

  static const TextTheme textTheme = TextTheme(
    displayLarge: display,
    displayMedium: display,
    displaySmall: display,
    headlineLarge: heading1,
    headlineMedium: heading2,
    headlineSmall: heading3,
    titleLarge: heading2,
    titleMedium: heading3,
    titleSmall: bodyLarge,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: bodyMedium,
    labelMedium: bodySmall,
    labelSmall: label,
  );
}
