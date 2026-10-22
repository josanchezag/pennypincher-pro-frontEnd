import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/config/app_config.dart';
import 'package:pennypincher_pro/core/constants/app_constants.dart';

/// Provides the shared HTTP client configured against the backend API.
@module
abstract class NetworkModule {
  @lazySingleton
  Dio dio(AppConfig config) => Dio(
        BaseOptions(
          baseUrl: config.apiBaseUrl,
          connectTimeout: AppConstants.connectTimeout,
          receiveTimeout: AppConstants.receiveTimeout,
          contentType: AppConstants.contentTypeJson,
        ),
      );
}
