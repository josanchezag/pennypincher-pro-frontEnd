import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/net_worth_snapshot_entity.dart';

import '../../../helpers/net_worth_fixtures.dart';

void main() {
  group('NetWorthSnapshot', () {
    test('dates a snapshot on the first day of its month', () {
      expect(
        NetWorthSnapshot.monthOf(DateTime(2026, 10, 22, 18, 30)),
        DateTime(2026, 10),
      );
      expect(september.isSameMonth(DateTime(2026, 9, 30)), isTrue);
      expect(september.isSameMonth(DateTime(2026, 10)), isFalse);
    });

    test('finds the latest snapshot before a month', () {
      final october = snapshotOf(2026, 10, 1);
      final history = [august, september, october];

      expect(
        NetWorthSnapshot.latestBefore(history, DateTime(2026, 10, 22)),
        september,
      );
      expect(NetWorthSnapshot.latestBefore(history, DateTime(2026, 8)), isNull);
      expect(NetWorthSnapshot.latestBefore([], DateTime(2026, 8)), isNull);
    });

    test('merges a snapshot, replacing its month and keeping the order', () {
      final recalculated = snapshotOf(2026, 8, 166000000);
      final october = snapshotOf(2026, 10, 1);

      expect(
        NetWorthSnapshot.merge([august, september], recalculated),
        [recalculated, september],
      );
      expect(
        NetWorthSnapshot.merge([august, september], october),
        [august, september, october],
      );
    });
  });
}
