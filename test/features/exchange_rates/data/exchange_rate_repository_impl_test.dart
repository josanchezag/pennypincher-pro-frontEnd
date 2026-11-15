import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/error/app_exception.dart';
import 'package:pennypincher_pro/core/error/error_codes.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/core/time/clock.dart';
import 'package:pennypincher_pro/features/exchange_rates/data/datasource/exchange_rate_remote_datasource.dart';
import 'package:pennypincher_pro/features/exchange_rates/data/model/today_exchange_rates_model.dart';
import 'package:pennypincher_pro/features/exchange_rates/data/repository/exchange_rate_repository_impl.dart';
import 'package:pennypincher_pro/features/exchange_rates/domain/entity/today_exchange_rates_entity.dart';

import '../../../helpers/exchange_rate_fixtures.dart';

class _MockRemote extends Mock implements ExchangeRateRemoteDataSource {}

class _Clock implements Clock {
  DateTime time = DateTime(2026, 10, 22, 9, 30);

  @override
  DateTime now() => time;
}

TodayExchangeRatesModel _model(Map<String, Object?> json) =>
    TodayExchangeRatesModel.fromJson(Map.of(json));

const AppException _offline =
    AppException(code: ErrorCodes.networkError, message: 'Offline');

void main() {
  late _MockRemote remote;
  late _Clock clock;
  late ExchangeRateRepositoryImpl repository;

  setUp(() {
    remote = _MockRemote();
    clock = _Clock();
    repository = ExchangeRateRepositoryImpl(remote, clock);
    when(remote.getToday).thenAnswer((_) async => _model(todayRatesJson));
  });

  test("returns today's rates", () async {
    expect(
      await repository.getToday(),
      Right<Failure, TodayExchangeRates>(freshRates),
    );
  });

  test('asks the backend once a day for complete rates', () async {
    await repository.getToday();
    clock.time = DateTime(2026, 10, 22, 23, 59);
    final later = await repository.getToday();

    expect(later, Right<Failure, TodayExchangeRates>(freshRates));
    verify(remote.getToday).called(1);
  });

  test('asks again on the next local day', () async {
    await repository.getToday();
    clock.time = DateTime(2026, 10, 23, 0, 1);
    await repository.getToday();

    verify(remote.getToday).called(2);
  });

  test('shares one request between callers at the same time', () async {
    final answer = Completer<TodayExchangeRatesModel>();
    when(remote.getToday).thenAnswer((_) => answer.future);

    final first = repository.getToday();
    final second = repository.getToday();
    answer.complete(_model(todayRatesJson));

    expect(await first, await second);
    verify(remote.getToday).called(1);
  });

  test('reports a failure and retries it only after a while', () async {
    when(remote.getToday).thenThrow(_offline);

    final failed = await repository.getToday();
    clock.time = clock.time.add(const Duration(minutes: 9));
    await repository.getToday();

    expect(failed.fold((f) => f, (_) => null), isA<NetworkFailure>());
    verify(remote.getToday).called(1);

    when(remote.getToday).thenAnswer((_) async => _model(todayRatesJson));
    clock.time = clock.time.add(const Duration(minutes: 1));

    expect(
      await repository.getToday(),
      Right<Failure, TodayExchangeRates>(freshRates),
    );
  });

  test('retries stale or partial rates only after a while', () async {
    when(remote.getToday).thenAnswer(
      (_) async => _model({...todayRatesJson, 'stale': true}),
    );

    await repository.getToday();
    clock.time = clock.time.add(const Duration(minutes: 5));
    final cached = await repository.getToday();
    verify(remote.getToday).called(1);
    expect(cached, Right<Failure, TodayExchangeRates>(staleRates));

    when(remote.getToday).thenAnswer(
      (_) async => _model({...todayRatesJson, 'eurCop': null}),
    );
    clock.time = clock.time.add(ExchangeRateRepositoryImpl.retryInterval);
    await repository.getToday();
    await repository.getToday();
    verify(remote.getToday).called(1);

    clock.time = clock.time.add(ExchangeRateRepositoryImpl.retryInterval);
    await repository.getToday();
    verify(remote.getToday).called(1);
  });
}
