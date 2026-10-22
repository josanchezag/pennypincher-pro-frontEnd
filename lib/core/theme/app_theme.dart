import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';

/// Material 3 dark theme built from the design system tokens.
abstract final class AppTheme {
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: _colorScheme,
        scaffoldBackgroundColor: AppColors.backgroundPrimary,
        canvasColor: AppColors.backgroundPrimary,
        fontFamily: AppTypography.fontFamily,
        textTheme: AppTypography.textTheme,
        appBarTheme: _appBarTheme,
        cardTheme: _cardTheme,
        dialogTheme: _dialogTheme,
        dividerTheme: _dividerTheme,
        filledButtonTheme: FilledButtonThemeData(style: _buttonStyle),
        elevatedButtonTheme: ElevatedButtonThemeData(style: _buttonStyle),
        outlinedButtonTheme: OutlinedButtonThemeData(style: _buttonStyle),
        inputDecorationTheme: _inputDecorationTheme,
        navigationBarTheme: _navigationBarTheme,
        navigationRailTheme: _navigationRailTheme,
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColors.brandPrimary,
        ),
      );

  static const ColorScheme _colorScheme = ColorScheme.dark(
    primary: AppColors.brandPrimary,
    onPrimary: AppColors.textOnBrand,
    primaryContainer: AppColors.brandPrimaryHover,
    onPrimaryContainer: AppColors.textOnBrand,
    secondary: AppColors.accentGold,
    onSecondary: AppColors.backgroundPrimary,
    secondaryContainer: AppColors.accentGoldMuted,
    tertiary: AppColors.success,
    tertiaryContainer: AppColors.successMuted,
    error: AppColors.error,
    onError: AppColors.textOnBrand,
    errorContainer: AppColors.errorMuted,
    surface: AppColors.backgroundSecondary,
    onSurface: AppColors.textPrimary,
    onSurfaceVariant: AppColors.textSecondary,
    surfaceContainerHighest: AppColors.backgroundTertiary,
    outline: AppColors.borderDefault,
    outlineVariant: AppColors.borderMuted,
  );

  static const RoundedRectangleBorder _buttonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(AppSpacing.radiusButton)),
  );

  static final ButtonStyle _buttonStyle = ButtonStyle(
    shape: WidgetStateProperty.all(_buttonShape),
    padding: WidgetStateProperty.all(
      const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
    ),
  );

  static const AppBarTheme _appBarTheme = AppBarTheme(
    backgroundColor: AppColors.backgroundSecondary,
    foregroundColor: AppColors.textPrimary,
    surfaceTintColor: AppColors.backgroundSecondary,
    titleTextStyle: AppTypography.heading3,
  );

  static const CardTheme _cardTheme = CardTheme(
    color: AppColors.backgroundSecondary,
    elevation: 0,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(AppSpacing.radiusCard)),
      side: BorderSide(color: AppColors.borderDefault),
    ),
  );

  static const DialogTheme _dialogTheme = DialogTheme(
    backgroundColor: AppColors.backgroundModal,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(AppSpacing.radiusCard)),
    ),
  );

  static const DividerThemeData _dividerTheme = DividerThemeData(
    color: AppColors.borderDefault,
    thickness: AppSpacing.borderWidth,
    space: AppSpacing.borderWidth,
  );

  static const OutlineInputBorder _inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(AppSpacing.radiusInput)),
    borderSide: BorderSide(color: AppColors.borderDefault),
  );

  static final InputDecorationTheme _inputDecorationTheme =
      InputDecorationTheme(
    filled: true,
    fillColor: AppColors.backgroundTertiary,
    border: _inputBorder,
    enabledBorder: _inputBorder,
    focusedBorder: _inputBorder.copyWith(
      borderSide: const BorderSide(color: AppColors.brandPrimary),
    ),
    errorBorder: _inputBorder.copyWith(
      borderSide: const BorderSide(color: AppColors.error),
    ),
    labelStyle: AppTypography.bodyMedium,
    hintStyle: AppTypography.bodyMedium,
    errorStyle: AppTypography.bodySmall.copyWith(color: AppColors.error),
  );

  static final NavigationBarThemeData _navigationBarTheme =
      NavigationBarThemeData(
    backgroundColor: AppColors.backgroundSecondary,
    indicatorColor: AppColors.brandPrimary,
    iconTheme: WidgetStateProperty.resolveWith(
      (states) => IconThemeData(
        color: states.contains(WidgetState.selected)
            ? AppColors.textOnBrand
            : AppColors.textSecondary,
      ),
    ),
  );

  static final NavigationRailThemeData _navigationRailTheme =
      NavigationRailThemeData(
    backgroundColor: AppColors.backgroundSecondary,
    indicatorColor: AppColors.brandPrimary,
    selectedLabelTextStyle: AppTypography.bodyMedium.copyWith(
      color: AppColors.textPrimary,
    ),
    unselectedLabelTextStyle: AppTypography.bodyMedium,
    selectedIconTheme: const IconThemeData(color: AppColors.textOnBrand),
    unselectedIconTheme: const IconThemeData(color: AppColors.textSecondary),
  );
}
