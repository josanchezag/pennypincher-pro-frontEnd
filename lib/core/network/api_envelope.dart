import 'package:dio/dio.dart';
import 'package:pennypincher_pro/core/constants/app_constants.dart';
import 'package:pennypincher_pro/core/error/app_exception.dart';
import 'package:pennypincher_pro/core/error/error_codes.dart';

typedef JsonMap = Map<String, dynamic>;

/// Reads the backend response envelope: `{data, meta}` on success and
/// `{error: {code, message}, meta}` on failure.
abstract final class ApiEnvelope {
  /// Parses the `data` object of [body] with [fromJson].
  static T parseData<T>(Object? body, T Function(JsonMap json) fromJson) {
    final data = _data(body);
    if (data is! Map) {
      throw _invalidResponse();
    }
    return _parsing(() => fromJson(Map<String, dynamic>.from(data)));
  }

  /// Parses every object of the `data` array of [body] with [fromJson].
  static List<T> parseList<T>(
    Object? body,
    T Function(JsonMap json) fromJson,
  ) {
    final data = _data(body);
    if (data is! List) {
      throw _invalidResponse();
    }
    return _parsing(
      () => [
        for (final item in data)
          fromJson(Map<String, dynamic>.from(item as Map)),
      ],
    );
  }

  /// Runs [request] and converts a dio failure into an [AppException].
  static Future<Response<Object?>> send(
    Future<Response<Object?>> Function() request,
  ) async {
    try {
      return await request();
    } on DioException catch (exception) {
      throw exceptionFrom(exception);
    }
  }

  static Object? _data(Object? body) =>
      body is Map ? body[ApiEnvelopeKeys.data] : null;

  static T _parsing<T>(T Function() parse) {
    try {
      return parse();
    } on TypeError {
      throw _invalidResponse();
    } on FormatException {
      throw _invalidResponse();
    }
  }

  /// Converts a dio failure into an [AppException] carrying the backend
  /// error code, with the message the interface gives that code. The
  /// backend message is English text meant for developers, so it is never
  /// shown.
  static AppException exceptionFrom(DioException exception) {
    final response = exception.response;
    if (response == null) {
      return AppException(
        code: ErrorCodes.networkError,
        message: ErrorMessages.network,
      );
    }
    final body = response.data;
    final error = body is Map ? body[ApiEnvelopeKeys.error] : null;
    final code = error is Map ? error[ApiEnvelopeKeys.code] : null;
    return AppException(
      code: code is String ? code : ErrorCodes.unknown,
      message: code is String
          ? ErrorMessages.forBackendCode(code)
          : ErrorMessages.unexpected,
      statusCode: response.statusCode,
    );
  }

  static AppException _invalidResponse() => AppException(
        code: ErrorCodes.invalidResponse,
        message: ErrorMessages.invalidResponse,
      );
}
