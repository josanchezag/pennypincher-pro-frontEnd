import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/constants/app_constants.dart';
import 'package:pennypincher_pro/core/network/api_envelope.dart';
import 'package:pennypincher_pro/core/time/api_date.dart';
import 'package:pennypincher_pro/features/budget/data/model/monthly_budget_models.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/monthly_budget_entity.dart';

/// `/monthly-budgets` endpoints, called with the authenticated client.
/// Every method throws `AppException` on failure.
@lazySingleton
class MonthlyBudgetRemoteDataSource {
  MonthlyBudgetRemoteDataSource(this._dio);

  final Dio _dio;

  /// `GET /monthly-budgets/{year}/{month}`; a month without a budget
  /// fails with status 404.
  Future<MonthlyBudgetModel> getByMonth(DateTime month) => _parsed(
        () => _dio.get<Object?>(
          '${ApiPaths.monthlyBudgets}/${month.year}/${month.month}',
        ),
      );

  /// `POST /monthly-budgets`.
  Future<MonthlyBudgetModel> create(DateTime month) => _parsed(
        () => _dio.post<Object?>(
          ApiPaths.monthlyBudgets,
          data: CreateBudgetRequestModel(month).toJson(),
        ),
      );

  /// `PUT /monthly-budgets/{id}`.
  Future<MonthlyBudgetModel> update(String id, BudgetSettings settings) =>
      _parsed(
        () => _dio.put<Object?>(
          _budgetPath(id),
          data: UpdateBudgetRequestModel(settings).toJson(),
        ),
      );

  /// `POST /monthly-budgets/{id}/recalculate`.
  Future<MonthlyBudgetModel> recalculate(String id) => _parsed(
        () => _dio.post<Object?>(
          '${_budgetPath(id)}${ApiPaths.recalculateSuffix}',
        ),
      );

  /// `GET /reports/monthly-comparison?months=…&month=YYYY-MM`: [months]
  /// entries ending at the month of [month], oldest first.
  Future<List<MonthComparisonModel>> getComparison(
    DateTime month, {
    required int months,
  }) async {
    final response = await ApiEnvelope.send(
      () => _dio.get<Object?>(
        ApiPaths.monthlyComparison,
        queryParameters: {
          ApiQueryParams.months: months,
          ApiQueryParams.month: ApiDate.formatMonth(month),
        },
      ),
    );
    return ApiEnvelope.parseList(
      response.data,
      MonthComparisonModel.fromJson,
    );
  }

  String _budgetPath(String id) =>
      '${ApiPaths.monthlyBudgets}/${Uri.encodeComponent(id)}';

  Future<MonthlyBudgetModel> _parsed(
    Future<Response<Object?>> Function() request,
  ) async {
    final response = await ApiEnvelope.send(request);
    return ApiEnvelope.parseData(response.data, MonthlyBudgetModel.fromJson);
  }
}
