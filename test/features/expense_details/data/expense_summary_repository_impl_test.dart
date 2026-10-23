import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/error/app_exception.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/features/expense_details/data/datasource/expense_summary_remote_datasource.dart';
import 'package:pennypincher_pro/features/expense_details/data/repository/expense_summary_repository_impl.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/expense_summary_entity.dart';

import '../../../helpers/expense_fixtures.dart';

class _MockRemote extends Mock implements ExpenseSummaryRemoteDataSource {}

void main() {
  late _MockRemote remote;
  late ExpenseSummaryRepositoryImpl repository;

  setUp(() {
    remote = _MockRemote();
    repository = ExpenseSummaryRepositoryImpl(remote);
  });

  test('returns the summary of a list', () async {
    when(() => remote.getSummary(ExpenseKind.creditCards))
        .thenAnswer((_) async => cardsSummary);

    expect(
      await repository.getSummary(ExpenseKind.creditCards),
      const Right<Failure, ExpenseSummary>(cardsSummary),
    );
  });

  test('maps a network error to a failure', () async {
    when(() => remote.getSummary(ExpenseKind.savings)).thenThrow(
      const AppException(code: 'NETWORK_ERROR', message: 'Offline'),
    );

    final result = await repository.getSummary(ExpenseKind.savings);

    expect(
      result.fold((failure) => failure, (_) => null),
      isA<NetworkFailure>(),
    );
  });
}
