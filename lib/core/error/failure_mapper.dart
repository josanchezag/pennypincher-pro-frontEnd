import 'package:pennypincher_pro/core/constants/app_constants.dart';
import 'package:pennypincher_pro/core/error/app_exception.dart';
import 'package:pennypincher_pro/core/error/error_codes.dart';
import 'package:pennypincher_pro/core/error/failure.dart';

/// Translates data-layer exceptions into domain failures.
abstract final class FailureMapper {
  static Failure fromException(AppException exception) {
    if (exception.code == ErrorCodes.networkError) {
      return NetworkFailure(exception.message);
    }
    return switch (exception.statusCode) {
      HttpStatusCodes.unauthorized => UnauthorizedFailure(exception.message),
      HttpStatusCodes.notFound => NotFoundFailure(exception.message),
      _ => ServerFailure(exception.message, code: exception.code),
    };
  }
}
