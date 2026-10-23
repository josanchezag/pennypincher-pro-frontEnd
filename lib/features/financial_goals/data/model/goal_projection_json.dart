import 'package:pennypincher_pro/core/network/api_envelope.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/financial_goals/data/model/goal_json_codec.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_projection_entity.dart';

/// Keys of the goal projection JSON besides those shared with the goal.
abstract final class ProjectionJsonKeys {
  static const String goalId = 'goalId';
  static const String name = 'name';
  static const String currentNetWorth = 'currentNetWorth';
  static const String progressAmount = 'progressAmount';
  static const String progressPercentage = 'progressPercentage';
  static const String remainingAmount = 'remainingAmount';
  static const String reachable = 'reachable';
  static const String projectedMonthsToGoal = 'projectedMonthsToGoal';
  static const String projectedYearsToGoal = 'projectedYearsToGoal';
  static const String projectedAchievementDate = 'projectedAchievementDate';
  static const String dataPoints = 'projectionDataPoints';
  static const String month = 'month';
  static const String date = 'date';
  static const String projectedValue = 'projectedValue';
}

/// Reads the projection of a goal as the API sends it. Throws
/// [TypeError] or [FormatException] on an unexpected shape.
abstract final class GoalProjectionJson {
  static GoalProjection fromJson(JsonMap json) => GoalProjection(
        goalId: json[ProjectionJsonKeys.goalId] as String,
        name: json[ProjectionJsonKeys.name] as String,
        level: GoalJsonCodec.parseLevel(json[GoalJsonKeys.level]),
        targetAmount: Money.fromJson(json[GoalJsonKeys.targetAmount]),
        currentNetWorth:
            Money.fromJson(json[ProjectionJsonKeys.currentNetWorth]),
        progressAmount: Money.fromJson(json[ProjectionJsonKeys.progressAmount]),
        progressPercentage:
            _double(json[ProjectionJsonKeys.progressPercentage]),
        remainingAmount:
            Money.fromJson(json[ProjectionJsonKeys.remainingAmount]),
        monthlyInvestment: Money.fromJson(json[GoalJsonKeys.monthlyInvestment]),
        expectedAnnualReturn: _double(json[GoalJsonKeys.expectedAnnualReturn]),
        targetYears: json[GoalJsonKeys.targetYears] as int?,
        reachable: json[ProjectionJsonKeys.reachable] as bool,
        projectedMonthsToGoal:
            json[ProjectionJsonKeys.projectedMonthsToGoal] as int?,
        projectedYearsToGoal:
            (json[ProjectionJsonKeys.projectedYearsToGoal] as num?)?.toDouble(),
        projectedAchievementDate:
            _date(json[ProjectionJsonKeys.projectedAchievementDate]),
        dataPoints: [
          for (final point in json[ProjectionJsonKeys.dataPoints] as List)
            _point(Map<String, dynamic>.from(point as Map)),
        ],
      );

  static ProjectionPoint _point(JsonMap json) => ProjectionPoint(
        month: json[ProjectionJsonKeys.month] as int,
        date: DateTime.parse(json[ProjectionJsonKeys.date] as String),
        projectedValue: Money.fromJson(json[ProjectionJsonKeys.projectedValue]),
      );

  static double _double(Object? json) => (json as num).toDouble();

  static DateTime? _date(Object? json) =>
      json == null ? null : DateTime.parse(json as String);
}
