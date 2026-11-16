import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/core/error/failure_guard.dart';
import 'package:pennypincher_pro/core/time/clock.dart';
import 'package:pennypincher_pro/core/time/day_format.dart';
import 'package:pennypincher_pro/features/exchange_rates/data/datasource/exchange_rate_remote_datasource.dart';
import 'package:pennypincher_pro/features/exchange_rates/domain/entity/today_exchange_rates_entity.dart';
import 'package:pennypincher_pro/features/exchange_rates/domain/repository/exchange_rate_repository.dart';

/// Keeps today's rates for the rest of the local day once the backend
/// gave them complete and fresh, so they are fetched once per day and app
/// session. A failure, stale or partial answer is kept for
/// [retryInterval] only, after which the next caller asks again, since the
/// backend may have recovered. Callers at the same time share one request.
@LazySingleton(as: ExchangeRateRepository)
class ExchangeRateRepositoryImpl implements ExchangeRateRepository {
  ExchangeRateRepositoryImpl(this._remote, this._clock);

  static const Duration retryInterval = Duration(minutes: 10);

  final ExchangeRateRemoteDataSource _remote;
  final Clock _clock;
  _Memo? _memo;

  @override
  Future<Either<Failure, TodayExchangeRates>> getToday() {
    final now = _clock.now();
    final memo = _memo;
    if (memo != null && memo.isValidAt(now)) {
      return memo.result;
    }
    final fresh = _Memo(
      day: DayFormat.dayOf(now),
      requestedAt: now,
      result: guardFailures(
        () async => (await _remote.getToday()).toEntity(),
      ),
    );
    _memo = fresh;
    return fresh.result;
  }
}

/// One request to the backend and, once it ended, its outcome.
class _Memo {
  _Memo({required this.day, required this.requestedAt, required this.result}) {
    result.then((outcome) => _outcome = outcome);
  }

  final DateTime day;
  final DateTime requestedAt;
  final Future<Either<Failure, TodayExchangeRates>> result;
  Either<Failure, TodayExchangeRates>? _outcome;

  bool isValidAt(DateTime now) {
    if (!DayFormat.sameDay(day, now)) {
      return false;
    }
    final outcome = _outcome;
    if (outcome == null) {
      return true;
    }
    final complete = outcome.fold((_) => false, (rates) => rates.isComplete);
    return complete ||
        now.difference(requestedAt) < ExchangeRateRepositoryImpl.retryInterval;
  }
}
