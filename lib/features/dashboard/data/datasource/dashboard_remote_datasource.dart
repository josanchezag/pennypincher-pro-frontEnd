import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/constants/app_constants.dart';
import 'package:pennypincher_pro/core/network/api_envelope.dart';
import 'package:pennypincher_pro/core/time/api_date.dart';
import 'package:pennypincher_pro/features/dashboard/data/model/dashboard_summary_json.dart';
import 'package:pennypincher_pro/features/dashboard/domain/entity/dashboard_summary_entity.dart';

/// Keys of the request bodies sent by the dashboard.
abstract final class DashboardRequestKeys {
  static const String snapshotDate = 'snapshotDate';
}

/// Endpoints the dashboard calls with the authenticated client. Every
/// method throws `AppException` on failure.
@lazySingleton
class DashboardRemoteDataSource {
  DashboardRemoteDataSource(this._dio);

  final Dio _dio;

  /// `GET /dashboard/summary?month=YYYY-MM`.
  Future<DashboardSummary> getSummary(DateTime month) async {
    final response = await ApiEnvelope.send(
      () => _dio.get<Object?>(
        ApiPaths.dashboardSummary,
        queryParameters: {ApiQueryParams.month: ApiDate.formatMonth(month)},
      ),
    );
    return ApiEnvelope.parseData(response.data, DashboardSummaryJson.fromJson);
  }

  /// `POST /net-worth/snapshots` with the first day of [month].
  Future<void> recordSnapshot(DateTime month) => ApiEnvelope.send(
        () => _dio.post<Object?>(
          ApiPaths.netWorthSnapshots,
          data: {DashboardRequestKeys.snapshotDate: ApiDate.format(month)},
        ),
      );
}
