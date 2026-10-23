import 'package:json_annotation/json_annotation.dart';
import 'package:pennypincher_pro/core/time/api_date.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/net_worth_snapshot_entity.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/net_worth_summary_entity.dart';

part 'net_worth_models.g.dart';

Money _money(Object? json) => Money.fromJson(json);

/// JSON shape of a stored monthly snapshot.
@JsonSerializable(createToJson: false)
class NetWorthSnapshotModel {
  const NetWorthSnapshotModel({
    required this.id,
    required this.snapshotDate,
    required this.totalAssets,
    required this.totalLiabilities,
    required this.netWorth,
  });

  factory NetWorthSnapshotModel.fromJson(Map<String, dynamic> json) =>
      _$NetWorthSnapshotModelFromJson(json);

  final String id;
  @JsonKey(fromJson: ApiDate.parse)
  final DateTime snapshotDate;
  @JsonKey(fromJson: _money)
  final Money totalAssets;
  @JsonKey(fromJson: _money)
  final Money totalLiabilities;
  @JsonKey(fromJson: _money)
  final Money netWorth;

  NetWorthSnapshot toEntity() => NetWorthSnapshot(
        id: id,
        snapshotDate: snapshotDate,
        totalAssets: totalAssets,
        totalLiabilities: totalLiabilities,
        netWorth: netWorth,
      );
}

/// JSON shape of the live net worth totals.
@JsonSerializable(createToJson: false)
class NetWorthSummaryModel {
  const NetWorthSummaryModel({
    required this.totalAssets,
    required this.totalLiabilities,
    required this.netWorth,
  });

  factory NetWorthSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$NetWorthSummaryModelFromJson(json);

  @JsonKey(fromJson: _money)
  final Money totalAssets;
  @JsonKey(fromJson: _money)
  final Money totalLiabilities;
  @JsonKey(fromJson: _money)
  final Money netWorth;

  NetWorthSummary toEntity() => NetWorthSummary(
        totalAssets: totalAssets,
        totalLiabilities: totalLiabilities,
        netWorth: netWorth,
      );
}

/// Body of `POST /net-worth/snapshots`.
@JsonSerializable(createFactory: false)
class SnapshotRequestModel {
  SnapshotRequestModel(DateTime month)
      : snapshotDate = ApiDate.format(NetWorthSnapshot.monthOf(month));

  final String snapshotDate;

  Map<String, dynamic> toJson() => _$SnapshotRequestModelToJson(this);
}
