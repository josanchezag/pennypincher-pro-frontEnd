// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'net_worth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NetWorthSnapshotModel _$NetWorthSnapshotModelFromJson(
        Map<String, dynamic> json) =>
    NetWorthSnapshotModel(
      id: json['id'] as String,
      snapshotDate: ApiDate.parse(json['snapshotDate'] as String),
      totalAssets: _money(json['totalAssets']),
      totalLiabilities: _money(json['totalLiabilities']),
      netWorth: _money(json['netWorth']),
    );

NetWorthSummaryModel _$NetWorthSummaryModelFromJson(
        Map<String, dynamic> json) =>
    NetWorthSummaryModel(
      totalAssets: _money(json['totalAssets']),
      totalLiabilities: _money(json['totalLiabilities']),
      netWorth: _money(json['netWorth']),
    );

Map<String, dynamic> _$SnapshotRequestModelToJson(
        SnapshotRequestModel instance) =>
    <String, dynamic>{
      'snapshotDate': instance.snapshotDate,
    };
