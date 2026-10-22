/// Calendar months represented by their first day, as local dates.
abstract final class CalendarMonth {
  /// First day of the month of [date].
  static DateTime of(DateTime date) => DateTime(date.year, date.month);

  /// First day of the month [months] after (or before, when negative) the
  /// month of [date]. Crosses years: December plus one is January.
  static DateTime shift(DateTime date, int months) =>
      DateTime(date.year, date.month + months);
}
