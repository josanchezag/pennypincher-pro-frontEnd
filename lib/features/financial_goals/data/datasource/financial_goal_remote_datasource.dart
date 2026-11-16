import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/constants/app_constants.dart';
import 'package:pennypincher_pro/core/crud/data/crud_remote_data_source.dart';
import 'package:pennypincher_pro/core/network/api_envelope.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/financial_goals/data/model/goal_json_codec.dart';
import 'package:pennypincher_pro/features/financial_goals/data/model/goal_projection_json.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/financial_goal_entity.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_projection_entity.dart';

/// Keys of the income source and net worth JSON the goal form reads.
abstract final class GoalBasisJsonKeys {
  static const String amount = 'amount';
  static const String netWorth = 'netWorth';
}

/// `/financial-goals` endpoints, called with the authenticated client, and
/// the two figures the goal form previews a plan from. Every method throws
/// `AppException` on failure.
@lazySingleton
class FinancialGoalRemoteDataSource
    extends CrudRemoteDataSource<FinancialGoal, GoalDraft> {
  FinancialGoalRemoteDataSource(super.dio)
      : super(path: ApiPaths.financialGoals, codec: const GoalJsonCodec());

  /// `GET /financial-goals/all-projections`: one per goal, in list order.
  Future<List<GoalProjection>> getAllProjections() async {
    final response = await ApiEnvelope.send(
      () => client.get<Object?>(ApiPaths.financialGoalProjections),
    );
    return ApiEnvelope.parseList(response.data, GoalProjectionJson.fromJson);
  }

  /// `GET /financial-goals/{id}/projection`.
  Future<GoalProjection> getProjection(String goalId) async {
    final response = await ApiEnvelope.send(
      () => client.get<Object?>(
        '${itemPath(goalId)}${ApiPaths.projectionSuffix}',
      ),
    );
    return ApiEnvelope.parseData(response.data, GoalProjectionJson.fromJson);
  }

  /// `POST /financial-goals/defaults`: adds the standard goal of every
  /// level without goals and returns the whole list.
  Future<List<FinancialGoal>> createDefaults() async {
    final response = await ApiEnvelope.send(
      () => client.post<Object?>(ApiPaths.financialGoalDefaults),
    );
    return ApiEnvelope.parseList(response.data, codec.fromJson);
  }

  /// `GET /income-sources`: the current monthly income, the sum of the
  /// amounts of every income source, as the backend computes it for the
  /// goals based on the income.
  Future<Money> getMonthlyIncome() async {
    final response = await ApiEnvelope.send(
      () => client.get<Object?>(ApiPaths.incomeSources),
    );
    final amounts = ApiEnvelope.parseList(
      response.data,
      (json) => Money.fromJson(json[GoalBasisJsonKeys.amount]),
    );
    return sumMoney(amounts, (amount) => amount);
  }

  /// `GET /net-worth/current`: the current net worth.
  Future<Money> getCurrentNetWorth() async {
    final response = await ApiEnvelope.send(
      () => client.get<Object?>(ApiPaths.netWorthCurrent),
    );
    return ApiEnvelope.parseData(
      response.data,
      (json) => Money.fromJson(json[GoalBasisJsonKeys.netWorth]),
    );
  }
}
