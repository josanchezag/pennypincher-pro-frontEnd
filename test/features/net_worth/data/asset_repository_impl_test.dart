import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/error/app_exception.dart';
import 'package:pennypincher_pro/core/error/error_codes.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/features/net_worth/data/datasource/asset_remote_datasource.dart';
import 'package:pennypincher_pro/features/net_worth/data/repository/asset_repository_impl.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/asset_entity.dart';

import '../../../helpers/net_worth_fixtures.dart';

class _MockAssetRemoteDataSource extends Mock
    implements AssetRemoteDataSource {}

const AppException _notFound = AppException(
  code: 'NOT_FOUND',
  message: 'Asset not found',
  statusCode: 404,
);

void main() {
  late _MockAssetRemoteDataSource remote;
  late AssetRepositoryImpl repository;
  final draft = CategorizedDraft(
    name: car.name,
    amount: car.value,
    category: car.category,
  );

  setUp(() {
    remote = _MockAssetRemoteDataSource();
    repository = AssetRepositoryImpl(remote);
  });

  test('returns the assets', () async {
    when(remote.getAll).thenAnswer((_) async => [apartment, car]);

    final result = await repository.getAll();

    expect(result.getOrElse(() => []), [apartment, car]);
  });

  test('returns the created and the updated asset', () async {
    when(() => remote.create(draft)).thenAnswer((_) async => car);
    when(() => remote.update('a2', draft)).thenAnswer((_) async => car);

    expect(await repository.create(draft), const Right<Failure, Asset>(car));
    expect(
      await repository.update('a2', draft),
      const Right<Failure, Asset>(car),
    );
  });

  test('returns unit after deleting', () async {
    when(() => remote.delete('a2')).thenAnswer((_) async {});

    expect(await repository.delete('a2'), const Right<Failure, Unit>(unit));
  });

  test('maps a missing asset to a not found failure', () async {
    when(() => remote.update('x', draft)).thenThrow(_notFound);

    final result = await repository.update('x', draft);

    expect(
      result.fold((failure) => failure, (_) => null),
      isA<NotFoundFailure>(),
    );
  });

  test('maps a network error to a network failure', () async {
    when(remote.getAll).thenThrow(
      const AppException(code: ErrorCodes.networkError, message: 'Offline'),
    );

    final result = await repository.getAll();

    expect(
      result.fold((failure) => failure.message, (_) => null),
      'Offline',
    );
    expect(
      result.fold((failure) => failure, (_) => null),
      isA<NetworkFailure>(),
    );
  });
}
