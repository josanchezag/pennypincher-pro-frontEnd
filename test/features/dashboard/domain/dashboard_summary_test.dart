import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/dashboard/domain/entity/dashboard_summary_entity.dart';
import 'package:pennypincher_pro/features/dashboard/domain/entity/part_of_day.dart';
import 'package:pennypincher_pro/features/dashboard/domain/repository/dashboard_repository.dart';
import 'package:pennypincher_pro/features/dashboard/domain/usecase/dashboard_use_cases.dart';

import '../../../helpers/dashboard_fixtures.dart';

class _MockDashboardRepository extends Mock implements DashboardRepository {}

List<NetWorthPoint> _months(int count) => [
      for (var month = 1; month <= count; month++)
        NetWorthPoint(
          date: DateTime(2026, month),
          netWorth: Money.fromPesos(month),
        ),
    ];

void main() {
  group('UserProfile', () {
    const names = {
      'Josimar Sanchez': ('Josimar', 'JS'),
      'Josimar': ('Josimar', 'J'),
      '  ana   maría  de la Cruz ': ('ana', 'AC'),
      'Ada\tLovelace': ('Ada', 'AL'),
      '': ('', ''),
      '   ': ('', ''),
    };
    for (final MapEntry(key: name, value: (first, initials)) in names.entries) {
      test('reads "$name" as $first ($initials)', () {
        final user = UserProfile(name: name);

        expect(user.firstName, first);
        expect(user.initials, initials);
      });
    }
  });

  group('PartOfDay', () {
    final hours = {
      DateTime(2026, 10, 22, 4, 59): PartOfDay.evening,
      DateTime(2026, 10, 22, 5): PartOfDay.morning,
      DateTime(2026, 10, 22, 11, 59): PartOfDay.morning,
      DateTime(2026, 10, 22, 12): PartOfDay.afternoon,
      DateTime(2026, 10, 22, 17, 59): PartOfDay.afternoon,
      DateTime(2026, 10, 22, 18): PartOfDay.evening,
      DateTime(2026, 10, 22, 23, 59): PartOfDay.evening,
      DateTime(2026, 10, 22): PartOfDay.evening,
    };
    for (final MapEntry(key: time, value: period) in hours.entries) {
      test('is ${period.name} at ${time.hour}:${time.minute}', () {
        expect(PartOfDay.at(time), period);
      });
    }
  });

  group('DashboardSummary', () {
    test('is empty only without any data', () {
      expect(newUserSummary.isEmpty, isTrue);
      expect(dashboardSummary.isEmpty, isFalse);
      expect(
        newUserSummary.copyWith(goals: dashboardSummary.goals).isEmpty,
        isFalse,
      );
      expect(
        newUserSummary
            .copyWith(recentSnapshots: dashboardSummary.recentSnapshots)
            .isEmpty,
        isFalse,
      );
      expect(
        newUserSummary.copyWith(budget: dashboardSummary.budget).isEmpty,
        isFalse,
      );
      expect(
        newUserSummary
            .copyWith(
              netWorth: newUserSummary.netWorth.copyWith(
                totalLiabilities: const Money.fromPesos(1),
              ),
            )
            .isEmpty,
        isFalse,
      );
    });

    test('draws the sparkline with the last six months', () {
      final summary = newUserSummary.copyWith(recentSnapshots: _months(12));

      expect(summary.sparkline.map((point) => point.date.month), [
        7,
        8,
        9,
        10,
        11,
        12,
      ]);
      expect(
        newUserSummary.copyWith(recentSnapshots: _months(3)).sparkline,
        _months(3),
      );
    });
  });

  group('use cases', () {
    late _MockDashboardRepository repository;

    setUp(() => repository = _MockDashboardRepository());

    test('load and record the month of the given day', () async {
      when(() => repository.getSummary(DateTime(2026, 10)))
          .thenAnswer((_) async => Right(dashboardSummary));
      when(() => repository.recordSnapshot(DateTime(2026, 10)))
          .thenAnswer((_) async => const Right(unit));

      final summary =
          await GetDashboardSummary(repository)(DateTime(2026, 10, 22, 9));
      final saved =
          await RecordNetWorthSnapshot(repository)(DateTime(2026, 10, 31, 23));

      expect(summary, Right<Failure, DashboardSummary>(dashboardSummary));
      expect(saved, const Right<Failure, Unit>(unit));
    });
  });
}
