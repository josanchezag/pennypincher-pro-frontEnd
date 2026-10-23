import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/features/expense_details/data/datasource/fixed_expense_remote_datasource.dart';
import 'package:pennypincher_pro/features/expense_details/data/datasource/variable_expense_remote_datasource.dart';
import 'package:pennypincher_pro/features/expense_details/data/repository/fixed_expense_repository_impl.dart';
import 'package:pennypincher_pro/features/expense_details/data/repository/variable_expense_repository_impl.dart';

import '../../../helpers/expense_fixtures.dart';

class _MockFixedRemote extends Mock implements FixedExpenseRemoteDataSource {}

class _MockVariableRemote extends Mock
    implements VariableExpenseRemoteDataSource {}

void main() {
  test('the fixed expense repository reads its data source', () async {
    final remote = _MockFixedRemote();
    when(remote.getAll).thenAnswer((_) async => [schoolAna, rent]);
    when(() => remote.delete('f1')).thenAnswer((_) async {});
    final repository = FixedExpenseRepositoryImpl(remote);

    expect((await repository.getAll()).getOrElse(() => []), [schoolAna, rent]);
    expect(await repository.delete('f1'), const Right<Failure, Unit>(unit));
  });

  test('the variable expense repository reads its data source', () async {
    final remote = _MockVariableRemote();
    when(remote.getAll).thenAnswer((_) async => [netflix]);
    final repository = VariableExpenseRepositoryImpl(remote);

    expect((await repository.getAll()).getOrElse(() => []), [netflix]);
  });
}
