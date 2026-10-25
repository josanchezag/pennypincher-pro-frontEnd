// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_budget_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BudgetComponentModel _$BudgetComponentModelFromJson(
        Map<String, dynamic> json) =>
    BudgetComponentModel(
      component: json['component'] as String,
      amount: _money(json['amount']),
      percentage: _percent(json['percentage'] as num),
      idealPercentage: (json['idealPercentage'] as num?)?.toDouble(),
    );

MonthlyBudgetModel _$MonthlyBudgetModelFromJson(Map<String, dynamic> json) =>
    MonthlyBudgetModel(
      id: json['id'] as String,
      year: (json['year'] as num).toInt(),
      month: (json['month'] as num).toInt(),
      totalIncome: _money(json['totalIncome']),
      totalExpenses: _money(json['totalExpenses']),
      monthlyCashFlow: _money(json['monthlyCashFlow']),
      components: (json['components'] as List<dynamic>)
          .map((e) => BudgetComponentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      exchangeRate: Money.fromOptionalJson(json['exchangeRate']),
      workDays: (json['workDays'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CreateBudgetRequestModelToJson(
        CreateBudgetRequestModel instance) =>
    <String, dynamic>{
      'year': instance.year,
      'month': instance.month,
    };

Map<String, dynamic> _$UpdateBudgetRequestModelToJson(
        UpdateBudgetRequestModel instance) =>
    <String, dynamic>{
      'exchangeRate': _optionalMoneyToJson(instance.exchangeRate),
      'workDays': instance.workDays,
    };

MonthComparisonModel _$MonthComparisonModelFromJson(
        Map<String, dynamic> json) =>
    MonthComparisonModel(
      year: (json['year'] as num).toInt(),
      month: (json['month'] as num).toInt(),
      exists: json['exists'] as bool,
      totalIncome: Money.fromOptionalJson(json['totalIncome']),
      totalExpenses: Money.fromOptionalJson(json['totalExpenses']),
      monthlyCashFlow: Money.fromOptionalJson(json['monthlyCashFlow']),
      cashFlowPercentage: _optionalPercent(json['cashFlowPercentage'] as num?),
    );
