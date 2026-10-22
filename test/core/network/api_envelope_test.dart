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

  group('ApiEnvelope.parseList', () {
    test('parses every object of the data array', () {
      final names = ApiEnvelope.parseList(
        {
          'data': [
            {'name': 'Ada'},
            {'name': 'Grace'},
          ],
        },
        (json) => json['name'] as String,
      );

      expect(names, ['Ada', 'Grace']);
    });

    test('rejects data that is not an array or holds other values', () {
      final invalid = throwsA(
        isA<AppException>()
            .having((e) => e.code, 'code', ErrorCodes.invalidResponse),
      );

      expect(
        () => ApiEnvelope.parseList({'data': <String, Object?>{}}, (j) => j),
        invalid,
      );
      expect(
        () => ApiEnvelope.parseList(
          {
            'data': [1],
          },
          (j) => j,
        ),
        invalid,
      );
    });
  });

  group('ApiEnvelope.send', () {
    test('returns the response of a successful request', () async {
      final options = RequestOptions(path: '/x');
      final response = await ApiEnvelope.send(
        () async => Response<Object?>(requestOptions: options, statusCode: 200),
      );

      expect(response.statusCode, 200);
    });

    test('converts a dio failure into an app exception', () {
      expect(
        () => ApiEnvelope.send(
          () => Future.error(
            _withResponse(404, {
              'error': {'code': 'NOT_FOUND', 'message': 'Missing'},
            }),
          ),
        ),
        throwsA(
          isA<AppException>()
              .having((e) => e.code, 'code', 'NOT_FOUND')
              .having((e) => e.statusCode, 'statusCode', 404),
        ),
      );
    });
  });

  group('ApiEnvelope validation details', () {
    test('appends the field errors to the message', () {
      final exception = ApiEnvelope.exceptionFrom(
        _withResponse(400, {
          'error': {
            'code': 'VALIDATION_FAILED',
            'message': 'Validation failed for 2 field(s)',
            'details': [
              {'field': 'snapshotDate', 'message': 'must not be in the future'},
              {'message': 'is invalid'},
              'ignored',
            ],
          },
        }),
      );

      expect(exception.code, 'VALIDATION_FAILED');
      expect(
        exception.message,
        'Validation failed for 2 field(s): '
        'snapshotDate must not be in the future; is invalid',
      );
    });

    test('keeps the message when the details are empty', () {
      final exception = ApiEnvelope.exceptionFrom(
        _withResponse(400, {
          'error': {
            'code': 'VALIDATION_FAILED',
            'message': 'Validation failed',
            'details': <Object?>[],
          },
        }),
      );

      expect(exception.message, 'Validation failed');
    });
  });
}
