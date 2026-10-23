import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/constants/app_constants.dart';
import 'package:pennypincher_pro/core/network/api_envelope.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/expense_summary_entity.dart';

/// Where the summary of one [ExpenseKind] lives and the keys of its
/// totals; [balanceKey] is null for lists without a balance.
class ExpenseSummaryEndpoint {
  const ExpenseSummaryEndpoint({
    required this.path,
    required this.monthlyKey,
    this.balanceKey,
  });

  final String path;
  final String monthlyKey;
  final String? balanceKey;

  String get summaryPath => '$path${ApiPaths.summarySuffix}';
}

/// Keys of the summary JSON of the expense lists.
abstract final class ExpenseSummaryJsonKeys {
  static const String count = 'count';
  static const String totalMonthlyPayments = 'totalMonthlyPayments';
  static const String totalOutstandingBalance = 'totalOutstandingBalance';
  static const String totalMonthlyAmount = 'totalMonthlyAmount';
  static const String totalMonthlyContributions = 'totalMonthlyContributions';
  static const String totalCurrentBalance = 'totalCurrentBalance';
}

/// `GET <list>/summary` of every expense list, called with the
/// authenticated client.
@lazySingleton
class ExpenseSummaryRemoteDataSource {
  ExpenseSummaryRemoteDataSource(this._dio);

  static const Map<ExpenseKind, ExpenseSummaryEndpoint> endpoints = {
    ExpenseKind.creditCards: ExpenseSummaryEndpoint(
      path: ApiPaths.creditCards,
      monthlyKey: ExpenseSummaryJsonKeys.totalMonthlyPayments,
      balanceKey: ExpenseSummaryJsonKeys.totalOutstandingBalance,
    ),
    ExpenseKind.loans: ExpenseSummaryEndpoint(
      path: ApiPaths.loans,
      monthlyKey: ExpenseSummaryJsonKeys.totalMonthlyPayments,
      balanceKey: ExpenseSummaryJsonKeys.totalOutstandingBalance,
    ),
    ExpenseKind.fixedExpenses: ExpenseSummaryEndpoint(
      path: ApiPaths.fixedExpenses,
      monthlyKey: ExpenseSummaryJsonKeys.totalMonthlyAmount,
    ),
    ExpenseKind.variableExpenses: ExpenseSummaryEndpoint(
      path: ApiPaths.variableExpenses,
      monthlyKey: ExpenseSummaryJsonKeys.totalMonthlyAmount,
    ),
    ExpenseKind.savings: ExpenseSummaryEndpoint(
      path: ApiPaths.savingsAccounts,
      monthlyKey: ExpenseSummaryJsonKeys.totalMonthlyContributions,
      balanceKey: ExpenseSummaryJsonKeys.totalCurrentBalance,
    ),
  };

  final Dio _dio;

  /// Throws `AppException` on failure.
  Future<ExpenseSummary> getSummary(ExpenseKind kind) async {
    final endpoint = endpoints[kind]!;
    final response = await ApiEnvelope.send(
      () => _dio.get<Object?>(endpoint.summaryPath),
    );
    return ApiEnvelope.parseData(
      response.data,
      (json) => _summary(json, endpoint),
    );
  }

  static ExpenseSummary _summary(
    JsonMap json,
    ExpenseSummaryEndpoint endpoint,
  ) {
    final balanceKey = endpoint.balanceKey;
    return ExpenseSummary(
      monthlyTotal: Money.fromJson(json[endpoint.monthlyKey]),
      count: json[ExpenseSummaryJsonKeys.count] as int,
      balanceTotal:
          balanceKey == null ? null : Money.fromJson(json[balanceKey]),
    );
  }
}
