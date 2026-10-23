import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/crud/domain/balance_item.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/features/expense_details/data/datasource/savings_account_remote_datasource.dart';
import 'package:pennypincher_pro/features/expense_details/data/repository/savings_account_repository_impl.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/savings_account_entity.dart';

import '../../../helpers/expense_fixtures.dart';

class _MockRemote extends Mock implements SavingsAccountRemoteDataSource {}

void main() {
  test('returns the savings accounts and the saved account', () async {
    final remote = _MockRemote();
    final repository = SavingsAccountRepositoryImpl(remote);
    final draft = BalanceDraft(
      name: cdt.name,
      monthlyAmount: cdt.monthlyContribution,
      balance: cdt.currentBalance,
    );
    when(remote.getAll).thenAnswer((_) async => [emergencyFund, cdt]);
    when(() => remote.create(draft)).thenAnswer((_) async => cdt);

    expect(
      (await repository.getAll()).getOrElse(() => []),
      [emergencyFund, cdt],
    );
    expect(
      await repository.create(draft),
      const Right<Failure, SavingsAccount>(cdt),
    );
  });
}
