import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:pennypincher_pro/core/error/app_exception.dart';
import 'package:pennypincher_pro/core/error/error_codes.dart';
import 'package:pennypincher_pro/core/network/api_envelope.dart';

import '../../helpers/l10n.dart';

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
    test('reads code and status, and explains the code in its own words', () {
      final exception = ApiEnvelope.exceptionFrom(
        _withResponse(400, {
          'error': {'code': 'VALIDATION_FAILED', 'message': 'Invalid name'},
        }),
      );

      expect(exception.code, 'VALIDATION_FAILED');
      expect(exception.message, l10n.errorValidationFailed);
      expect(exception.statusCode, 400);
    });

    test('gives every backend code a message of the interface', () {
      final expected = {
        'VALIDATION_FAILED': l10n.errorValidationFailed,
        'UNAUTHORIZED': l10n.errorSessionExpired,
        'FORBIDDEN': l10n.errorForbidden,
        'FORBIDDEN_ORIGIN': l10n.errorForbidden,
        'NOT_FOUND': l10n.errorNotFound,
        'CONFLICT': l10n.errorConflict,
        'RATE_LIMITED': l10n.errorRateLimited,
        'ACCOUNT_NOT_ALLOWED': l10n.signInAccountNotAllowed,
        'REGISTRATION_DISABLED': l10n.signInRegistrationDisabled,
        'GOOGLE_AUTH_FAILED': l10n.signInFailed,
        'IDENTITY_PROVIDER_UNAVAILABLE': l10n.errorIdentityProviderUnavailable,
        'INTERNAL_ERROR': l10n.errorUnexpected,
        'METHOD_NOT_ALLOWED': l10n.errorUnexpected,
        'SOMETHING_NEW': l10n.errorUnexpected,
      };
      for (final MapEntry(key: code, value: message) in expected.entries) {
        final exception = ApiEnvelope.exceptionFrom(
          _withResponse(400, {
            'error': {'code': code, 'message': 'English text for developers'},
          }),
        );

        expect(exception.code, code);
        expect(exception.message, message, reason: code);
      }
    });

    test('explains the code in Spanish when the interface is Spanish', () {
      Intl.defaultLocale = 'es';
      addTearDown(() => Intl.defaultLocale = testLocale.languageCode);

      final exception = ApiEnvelope.exceptionFrom(
        _withResponse(404, {
          'error': {'code': 'NOT_FOUND', 'message': 'Asset not found'},
        }),
      );

      expect(exception.message, l10nEs.errorNotFound);
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
    test('never shows the English details of the backend', () {
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
      expect(exception.message, l10n.errorValidationFailed);
      expect(exception.message, isNot(contains('snapshotDate')));
    });
  });
}
