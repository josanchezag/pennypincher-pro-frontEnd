import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/constants/app_constants.dart';
import 'package:pennypincher_pro/core/network/api_envelope.dart';
import 'package:pennypincher_pro/features/net_worth/data/model/net_worth_models.dart';

/// `/net-worth` endpoints, called with the authenticated client. Every
/// method throws `AppException` on failure.
@lazySingleton
class NetWorthRemoteDataSource {
  NetWorthRemoteDataSource(this._dio);

  final Dio _dio;

  /// `GET /net-worth/snapshots`: the whole history, oldest month first.
  Future<List<NetWorthSnapshotModel>> getSnapshots() async {
    final response = await ApiEnvelope.send(
      () => _dio.get<Object?>(ApiPaths.netWorthSnapshots),
    );
    return ApiEnvelope.parseList(
      response.data,
      NetWorthSnapshotModel.fromJson,
    );
  }

  /// `GET /net-worth/current`: live totals.
  Future<NetWorthSummaryModel> getCurrent() async {
    final response = await ApiEnvelope.send(
      () => _dio.get<Object?>(ApiPaths.netWorthCurrent),
    );
    return ApiEnvelope.parseData(response.data, NetWorthSummaryModel.fromJson);
  }

  /// `POST /net-worth/snapshots`: creates or recalculates a month.
  Future<NetWorthSnapshotModel> createSnapshot(DateTime month) async {
    final response = await ApiEnvelope.send(
      () => _dio.post<Object?>(
        ApiPaths.netWorthSnapshots,
        data: SnapshotRequestModel(month).toJson(),
      ),
    );
    return ApiEnvelope.parseData(
      response.data,
      NetWorthSnapshotModel.fromJson,
    );
  }
}
