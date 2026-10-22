import 'package:intl/intl.dart';

/// Formats percentages for display with one decimal, as written in
/// Colombia: `42,7 %`.
abstract final class PercentFormatter {
  static const String locale = 'es_CO';
  static const String suffix = ' %';

  /// Shown when there is no value, such as a category without a target.
  static const String none = '—';

  static final NumberFormat _oneDecimal = NumberFormat('#,##0.0', locale);

  /// [percent] is in percent units: `42.67` becomes `42,7 %`.
  static String format(double percent) =>
      '${_oneDecimal.format(percent)}$suffix';

  /// Like [format], or [none] for `null`.
  static String formatOptional(double? percent) =>
      percent == null ? none : format(percent);
}
