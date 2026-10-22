import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/error/app_exception.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/features/budget/data/datasource/income_source_remote_datasource.dart';
import 'package:pennypincher_pro/features/budget/data/repository/income_source_repository_impl.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/income_source_entity.dart';

import '../../../helpers/budget_fixtures.dart';

class _MockRemote extends Mock implements IncomeSourceRemoteDataSource {}

void main() {
  late _MockRemote remote;
  late IncomeSourceRepositoryImpl repository;
  final draft = ItemDraft(
    name: remoti.name,
    amount: remoti.amount,
    category: remoti.category,
  );

  setUp(() {
    remote = _MockRemote();
    repository = IncomeSourceRepositoryImpl(remote);
  });

  test('returns the income sources', () async {
    when(remote.getAll).thenAnswer((_) async => [avenueCode, remoti]);

    final result = await repository.getAll();

    expect(result.getOrElse(() => []), [avenueCode, remoti]);
  });

  test('returns the saved income source and unit after deleting', () async {
    when(() => remote.create(draft)).thenAnswer((_) async => remoti);
    when(() => remote.update('i2', draft)).thenAnswer((_) async => remoti);
    when(() => remote.delete('i2')).thenAnswer((_) async {});

    expect(
      await repository.create(draft),
      const Right<Failure, IncomeSource>(remoti),
    );
    expect(
      await repository.update('i2', draft),
      const Right<Failure, IncomeSource>(remoti),
    );
    expect(await repository.delete('i2'), const Right<Failure, Unit>(unit));
  });

  test('maps a missing income source to a not found failure', () async {
    when(() => remote.update('x', draft)).thenThrow(
      const AppException(
        code: 'NOT_FOUND',
        message: 'Income source not found',
        statusCode: 404,
      ),
    );

    final result = await repository.update('x', draft);

    expect(
      result.fold((failure) => failure, (_) => null),
      isA<NotFoundFailure>(),
    );
  });
}
