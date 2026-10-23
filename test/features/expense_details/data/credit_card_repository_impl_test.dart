import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/crud/domain/balance_item.dart';
import 'package:pennypincher_pro/core/error/app_exception.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/features/expense_details/data/datasource/credit_card_remote_datasource.dart';
import 'package:pennypincher_pro/features/expense_details/data/repository/credit_card_repository_impl.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/credit_card_entity.dart';

import '../../../helpers/expense_fixtures.dart';

class _MockRemote extends Mock implements CreditCardRemoteDataSource {}

void main() {
  late _MockRemote remote;
  late CreditCardRepositoryImpl repository;
  final draft = BalanceDraft(
    name: visaCard.name,
    monthlyAmount: visaCard.monthlyPayment,
    balance: visaCard.totalBalance,
  );

  setUp(() {
    remote = _MockRemote();
    repository = CreditCardRepositoryImpl(remote);
  });

  test('returns the credit cards, the saved one and unit after deleting',
      () async {
    when(remote.getAll).thenAnswer((_) async => [nuCard, visaCard]);
    when(() => remote.create(draft)).thenAnswer((_) async => visaCard);
    when(() => remote.delete('c2')).thenAnswer((_) async {});

    expect((await repository.getAll()).getOrElse(() => []), [nuCard, visaCard]);
    expect(
      await repository.create(draft),
      const Right<Failure, CreditCard>(visaCard),
    );
    expect(await repository.delete('c2'), const Right<Failure, Unit>(unit));
  });

  test('maps a missing credit card to a not found failure', () async {
    when(() => remote.update('x', draft)).thenThrow(
      const AppException(
        code: 'NOT_FOUND',
        message: 'Credit card not found',
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
