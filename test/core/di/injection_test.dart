import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/config/app_config.dart';
import 'package:pennypincher_pro/core/constants/app_constants.dart';
import 'package:pennypincher_pro/core/di/injection.dart';
import 'package:pennypincher_pro/core/router/app_router.dart';

void main() {
  setUp(configureDependencies);
  tearDown(getIt.reset);

  test('registers configuration, HTTP client and router', () {
    expect(getIt<AppConfig>(), isA<AppConfig>());
    expect(getIt<AppRouter>(), same(getIt<AppRouter>()));
  });

  test('points the HTTP client at the configured API base URL', () {
    final dio = getIt<Dio>();

    expect(dio.options.baseUrl, getIt<AppConfig>().apiBaseUrl);
    expect(dio.options.connectTimeout, AppConstants.connectTimeout);
    expect(dio.options.receiveTimeout, AppConstants.receiveTimeout);
  });
}
