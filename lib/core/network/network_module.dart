import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/config/app_config.dart';
import 'package:pennypincher_pro/core/constants/app_constants.dart';
import 'package:pennypincher_pro/core/network/auth_interceptor.dart';
import 'package:pennypincher_pro/core/network/http_adapter.dart';

/// Provides the HTTP clients configured against the backend API.
@module
abstract class NetworkModule {
  /// Platform adapter; on the web it sends credentials (cookies).
  @lazySingleton
  HttpClientAdapter get httpClientAdapter => createHttpAdapter();

  /// Client for the `/auth` endpoints and for retries: no auth interceptor,
  /// so it can never loop into another token refresh.
  @lazySingleton
  @Named(NetworkNames.plainDio)
  Dio plainDio(AppConfig config, HttpClientAdapter adapter) =>
      _client(config, adapter);

  /// Client for every protected endpoint.
  @lazySingleton
  Dio dio(
    AppConfig config,
    HttpClientAdapter adapter,
    AuthInterceptor authInterceptor,
  ) =>
      _client(config, adapter)..interceptors.add(authInterceptor);

  static Dio _client(AppConfig config, HttpClientAdapter adapter) => Dio(
        BaseOptions(
          baseUrl: config.apiBaseUrl,
          connectTimeout: AppConstants.connectTimeout,
          receiveTimeout: AppConstants.receiveTimeout,
          contentType: AppConstants.contentTypeJson,
        ),
      )..httpClientAdapter = adapter;
}
