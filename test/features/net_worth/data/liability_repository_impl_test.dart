import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/error/app_exception.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/features/net_worth/data/datasource/liability_remote_datasource.dart';
import 'package:pennypincher_pro/features/net_worth/data/repository/liability_repository_impl.dart';

import '../../../helpers/net_worth_fixtures.dart';

class _MockLiabilityRemoteDataSource extends Mock
    implements LiabilityRemoteDataSource {}

void main() {
  late _MockLiabilityRemoteDataSource remote;
  late LiabilityRepositoryImpl repository;

  setUp(() {
    remote = _MockLiabilityRemoteDataSource();
    repository = LiabilityRepositoryImpl(remote);
  });

  test('returns the liabilities', () async {
    when(remote.getAll).thenAnswer((_) async => [nuCard, davivienda]);

    final result = await repository.getAll();

    expect(result.getOrElse(() => []), [nuCard, davivienda]);
  });

  test('maps a backend error to a server failure', () async {
    when(() => remote.delete('l1')).thenThrow(
      const AppException(
        code: 'VALIDATION_FAILED',
        message: 'Invalid',
        statusCode: 400,
      ),
    );

    final result = await repository.delete('l1');

    expect(
      result.fold((failure) => failure, (_) => unit),
      isA<ServerFailure>().having((f) => f.code, 'code', 'VALIDATION_FAILED'),
    );
  });
}
