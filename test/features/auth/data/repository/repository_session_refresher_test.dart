import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/auth/session_refresher.dart';
import 'package:pennypincher_pro/core/error/error_codes.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/features/auth/data/repository/repository_session_refresher.dart';
import 'package:pennypincher_pro/features/auth/domain/repository/auth_repository.dart';

import '../../../../helpers/mocks.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository repository;
  late RepositorySessionRefresher refresher;

  setUp(() {
    repository = _MockAuthRepository();
    refresher = RepositorySessionRefresher(repository);
  });

  test('reports a renewed session', () async {
    when(repository.refreshSession).thenAnswer((_) async => Right(testUser));

    expect(await refresher.refreshSession(), RefreshOutcome.refreshed);
  });

  test('reports a rejected refresh cookie', () async {
    when(repository.refreshSession).thenAnswer(
      (_) async => const Left(UnauthorizedFailure('Session expired')),
    );

    expect(await refresher.refreshSession(), RefreshOutcome.rejected);
  });

  test('never ends the session for a superseded refresh', () async {
    when(repository.refreshSession).thenAnswer(
      (_) async => const Left(
        ServerFailure('Superseded', code: ErrorCodes.refreshSuperseded),
      ),
    );

    expect(await refresher.refreshSession(), RefreshOutcome.failed);
  });

  test('reports other errors as a failed attempt', () async {
    when(repository.refreshSession)
        .thenAnswer((_) async => const Left(NetworkFailure('offline')));

    expect(await refresher.refreshSession(), RefreshOutcome.failed);
  });
}
