import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/auth/session_refresher.dart';
import 'package:pennypincher_pro/core/config/app_config.dart';
import 'package:pennypincher_pro/core/constants/app_constants.dart';
import 'package:pennypincher_pro/core/di/injection.dart';
import 'package:pennypincher_pro/core/network/auth_interceptor.dart';
import 'package:pennypincher_pro/core/router/app_router.dart';
import 'package:pennypincher_pro/core/time/clock.dart';
import 'package:pennypincher_pro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pennypincher_pro/features/budget/domain/repository/income_source_repository.dart';
import 'package:pennypincher_pro/features/budget/domain/repository/monthly_budget_repository.dart';
import 'package:pennypincher_pro/features/budget/presentation/bloc/income_source_bloc.dart';
import 'package:pennypincher_pro/features/budget/presentation/bloc/monthly_budget_bloc.dart';
import 'package:pennypincher_pro/features/net_worth/domain/repository/asset_repository.dart';
import 'package:pennypincher_pro/features/net_worth/domain/repository/liability_repository.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/bloc/asset_bloc.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/bloc/liability_bloc.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/bloc/net_worth_bloc.dart';

void main() {
  setUp(configureDependencies);
  tearDown(getIt.reset);

  test('registers configuration, HTTP clients, session and router', () {
    expect(getIt<AppConfig>(), isA<AppConfig>());
    expect(getIt<AppRouter>(), same(getIt<AppRouter>()));
    expect(getIt<AuthBloc>(), same(getIt<AuthBloc>()));
    expect(getIt<SessionRefresher>(), isA<SessionRefresher>());
  });

  test('creates a fresh list bloc for every screen', () {
    final assets = [getIt<AssetBloc>(), getIt<AssetBloc>()];
    final liabilities = [getIt<LiabilityBloc>(), getIt<LiabilityBloc>()];
    final income = [getIt<IncomeSourceBloc>(), getIt<IncomeSourceBloc>()];
    for (final bloc in [...assets, ...liabilities, ...income]) {
      addTearDown(bloc.close);
    }

    expect(assets.first, isNot(same(assets.last)));
    expect(liabilities.first, isNot(same(liabilities.last)));
    expect(income.first, isNot(same(income.last)));
    final overview = getIt<NetWorthBloc>();
    addTearDown(overview.close);
    final budgets = [getIt<MonthlyBudgetBloc>(), getIt<MonthlyBudgetBloc>()];
    for (final bloc in budgets) {
      addTearDown(bloc.close);
    }
    expect(budgets.first, isNot(same(budgets.last)));
    expect(
      getIt<MonthlyBudgetRepository>(),
      same(getIt<MonthlyBudgetRepository>()),
    );
    expect(getIt<Clock>(), isA<SystemClock>());
    expect(getIt<AssetRepository>(), same(getIt<AssetRepository>()));
    expect(getIt<LiabilityRepository>(), same(getIt<LiabilityRepository>()));
    expect(
      getIt<IncomeSourceRepository>(),
      same(getIt<IncomeSourceRepository>()),
    );
  });

  test('points the HTTP client at the configured API base URL', () {
    final dio = getIt<Dio>();

    expect(dio.options.baseUrl, getIt<AppConfig>().apiBaseUrl);
    expect(dio.options.connectTimeout, AppConstants.connectTimeout);
    expect(dio.options.receiveTimeout, AppConstants.receiveTimeout);
  });

  test('protects the API client but not the plain client', () {
    final api = getIt<Dio>();
    final plain = getIt<Dio>(instanceName: NetworkNames.plainDio);

    expect(api.interceptors.whereType<AuthInterceptor>(), hasLength(1));
    expect(plain.interceptors.whereType<AuthInterceptor>(), isEmpty);
    expect(plain.httpClientAdapter, same(api.httpClientAdapter));
  });
}
