import 'package:pennypincher_pro/core/crud/data/item_json_codec.dart';
import 'package:pennypincher_pro/core/network/api_envelope.dart';
import 'package:pennypincher_pro/core/utils/api_enum.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/financial_goal_entity.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_income_mode.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_level.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/reference_return.dart';

/// Keys of the financial goal JSON.
abstract final class GoalJsonKeys {
  static const String level = 'level';
  static const String levelDescription = 'levelDescription';
  static const String targetAmount = 'targetAmount';
  static const String monthlyInvestment = 'monthlyInvestment';
  static const String expectedAnnualReturn = 'expectedAnnualReturn';
  static const String targetYears = 'targetYears';
  static const String incomeMode = 'incomeMode';
  static const String incomeFactor = 'incomeFactor';
  static const String monthlyIncomeBasis = 'monthlyIncomeBasis';
  static const String desiredMonthlyIncome = 'desiredMonthlyIncome';
  static const String requiredMonthlyInvestment = 'requiredMonthlyInvestment';
  static const String referenceReturn = 'referenceReturn';
  static const String annualRate = 'annualRate';
  static const String annualAmount = 'annualAmount';
  static const String monthlyAmount = 'monthlyAmount';
}

/// JSON shape of a goal: `{id, name, level, levelDescription,
/// targetAmount, monthlyInvestment, expectedAnnualReturn, targetYears,
/// incomeMode, incomeFactor, monthlyIncomeBasis, desiredMonthlyIncome,
/// requiredMonthlyInvestment, referenceReturn}`. The income fields are
/// read tolerantly: a backend that does not send them yet gives a manual
/// goal without them.
class GoalJsonCodec implements ItemJsonCodec<FinancialGoal, GoalDraft> {
  const GoalJsonCodec();

  /// Level given to a value this client does not know yet.
  static const GoalLevel fallbackLevel = GoalLevel.absoluteFreedom;

  /// Mode of a missing value or one this client does not know yet.
  static const GoalIncomeMode fallbackIncomeMode = GoalIncomeMode.manual;

  static GoalLevel parseLevel(Object? json) =>
      ApiEnum.parse(GoalLevel.values, json, fallback: fallbackLevel);

  static GoalIncomeMode parseIncomeMode(Object? json) => json == null
      ? fallbackIncomeMode
      : ApiEnum.parse(
          GoalIncomeMode.values,
          json,
          fallback: fallbackIncomeMode,
        );

  static ReferenceReturn? parseReferenceReturn(Object? json) => switch (json) {
        final JsonMap map => ReferenceReturn(
            annualRate: (map[GoalJsonKeys.annualRate] as num).toDouble(),
            annualAmount: Money.fromJson(map[GoalJsonKeys.annualAmount]),
            monthlyAmount: Money.fromJson(map[GoalJsonKeys.monthlyAmount]),
          ),
        _ => null,
      };

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
        incomeMode: parseIncomeMode(json[GoalJsonKeys.incomeMode]),
        incomeFactor: (json[GoalJsonKeys.incomeFactor] as num?)?.toDouble(),
        monthlyIncomeBasis:
            Money.fromOptionalJson(json[GoalJsonKeys.monthlyIncomeBasis]),
        desiredMonthlyIncome:
            Money.fromOptionalJson(json[GoalJsonKeys.desiredMonthlyIncome]),
        requiredMonthlyInvestment: Money.fromOptionalJson(
          json[GoalJsonKeys.requiredMonthlyInvestment],
        ),
        referenceReturn:
            parseReferenceReturn(json[GoalJsonKeys.referenceReturn]),
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
