import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/halfway_milestone.dart';

import '../../../helpers/goal_fixtures.dart';

void main() {
  test('finds the goals that passed half of their target', () {
    final crossed = HalfwayMilestone.crossedBetween(
      [withProgress(security, 49.99), withProgress(independence, 41.66)],
      [withProgress(security, 50), withProgress(independence, 45)],
    );

    expect(crossed, {'g1'});
  });

  test('ignores goals that were already past half or went back', () {
    final crossed = HalfwayMilestone.crossedBetween(
      [withProgress(security, 55), withProgress(independence, 60)],
      [withProgress(security, 70), withProgress(independence, 40)],
    );

    expect(crossed, isEmpty);
  });

  test('ignores new goals and goals without progress', () {
    final crossed = HalfwayMilestone.crossedBetween(
      [security.copyWith(projection: null)],
      [withProgress(security, 80), withProgress(independence, 75)],
    );

    expect(crossed, isEmpty);
  });

  test('a projection with no months left is already reached', () {
    final reached = security.projection!.copyWith(projectedMonthsToGoal: 0);

    expect(reached.alreadyReached, isTrue);
    expect(security.projection!.alreadyReached, isFalse);
    expect(absolute.projection!.alreadyReached, isFalse);
  });
}
