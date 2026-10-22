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
    final data = body is Map ? body[ApiEnvelopeKeys.data] : null;
    if (data is! Map) {
      throw _invalidResponse();
    }
    try {
      return fromJson(Map<String, dynamic>.from(data));
    } on TypeError {
      throw _invalidResponse();
    } on FormatException {
      throw _invalidResponse();
    }
  }

  /// Converts a dio failure into an [AppException] carrying the backend
  /// error code and message when the envelope has them.
  static AppException exceptionFrom(DioException exception) {
    final response = exception.response;
    if (response == null) {
      return const AppException(
        code: ErrorCodes.networkError,
        message: ErrorMessages.network,
      );
    }
    final body = response.data;
    final error = body is Map ? body[ApiEnvelopeKeys.error] : null;
    final code = error is Map ? error[ApiEnvelopeKeys.code] : null;
    final message = error is Map ? error[ApiEnvelopeKeys.message] : null;
    return AppException(
      code: code is String ? code : ErrorCodes.unknown,
      message: message is String ? message : ErrorMessages.unexpected,
      statusCode: response.statusCode,
    );
  }

  static AppException _invalidResponse() => const AppException(
        code: ErrorCodes.invalidResponse,
        message: ErrorMessages.invalidResponse,
      );
}
