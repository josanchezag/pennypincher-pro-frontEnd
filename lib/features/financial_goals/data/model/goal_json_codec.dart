import 'package:pennypincher_pro/core/crud/data/item_json_codec.dart';
import 'package:pennypincher_pro/core/network/api_envelope.dart';
import 'package:pennypincher_pro/core/utils/api_enum.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/financial_goal_entity.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_level.dart';

/// Keys of the financial goal JSON.
abstract final class GoalJsonKeys {
  static const String level = 'level';
  static const String levelDescription = 'levelDescription';
  static const String targetAmount = 'targetAmount';
  static const String monthlyInvestment = 'monthlyInvestment';
  static const String expectedAnnualReturn = 'expectedAnnualReturn';
  static const String targetYears = 'targetYears';
}

/// JSON shape of a goal: `{id, name, level, levelDescription,
/// targetAmount, monthlyInvestment, expectedAnnualReturn, targetYears}`.
class GoalJsonCodec implements ItemJsonCodec<FinancialGoal, GoalDraft> {
  const GoalJsonCodec();

  /// Level given to a value this client does not know yet.
  static const GoalLevel fallbackLevel = GoalLevel.absoluteFreedom;

  static GoalLevel parseLevel(Object? json) =>
      ApiEnum.parse(GoalLevel.values, json, fallback: fallbackLevel);

  @override
  FinancialGoal fromJson(JsonMap json) => FinancialGoal(
        id: json[ItemJsonKeys.id] as String,
        name: json[ItemJsonKeys.name] as String,
        level: parseLevel(json[GoalJsonKeys.level]),
        levelDescription: json[GoalJsonKeys.levelDescription] as String,
        targetAmount: Money.fromJson(json[GoalJsonKeys.targetAmount]),
        monthlyInvestment: Money.fromJson(json[GoalJsonKeys.monthlyInvestment]),
        expectedAnnualReturn:
            (json[GoalJsonKeys.expectedAnnualReturn] as num).toDouble(),
        targetYears: json[GoalJsonKeys.targetYears] as int?,
      );

  @override
  JsonMap toJson(GoalDraft draft) => {
        ItemJsonKeys.name: draft.name,
        GoalJsonKeys.level: ApiEnum.nameOf(draft.level),
        GoalJsonKeys.targetAmount: draft.targetAmount.toJson(),
        GoalJsonKeys.monthlyInvestment: draft.monthlyInvestment.toJson(),
        GoalJsonKeys.expectedAnnualReturn: draft.expectedAnnualReturn,
        GoalJsonKeys.targetYears: draft.targetYears,
      };
}
