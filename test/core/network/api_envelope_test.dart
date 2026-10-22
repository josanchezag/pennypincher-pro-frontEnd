import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/error/app_exception.dart';
import 'package:pennypincher_pro/core/error/error_codes.dart';
import 'package:pennypincher_pro/core/network/api_envelope.dart';

DioException _withResponse(int status, Object? body) {
  final options = RequestOptions(path: '/x');
  return DioException(
    requestOptions: options,
    response: Response<Object?>(
      requestOptions: options,
      statusCode: status,
      data: body,
    ),
  );
}

void main() {
  group('ApiEnvelope.parseData', () {
    test('parses the data object', () {
      final value = ApiEnvelope.parseData(
        {
          'data': {'name': 'Ada'},
          'meta': <String, Object?>{},
        },
        (json) => json['name'],
      );

      expect(value, 'Ada');
    });

    test('rejects a body without data', () {
      expect(
        () => ApiEnvelope.parseData(
          {'meta': <String, Object?>{}},
          (json) => json,
        ),
        throwsA(
          isA<AppException>()
              .having((e) => e.code, 'code', ErrorCodes.invalidResponse),
        ),
      );
    });

    test('rejects data that cannot be parsed', () {
      expect(
        () => ApiEnvelope.parseData(
          {
            'data': <String, Object?>{'when': 'not a date'},
          },
          (json) => DateTime.parse(json['when'] as String),
        ),
        throwsA(isA<AppException>()),
      );
    });
  });

  group('ApiEnvelope.exceptionFrom', () {
    test('reads code, message and status from the error envelope', () {
      final exception = ApiEnvelope.exceptionFrom(
        _withResponse(400, {
          'error': {'code': 'VALIDATION_FAILED', 'message': 'Invalid name'},
        }),
      );

      expect(exception.code, 'VALIDATION_FAILED');
      expect(exception.message, 'Invalid name');
      expect(exception.statusCode, 400);
    });

    test('falls back to generic values for other bodies', () {
      final exception = ApiEnvelope.exceptionFrom(_withResponse(502, null));

      expect(exception.code, ErrorCodes.unknown);
      expect(exception.message, ErrorMessages.unexpected);
      expect(exception.statusCode, 502);
    });

    test('reports a missing response as a network error', () {
      final exception = ApiEnvelope.exceptionFrom(
        DioException(requestOptions: RequestOptions(path: '/x')),
      );

      expect(exception.code, ErrorCodes.networkError);
      expect(exception.statusCode, isNull);
    });
  });
}
