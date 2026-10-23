import 'package:json_annotation/json_annotation.dart';
import 'package:pennypincher_pro/core/utils/api_enum.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/monthly_budget_entity.dart';

part 'monthly_budget_models.g.dart';

Money _money(Object? json) => Money.fromJson(json);

num? _optionalMoneyToJson(Money? money) => money?.toJson();

double _percent(num json) => json.toDouble();

/// JSON shape of one entry of `components`.
@JsonSerializable(createToJson: false)
class BudgetComponentModel {
  const BudgetComponentModel({
    required this.component,
    required this.amount,
    required this.percentage,
    this.idealPercentage,
  });

  factory BudgetComponentModel.fromJson(Map<String, dynamic> json) =>
      _$BudgetComponentModelFromJson(json);

  final String component;
  @JsonKey(fromJson: _money)
  final Money amount;
  @JsonKey(fromJson: _percent)
  final double percentage;
  final double? idealPercentage;

  /// The entity, or `null` for a component this client does not know yet.
  BudgetComponent? toEntity() {
    for (final type in BudgetComponentType.values) {
      if (ApiEnum.nameOf(type) == component) {
        return BudgetComponent(
          type: type,
          amount: amount,
          percentage: percentage,
          idealPercentage: idealPercentage,
        );
      }
    }
    return null;
  }
}

/// JSON shape of a monthly budget. The per-category percentage fields
/// repeat `components` and are not read.
@JsonSerializable(createToJson: false)
class MonthlyBudgetModel {
  const MonthlyBudgetModel({
    required this.id,
    required this.year,
    required this.month,
    required this.totalIncome,
    required this.totalExpenses,
    required this.monthlyCashFlow,
    required this.components,
    this.exchangeRate,
    this.workDays,
  });

  factory MonthlyBudgetModel.fromJson(Map<String, dynamic> json) =>
      _$MonthlyBudgetModelFromJson(json);

  final String id;
  final int year;
  final int month;
  @JsonKey(fromJson: Money.fromOptionalJson)
  final Money? exchangeRate;
  final int? workDays;
  @JsonKey(fromJson: _money)
  final Money totalIncome;
  @JsonKey(fromJson: _money)
  final Money totalExpenses;
  @JsonKey(fromJson: _money)
  final Money monthlyCashFlow;
  final List<BudgetComponentModel> components;

  MonthlyBudget toEntity() => MonthlyBudget(
        id: id,
        month: DateTime(year, month),
        settings:
            BudgetSettings(exchangeRate: exchangeRate, workDays: workDays),
        totalIncome: totalIncome,
        totalExpenses: totalExpenses,
        monthlyCashFlow: monthlyCashFlow,
        components: [
          for (final component in components) component.toEntity(),
        ].nonNulls.toList(),
      );
}

/// Body of `POST /monthly-budgets`.
@JsonSerializable(createFactory: false)
class CreateBudgetRequestModel {
  CreateBudgetRequestModel(DateTime month)
      : year = month.year,
        month = month.month;

  final int year;
  final int month;

  Map<String, dynamic> toJson() => _$CreateBudgetRequestModelToJson(this);
}

/// Body of `PUT /monthly-budgets/{id}`: both values are always sent, and
/// `null` clears one.
@JsonSerializable(createFactory: false, includeIfNull: true)
class UpdateBudgetRequestModel {
  UpdateBudgetRequestModel(BudgetSettings settings)
      : exchangeRate = settings.exchangeRate,
        workDays = settings.workDays;

  @JsonKey(toJson: _optionalMoneyToJson)
  final Money? exchangeRate;
  final int? workDays;

  Map<String, dynamic> toJson() => _$UpdateBudgetRequestModelToJson(this);
}
