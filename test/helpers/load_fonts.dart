import 'package:flutter/services.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';

/// Bundled Inter weights; widget tests otherwise render with the Ahem font,
/// whose glyph widths hide real text overflow.
const List<String> _interAssets = [
  'assets/fonts/Inter-Regular.ttf',
  'assets/fonts/Inter-Medium.ttf',
  'assets/fonts/Inter-SemiBold.ttf',
];

/// Registers the bundled Inter font so layout tests measure real glyphs.
Future<void> loadAppFonts() async {
  final loader = FontLoader(AppTypography.fontFamily);
  for (final asset in _interAssets) {
    loader.addFont(rootBundle.load(asset));
  }
  await loader.load();
}
