import 'package:injectable/injectable.dart';

/// Source of the current time, replaced by a fixed clock in tests.
abstract interface class Clock {
  DateTime now();
}

@LazySingleton(as: Clock)
class SystemClock implements Clock {
  @override
  DateTime now() => DateTime.now();
}
