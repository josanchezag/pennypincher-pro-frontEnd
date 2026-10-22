import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/config/app_config.dart';
import 'package:pennypincher_pro/core/constants/app_constants.dart';
import 'package:pennypincher_pro/core/network/http_adapter.dart';

/// Provides the shared HTTP client configured against the backend API.
@module
abstract class NetworkModule {
  /// Platform adapter; on the web it sends credentials (cookies).
  @lazySingleton
  HttpClientAdapter get httpClientAdapter => createHttpAdapter();

  @lazySingleton
  Dio dio(AppConfig config, HttpClientAdapter adapter) => Dio(
        BaseOptions(
          baseUrl: config.apiBaseUrl,
          connectTimeout: AppConstants.connectTimeout,
          receiveTimeout: AppConstants.receiveTimeout,
          contentType: AppConstants.contentTypeJson,
        ),
      )..httpClientAdapter = adapter;
}
