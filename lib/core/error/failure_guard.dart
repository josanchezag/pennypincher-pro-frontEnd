import 'package:dartz/dartz.dart';
import 'package:pennypincher_pro/core/error/app_exception.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/core/error/failure_mapper.dart';

/// Runs a data-layer [call] and returns its result, or the [Failure] that
/// matches the [AppException] it threw.
Future<Either<Failure, R>> guardFailures<R>(Future<R> Function() call) async {
  try {
    return Right(await call());
  } on AppException catch (exception) {
    return Left(FailureMapper.fromException(exception));
  }
}
