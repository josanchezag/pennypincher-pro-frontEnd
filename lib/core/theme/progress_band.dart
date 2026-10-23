import 'package:flutter/painting.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';

/// Color bands of the progress toward a goal, from the highest: each one
/// starts at [fromPercent].
enum ProgressBand {
  nearlyThere(75, AppColors.success),
  halfway(50, AppColors.warning),
  underway(25, AppColors.brandPrimary),
  starting(0, AppColors.neutral);

  const ProgressBand(this.fromPercent, this.color);

  final double fromPercent;
  final Color color;

  static const int _tenths = 10;

  /// Absorbs the binary error of values such as `57.3 * 10`.
  static const double _epsilon = 1e-9;

  /// Band of a progress of [percent], from 0 to 100.
  static ProgressBand of(double percent) => values.firstWhere(
        (band) => percent >= band.fromPercent,
        orElse: () => starting,
      );

  /// [percent] cut to the one decimal shown, so the label never rounds up
  /// into the next band: 74.96 is shown as `74,9 %`, in amber.
  static double? shown(double? percent) => percent == null
      ? null
      : (percent * _tenths + _epsilon).floorToDouble() / _tenths;

  /// Color of a progress of [percent] as it is shown; grey when unknown.
  static Color colorOf(double? percent) => of(shown(percent) ?? 0).color;
}
