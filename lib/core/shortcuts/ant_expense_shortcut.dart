import 'package:flutter/widgets.dart';

/// Adds an ant expense from outside the ant expenses screen, such as the
/// dashboard quick actions, with the same sheet that screen uses.
/// Implemented by the ant expenses feature so other features do not depend
/// on it.
abstract interface class AntExpenseShortcut {
  /// Opens the add sheet over [context]. Resolves to true once an expense
  /// was saved, or to false when the sheet was closed without saving. A
  /// failed save is shown inside the sheet, which stays open.
  Future<bool> addExpense(BuildContext context);
}
