import 'dart:math' as math;

/// Helpers shared by the chart axes.
abstract final class ChartAxis {
  static const int defaultSteps = 4;
  static const double _decimalBase = 10;
  static const List<double> _niceFactors = [1, 2, 5, 10];

  /// Round step (1, 2 or 5 times a power of ten) that splits [range] into
  /// about [steps] parts; 1 for an empty range.
  static double niceInterval(double range, {int steps = defaultSteps}) {
    if (range <= 0) {
      return 1;
    }
    final rough = range / steps;
    final magnitude = math
        .pow(_decimalBase, (math.log(rough) / math.ln10).floor())
        .toDouble();
    final factor = _niceFactors.firstWhere((f) => f * magnitude >= rough);
    return factor * magnitude;
  }
}
