import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/error/app_exception.dart';
import 'package:pennypincher_pro/core/error/error_codes.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/core/error/failure_mapper.dart';

Failure _map(String code, {int? status}) => FailureMapper.fromException(
      AppException(code: code, message: 'message', statusCode: status),
    );

void main() {
  test('maps network errors', () {
    expect(_map(ErrorCodes.networkError), isA<NetworkFailure>());
  });

  test('maps 401 to an unauthorized failure', () {
    expect(_map('UNAUTHORIZED', status: 401), isA<UnauthorizedFailure>());
  });

  test('maps 404 to a not found failure', () {
    expect(_map('NOT_FOUND', status: 404), isA<NotFoundFailure>());
  });

  test('keeps the backend code for other errors', () {
    final failure = _map('VALIDATION_FAILED', status: 400);

    expect(
      failure,
      isA<ServerFailure>()
          .having((f) => f.code, 'code', 'VALIDATION_FAILED')
          .having((f) => f.message, 'message', 'message'),
    );
  });
}
