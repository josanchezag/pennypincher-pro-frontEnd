/// Reads percentages typed by the user, as written in Colombia: `11`,
/// `11,5` or `11,25` (a dot is also accepted as decimal separator). Values
/// are held exactly as basis points, hundredths of a percent.
abstract final class PercentInput {
  static const int basisPointsPerPercent = 100;
  static const int basisPointsPerUnit = 10000;
  static const int _maxDecimals = 2;
  static const String _decimalComma = ',';

  /// Up to three whole digits and up to two decimals.
  static final RegExp _pattern = RegExp(r'^(\d{1,3})(?:[.,](\d{1,2}))?$');

  /// Basis points of [text], or null when it is not a percentage with at
  /// most two decimals.
  static int? tryParseBasisPoints(String text) {
    final match = _pattern.firstMatch(text.trim());
    if (match == null) {
      return null;
    }
    final decimals = (match.group(2) ?? '').padRight(_maxDecimals, '0');
    return int.parse(match.group(1)!) * basisPointsPerPercent +
        int.parse(decimals);
  }

  /// Fraction of one for [basisPoints]: `1150` becomes `0.115`.
  static double fractionOf(int basisPoints) => basisPoints / basisPointsPerUnit;

  /// Basis points of a [fraction] of one: `0.115` becomes `1150`.
  static int basisPointsOf(double fraction) =>
      (fraction * basisPointsPerUnit).round();

  /// Text to prefill an input, without trailing zeros: `11`, `11,5` or
  /// `11,25`.
  static String format(int basisPoints) {
    final whole = basisPoints ~/ basisPointsPerPercent;
    final hundredths = basisPoints % basisPointsPerPercent;
    if (hundredths == 0) {
      return '$whole';
    }
    final decimals = hundredths
        .toString()
        .padLeft(_maxDecimals, '0')
        .replaceFirst(RegExp(r'0$'), '');
    return '$whole$_decimalComma$decimals';
  }
}
