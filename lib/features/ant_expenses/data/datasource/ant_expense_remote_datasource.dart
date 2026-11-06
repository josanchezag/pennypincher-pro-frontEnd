import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/constants/app_constants.dart';
import 'package:pennypincher_pro/core/crud/data/crud_remote_data_source.dart';
import 'package:pennypincher_pro/core/network/api_envelope.dart';
import 'package:pennypincher_pro/core/time/api_date.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/ant_expenses/data/model/ant_expense_json.dart';
import 'package:pennypincher_pro/features/ant_expenses/domain/entity/ant_expense_entity.dart';
import 'package:pennypincher_pro/features/ant_expenses/domain/entity/ant_expense_report_entity.dart';

/// `/ant-expenses` endpoints, called with the authenticated client: the
/// open expenses (list, create, update, delete) and the reports. Every
/// method throws `AppException` on failure.
@lazySingleton
class AntExpenseRemoteDataSource
    extends CrudRemoteDataSource<AntExpense, AntExpenseDraft> {
  AntExpenseRemoteDataSource(super.dio)
      : super(path: ApiPaths.antExpenses, codec: const AntExpenseJsonCodec());

  /// `GET /ant-expenses/summary`.
  Future<AntSummary> getSummary() async {
    final response = await ApiEnvelope.send(
      () => client
          .get<Object?>('${ApiPaths.antExpenses}${ApiPaths.summarySuffix}'),
    );
    return ApiEnvelope.parseData(response.data, AntReportJson.summary);
  }

  /// `GET /ant-expenses/cuts`.
  Future<List<AntCut>> getCuts() async {
    final response = await ApiEnvelope.send(
      () => client.get<Object?>(ApiPaths.antExpenseCuts),
    );
    return ApiEnvelope.parseList(response.data, AntReportJson.cut);
  }

  /// `GET /ant-expenses/cuts/{budgetId}/items`.
  Future<List<AntExpense>> getCutItems(String budgetId) async {
    final response = await ApiEnvelope.send(
      () => client.get<Object?>(
        '${ApiPaths.antExpenseCuts}/${Uri.encodeComponent(budgetId)}'
        '${ApiPaths.itemsSuffix}',
      ),
    );
    return ApiEnvelope.parseList(response.data, codec.fromJson);
  }

  /// `GET /ant-expenses/trend?month=YYYY-MM&months=N`.
  Future<List<AntTrendMonth>> getTrend(DateTime month, int months) async {
    final response = await ApiEnvelope.send(
      () => client.get<Object?>(
        ApiPaths.antExpenseTrend,
        queryParameters: {
          ApiQueryParams.month: ApiDate.formatMonth(month),
          ApiQueryParams.months: months,
        },
      ),
    );
    return ApiEnvelope.parseList(response.data, AntReportJson.trendMonth);
  }

  /// `PUT /ant-expenses/limit`: replaces the limit; `null` removes it.
  Future<Money?> saveLimit(Money? monthlyLimit) async {
    final response = await ApiEnvelope.send(
      () => client.put<Object?>(
        ApiPaths.antExpenseLimit,
        data: {AntExpenseJsonKeys.monthlyLimit: monthlyLimit?.toJson()},
      ),
    );
    return ApiEnvelope.parseData(response.data, AntReportJson.monthlyLimit);
  }
}
