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
      message: message is String
          ? _withDetails(message, error is Map ? error : null)
          : ErrorMessages.unexpected,
      statusCode: response.statusCode,
    );
  }

  /// Appends the field errors of a validation failure, such as
  /// `Validation failed for 1 field(s): snapshotDate must not be in the
  /// future`.
  static String _withDetails(String message, Map<dynamic, dynamic>? error) {
    final details = error?[ApiEnvelopeKeys.details];
    if (details is! List) {
      return message;
    }
    final fields = [
      for (final detail in details.whereType<Map<dynamic, dynamic>>())
        if (detail[ApiEnvelopeKeys.message] is String)
          [detail[ApiEnvelopeKeys.field], detail[ApiEnvelopeKeys.message]]
              .whereType<String>()
              .join(' '),
    ];
    return fields.isEmpty ? message : '$message: ${fields.join('; ')}';
  }

  static AppException _invalidResponse() => const AppException(
        code: ErrorCodes.invalidResponse,
        message: ErrorMessages.invalidResponse,
      );
}
