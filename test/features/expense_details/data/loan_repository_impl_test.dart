import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/crud/domain/balance_item.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/features/expense_details/data/datasource/loan_remote_datasource.dart';
import 'package:pennypincher_pro/features/expense_details/data/repository/loan_repository_impl.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/loan_entity.dart';

import '../../../helpers/expense_fixtures.dart';

class _MockRemote extends Mock implements LoanRemoteDataSource {}

void main() {
  test('returns the loans and the saved loan', () async {
    final remote = _MockRemote();
    final repository = LoanRepositoryImpl(remote);
    final draft = BalanceDraft(
      name: carLoan.name,
      monthlyAmount: carLoan.monthlyPayment,
      balance: carLoan.totalBalance,
      originalAmount: carLoan.originalAmount,
    );
    when(remote.getAll).thenAnswer((_) async => [carLoan]);
    when(() => remote.update('l1', draft)).thenAnswer((_) async => carLoan);

    expect((await repository.getAll()).getOrElse(() => []), [carLoan]);
    expect(
      await repository.update('l1', draft),
      const Right<Failure, Loan>(carLoan),
    );
  });
}
