import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/auth/session_refresher.dart';
import 'package:pennypincher_pro/core/config/app_config.dart';
import 'package:pennypincher_pro/core/constants/app_constants.dart';
import 'package:pennypincher_pro/core/di/injection.dart';
import 'package:pennypincher_pro/core/network/auth_interceptor.dart';
import 'package:pennypincher_pro/core/router/app_router.dart';
import 'package:pennypincher_pro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pennypincher_pro/features/net_worth/domain/repository/asset_repository.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/bloc/asset_bloc.dart';

void main() {
  setUp(configureDependencies);
  tearDown(getIt.reset);

  test('registers configuration, HTTP clients, session and router', () {
    expect(getIt<AppConfig>(), isA<AppConfig>());
    expect(getIt<AppRouter>(), same(getIt<AppRouter>()));
    expect(getIt<AuthBloc>(), same(getIt<AuthBloc>()));
    expect(getIt<SessionRefresher>(), isA<SessionRefresher>());
  });

  test('creates a fresh assets bloc for every screen', () {
    final first = getIt<AssetBloc>();
    addTearDown(first.close);
    final second = getIt<AssetBloc>();
    addTearDown(second.close);

    expect(first, isNot(same(second)));
    expect(getIt<AssetRepository>(), same(getIt<AssetRepository>()));
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
