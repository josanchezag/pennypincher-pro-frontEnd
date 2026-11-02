import 'dart:async';

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'helpers/l10n.dart';

/// Every test runs in English unless it picks another language, so finders
/// can use the English texts; the Spanish ones are checked on purpose.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  await initializeDateFormatting();
  Intl.defaultLocale = testLocale.languageCode;
  await testMain();
}
