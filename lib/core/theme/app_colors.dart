import 'package:flutter/painting.dart';

/// Color palette of the PennyPincher Pro design system.
abstract final class AppColors {
  // Backgrounds
  static const Color backgroundPrimary = Color(0xFF0D1117);
  static const Color backgroundSecondary = Color(0xFF161B22);
  static const Color backgroundTertiary = Color(0xFF1C2128);
  static const Color backgroundModal = Color(0xFF21262D);

  // Brand
  static const Color brandPrimary = Color(0xFF2563EB);
  static const Color brandPrimaryHover = Color(0xFF1D4ED8);

  // Accent
  static const Color accentGold = Color(0xFFF59E0B);
  static const Color accentGoldMuted = Color(0xFF92400E);

  // Semantic
  static const Color success = Color(0xFF10B981);
  static const Color successMuted = Color(0xFF064E3B);
  static const Color error = Color(0xFFEF4444);
  static const Color errorMuted = Color(0xFF7F1D1D);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningMuted = Color(0xFF78350F);
  static const Color neutral = Color(0xFF6B7280);

  // Text
  static const Color textPrimary = Color(0xFFE6EDF3);
  static const Color textSecondary = Color(0xFF8B949E);
  static const Color textTertiary = Color(0xFF6E7681);
  static const Color textOnBrand = Color(0xFFFFFFFF);

  // Borders
  static const Color borderDefault = Color(0xFF30363D);
  static const Color borderMuted = Color(0xFF21262D);
  static const Color borderSubtle = Color(0xFF161B22);

  // Net worth chart
  static const Color chartLinePositive = Color(0xFF10B981);
  static const Color chartLineNegative = Color(0xFFEF4444);
  static const Color chartGradientStart = Color(0x3310B981);
  static const Color chartGradientEnd = Color(0x0010B981);
}
