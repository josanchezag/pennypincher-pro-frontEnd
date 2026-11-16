import 'package:equatable/equatable.dart';
import 'package:pennypincher_pro/core/utils/money.dart';

/// What recording the snapshot of a month did with the open ant expenses.
enum SnapshotAntCutStatus {
  /// The month has a budget: the open ant expenses dated up to its end
  /// went into it.
  cut,

  /// The month has no budget yet, so the ant expenses stayed open.
  noBudget,
}

/// The ant expense cut made with a net worth snapshot (`antExpenseCut` of
/// `POST /net-worth/snapshots`).
final class SnapshotAntCut extends Equatable {
  const SnapshotAntCut({
    required this.status,
    required this.month,
    this.budgetId,
    this.itemsTaken = 0,
    this.amountTaken = Money.zero,
    this.antExpenseTotal,
  });

  final SnapshotAntCutStatus status;

  /// First day of the month of the snapshot.
  final DateTime month;

  /// Budget the cut went into; `null` without a budget.
  final String? budgetId;

  /// Expenses this cut took (0 when every one was already taken).
  final int itemsTaken;

  /// Sum of the expenses this cut took.
  final Money amountTaken;

  /// Ant expense total of the budget after the cut; `null` without one.
  final Money? antExpenseTotal;

  /// The cut moved at least one expense into the budget.
  bool get tookExpenses => status == SnapshotAntCutStatus.cut && itemsTaken > 0;

  @override
  List<Object?> get props =>
      [status, month, budgetId, itemsTaken, amountTaken, antExpenseTotal];
}
