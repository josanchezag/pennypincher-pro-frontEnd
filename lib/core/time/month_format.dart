import 'package:intl/intl.dart';

/// Ways a month is written in the interface, with the month names of the
/// current interface language ([Intl.defaultLocale]).
abstract final class MonthFormat {
  /// `October 2026` (`octubre 2026` in Spanish).
  static DateFormat get long => DateFormat('MMMM yyyy');

  /// `Oct 2026`.
  static DateFormat get short => DateFormat('MMM yyyy');

  /// `Oct '26`, for chart axes.
  static DateFormat get axis => DateFormat("MMM ''yy");

  /// `Oct\n'26`, for chart axes with little room per month.
  static DateFormat get axisStacked => DateFormat("MMM\n''yy");
}
