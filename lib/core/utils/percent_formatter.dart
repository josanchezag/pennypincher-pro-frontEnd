import 'package:intl/intl.dart';

/// Formats percentages for display with one decimal, in the interface
/// language ([Intl.defaultLocale], kept by `LocaleCubit`): `42,7 %` in
/// Spanish, as written in Colombia, and `42.7%` in English.
abstract final class PercentFormatter {
  static const String _english = 'en';
  static const String _spanishSuffix = '\u00A0%';
  static const String _englishSuffix = '%';

  /// Shown when there is no value, such as a category without a target.
  static const String none = '—';

  static final NumberFormat _spanishDecimal = NumberFormat('#,##0.0', 'es_CO');
  static final NumberFormat _englishDecimal = NumberFormat('#,##0.0', 'en_US');

  static bool get _isEnglish =>
      Intl.shortLocale(Intl.getCurrentLocale()) == _english;

  /// [percent] is in percent units: `42.67` becomes `42,7 %` or `42.7%`.
  static String format(double percent) => _isEnglish
      ? '${_englishDecimal.format(percent)}$_englishSuffix'
      : '${_spanishDecimal.format(percent)}$_spanishSuffix';

  /// Like [format], or [none] for `null`.
  static String formatOptional(double? percent) =>
      percent == null ? none : format(percent);
}
