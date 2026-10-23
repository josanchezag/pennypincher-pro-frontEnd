import 'package:intl/intl.dart';

/// Ways a month is written in the interface.
abstract final class MonthFormat {
  /// `October 2026`.
  static final DateFormat long = DateFormat('MMMM yyyy');

  /// `Oct 2026`.
  static final DateFormat short = DateFormat('MMM yyyy');

  /// `Oct '26`, for chart axes.
  static final DateFormat axis = DateFormat("MMM ''yy");
}
