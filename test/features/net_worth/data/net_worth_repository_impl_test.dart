import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/error/app_exception.dart';
import 'package:pennypincher_pro/core/error/error_codes.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/features/net_worth/data/datasource/net_worth_remote_datasource.dart';
import 'package:pennypincher_pro/features/net_worth/data/model/net_worth_models.dart';
import 'package:pennypincher_pro/features/net_worth/data/repository/net_worth_repository_impl.dart';

import '../../../helpers/net_worth_fixtures.dart';

class _MockNetWorthRemoteDataSource extends Mock
    implements NetWorthRemoteDataSource {}

NetWorthSnapshotModel _model(Map<String, Object?> json) =>
    NetWorthSnapshotModel.fromJson(json);

void main() {
  late _MockNetWorthRemoteDataSource remote;
  late NetWorthRepositoryImpl repository;

  setUp(() {
    remote = _MockNetWorthRemoteDataSource();
    repository = NetWorthRepositoryImpl(remote);
  });

  test('returns the history sorted from the oldest month', () async {
    when(remote.getSnapshots).thenAnswer(
      (_) async => [
        _model(septemberJson),
        _model({
          ...septemberJson,
          'id': 's-2026-8',
          'snapshotDate': '2026-08-01',
        }),
      ],
    );

    final result = await repository.getSnapshots();

    final dates = result.getOrElse(() => []).map((s) => s.snapshotDate);
    expect(dates, [DateTime(2026, 8), DateTime(2026, 9)]);
  });

  test('returns the live totals and the created snapshot', () async {
    when(remote.getCurrent).thenAnswer(
      (_) async => NetWorthSummaryModel.fromJson(const {
        'totalAssets': 185000000,
        'totalLiabilities': 12000000,
        'netWorth': 173000000,
      }),
    );
    when(() => remote.createSnapshot(DateTime(2026, 9)))
        .thenAnswer((_) async => _model(septemberJson));

    final current = await repository.getCurrent();
    final created = await repository.createSnapshot(DateTime(2026, 9));

    expect(current.getOrElse(() => throw StateError('')), currentSummary);
    expect(created.getOrElse(() => throw StateError('')), september);
  });

  test('maps failures of the data source', () async {
    when(remote.getCurrent).thenThrow(
      const AppException(code: ErrorCodes.networkError, message: 'Offline'),
    );

    final result = await repository.getCurrent();

    expect(
      result.fold((failure) => failure, (_) => null),
      isA<NetworkFailure>(),
    );
  });
}
