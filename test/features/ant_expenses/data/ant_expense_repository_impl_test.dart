import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/error/error_codes.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/ant_expenses/data/datasource/ant_expense_remote_datasource.dart';
import 'package:pennypincher_pro/features/ant_expenses/data/repository/ant_expense_repository_impl.dart';

import '../../../helpers/ant_fixtures.dart';
import '../../../helpers/fake_http_adapter.dart';
import '../../../helpers/l10n.dart';

void main() {
  late FakeHttpAdapter adapter;
  late AntExpenseRepositoryImpl repository;

  setUp(() {
    adapter = FakeHttpAdapter((_) async => FakeResponse(200, envelope([])));
    repository = AntExpenseRepositoryImpl(
      AntExpenseRemoteDataSource(fakeDio(adapter)),
    );
  });

  void answer(Object? data) =>
      adapter.handler = (_) async => FakeResponse(200, envelope(data));

  test('returns every report on success', () async {
    answer(antSummaryJson);
    expect(await repository.getSummary(), Right<Failure, Object>(antSummary));
    answer([octoberCutJson]);
    expect((await repository.getCuts()).getOrElse(() => []), [octoberCut]);
    answer([octoberSnackJson]);
    expect(
      (await repository.getCutItems(octoberBudgetId)).getOrElse(() => []),
      [octoberSnack],
    );
    answer([
      {'year': 2026, 'month': 11, 'total': 27000, 'count': 3},
    ]);
    expect(
      (await repository.getTrend(DateTime(2026, 11), 1))
          .getOrElse(() => [])
          .single
          .total,
      const Money.fromUnits(27000),
    );
    answer({'monthlyLimit': null, 'updatedAt': null});
    expect(
      await repository.saveLimit(null),
      const Right<Failure, Money?>(null),
    );
  });

  test('maps a cut expense to a server failure with its own message', () async {
    adapter.handler = (_) async =>
        FakeResponse(409, errorEnvelope('ANT_EXPENSE_ALREADY_CUT', 'Cut'));

    final result = await repository.delete('ae-9');

    final failure = result.swap().getOrElse(() => throw StateError('ok'));
    expect(
      failure,
      isA<ServerFailure>()
          .having((f) => f.code, 'code', ErrorCodes.antExpenseAlreadyCut)
          .having((f) => f.message, 'message', l10n.errorAntExpenseAlreadyCut),
    );
  });

  test('maps a budget of another user to not found', () async {
    adapter.handler =
        (_) async => FakeResponse(404, errorEnvelope('NOT_FOUND', 'Missing'));

    final result = await repository.getCutItems('other');

    expect(result.isLeft(), isTrue);
    result.leftMap((failure) => expect(failure, isA<NotFoundFailure>()));
  });

  test('maps a lost connection to a network failure', () async {
    adapter.handler = (_) async => throw Exception('offline');

    final result = await repository.getSummary();

    result.leftMap((failure) => expect(failure, isA<NetworkFailure>()));
    expect(result.isLeft(), isTrue);
  });
}
