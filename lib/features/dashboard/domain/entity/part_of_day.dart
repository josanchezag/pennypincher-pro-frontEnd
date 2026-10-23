/// Part of the day that picks the dashboard greeting, by local hour:
/// morning from 05:00 to 11:59, afternoon from 12:00 to 17:59 and evening
/// otherwise.
enum PartOfDay {
  morning,
  afternoon,
  evening;

  static const int morningStartHour = 5;
  static const int afternoonStartHour = 12;
  static const int eveningStartHour = 18;

  static PartOfDay at(DateTime time) {
    final hour = time.hour;
    if (hour >= morningStartHour && hour < afternoonStartHour) {
      return morning;
    }
    if (hour >= afternoonStartHour && hour < eveningStartHour) {
      return afternoon;
    }
    return evening;
  }
}
