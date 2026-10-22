import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pennypincher_pro/core/utils/money.dart';

part 'net_worth_snapshot_entity.freezed.dart';

/// Net worth of one month, frozen when the snapshot was created.
@freezed
class NetWorthSnapshot with _$NetWorthSnapshot {
  const factory NetWorthSnapshot({
    required String id,

    /// First day of the month the snapshot belongs to.
    required DateTime snapshotDate,
    required Money totalAssets,
    required Money totalLiabilities,
    required Money netWorth,
  }) = _NetWorthSnapshot;

  const NetWorthSnapshot._();

  /// First day of the month of [date]: the date of its snapshot.
  static DateTime monthOf(DateTime date) => DateTime(date.year, date.month);

  bool isSameMonth(DateTime date) => snapshotDate == monthOf(date);

  /// The latest snapshot of [history] dated before [month], if any.
  static NetWorthSnapshot? latestBefore(
    List<NetWorthSnapshot> history,
    DateTime month,
  ) {
    final start = monthOf(month);
    final earlier = history.where((s) => s.snapshotDate.isBefore(start));
    return earlier.isEmpty
        ? null
        : earlier
            .reduce((a, b) => a.snapshotDate.isAfter(b.snapshotDate) ? a : b);
  }

  /// [history] with [snapshot] replacing the one of the same month, sorted
  /// from the oldest month.
  static List<NetWorthSnapshot> merge(
    List<NetWorthSnapshot> history,
    NetWorthSnapshot snapshot,
  ) =>
      [
        for (final item in history)
          if (!item.isSameMonth(snapshot.snapshotDate)) item,
        snapshot,
      ]..sort((a, b) => a.snapshotDate.compareTo(b.snapshotDate));
}
