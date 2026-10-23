import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/error/app_exception.dart';
import 'package:pennypincher_pro/core/error/error_codes.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/features/dashboard/data/datasource/dashboard_remote_datasource.dart';
import 'package:pennypincher_pro/features/dashboard/data/repository/dashboard_repository_impl.dart';

import '../../../helpers/dashboard_fixtures.dart';

class _MockDashboardRemoteDataSource extends Mock
    implements DashboardRemoteDataSource {}

void main() {
  late _MockDashboardRemoteDataSource remote;
  late DashboardRepositoryImpl repository;

  setUp(() {
    remote = _MockDashboardRemoteDataSource();
    repository = DashboardRepositoryImpl(remote);
  });

  test('loads the summary of the month of any day', () async {
    when(() => remote.getSummary(DateTime(2026, 10)))
        .thenAnswer((_) async => dashboardSummary);

    final result = await repository.getSummary(DateTime(2026, 10, 22, 21));

    expect(result, Right<Failure, Object>(dashboardSummary));
  });

  test('records the snapshot of the first day of the month', () async {
    when(() => remote.recordSnapshot(DateTime(2026, 10)))
        .thenAnswer((_) async {});

    final result = await repository.recordSnapshot(DateTime(2026, 10, 31));

    expect(result, const Right<Failure, Unit>(unit));
    verify(() => remote.recordSnapshot(DateTime(2026, 10))).called(1);
  });

  test('maps failures of the data source', () async {
    when(() => remote.getSummary(DateTime(2026, 10))).thenThrow(
      const AppException(code: ErrorCodes.networkError, message: 'Offline'),
    );
    when(() => remote.recordSnapshot(DateTime(2026, 10))).thenThrow(
      const AppException(code: 'VALIDATION_FAILED', message: 'Bad date'),
    );

    final summary = await repository.getSummary(DateTime(2026, 10));
    final snapshot = await repository.recordSnapshot(DateTime(2026, 10));

    expect(summary.fold((f) => f, (_) => null), isA<NetworkFailure>());
    expect(snapshot.fold((f) => f.message, (_) => null), 'Bad date');
  });
}
