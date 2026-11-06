import 'package:intl/intl.dart';

/// Ways a calendar day is written in the interface, in the current
/// interface language ([Intl.defaultLocale]).
abstract final class DayFormat {
  /// `Nov 5, 2026` (`5 nov 2026` in Spanish).
  static DateFormat get medium => DateFormat.yMMMd();

  /// `Nov 5` (`5 nov` in Spanish).
  static DateFormat get short => DateFormat.MMMd();

  /// `Thursday, November 5` (`jueves, 5 de noviembre` in Spanish).
  static DateFormat get weekday => DateFormat.MMMMEEEEd();

  /// Whether [a] and [b] fall on the same calendar day.
  static bool sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// The calendar day before [date], whatever the daylight saving changes.
  static DateTime previousDay(DateTime date) =>
      DateTime(date.year, date.month, date.day - 1);

  /// The calendar day of [date], without its time.
  static DateTime dayOf(DateTime date) =>
      DateTime(date.year, date.month, date.day);
}
