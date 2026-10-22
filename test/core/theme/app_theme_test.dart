import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_theme.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';

void main() {
  final theme = AppTheme.dark;

  group('AppTheme.dark', () {
    test('uses Material 3 with a dark brightness', () {
      expect(theme.useMaterial3, isTrue);
      expect(theme.brightness, Brightness.dark);
    });

    test('maps the palette to the color scheme', () {
      expect(theme.scaffoldBackgroundColor, AppColors.backgroundPrimary);
      expect(theme.colorScheme.primary, AppColors.brandPrimary);
      expect(theme.colorScheme.secondary, AppColors.accentGold);
      expect(theme.colorScheme.error, AppColors.error);
      expect(theme.colorScheme.surface, AppColors.backgroundSecondary);
      expect(theme.colorScheme.onSurface, AppColors.textPrimary);
    });

    test('uses the Inter type scale', () {
      expect(
        theme.textTheme.displayLarge?.fontFamily,
        AppTypography.fontFamily,
      );
      expect(theme.textTheme.displayLarge?.fontSize, 36);
      expect(theme.textTheme.headlineLarge?.fontSize, 28);
      expect(theme.textTheme.headlineMedium?.fontSize, 22);
      expect(theme.textTheme.headlineSmall?.fontSize, 18);
      expect(theme.textTheme.bodyLarge?.fontSize, 16);
      expect(theme.textTheme.bodyMedium?.fontSize, 14);
      expect(theme.textTheme.bodySmall?.fontSize, 12);
      expect(theme.textTheme.labelSmall?.fontSize, 11);
    });

    test('rounds cards with a 12 px radius', () {
      final shape = theme.cardTheme.shape! as RoundedRectangleBorder;
      expect(
        shape.borderRadius,
        const BorderRadius.all(Radius.circular(AppSpacing.radiusCard)),
      );
      expect(theme.cardTheme.color, AppColors.backgroundSecondary);
    });

    test('rounds inputs with an 8 px radius', () {
      final border = theme.inputDecorationTheme.border! as OutlineInputBorder;
      expect(
        border.borderRadius,
        const BorderRadius.all(Radius.circular(AppSpacing.radiusInput)),
      );
    });
  });

  test('navigation bar and rail use the same selected icon color', () {
    final barIcon = theme.navigationBarTheme.iconTheme!.resolve(
      {WidgetState.selected},
    );

    expect(barIcon?.color, AppColors.textOnBrand);
    expect(
      theme.navigationRailTheme.selectedIconTheme?.color,
      AppColors.textOnBrand,
    );
  });

  group('AppTypography', () {
    test('renders numbers with tabular figures in a monospace font', () {
      for (final style in [
        AppTypography.monoLarge,
        AppTypography.monoMedium,
        AppTypography.monoSmall,
      ]) {
        expect(style.fontFamily, AppTypography.monoFontFamily);
        expect(
          style.fontFeatures,
          contains(const FontFeature.tabularFigures()),
        );
      }
    });

    test('follows the weights of the type scale', () {
      expect(AppTypography.display.fontWeight, FontWeight.w600);
      expect(AppTypography.heading1.fontWeight, FontWeight.w600);
      expect(AppTypography.heading2.fontWeight, FontWeight.w500);
      expect(AppTypography.heading3.fontWeight, FontWeight.w500);
      expect(AppTypography.bodyLarge.fontWeight, FontWeight.w400);
      expect(AppTypography.label.fontWeight, FontWeight.w600);
    });
  });

  test('spacing scale is built on an 8 px base unit', () {
    expect(AppSpacing.baseUnit, 8);
    expect(
      [
        AppSpacing.xxs,
        AppSpacing.xs,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.xxl,
        AppSpacing.xxxl,
      ],
      [4, 8, 12, 16, 24, 32, 48, 64],
    );
    expect(AppSpacing.maxContentWidth, 1280);
  });
}
