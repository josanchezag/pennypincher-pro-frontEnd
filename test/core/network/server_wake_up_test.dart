import 'dart:async';

import 'package:dio/dio.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/constants/app_constants.dart';
import 'package:pennypincher_pro/core/network/server_wake_up.dart';
import 'package:pennypincher_pro/core/time/clock.dart';

import '../../helpers/fake_http_adapter.dart';

/// Clock that follows the fake time of [FakeAsync].
class _FakeAsyncClock implements Clock {
  _FakeAsyncClock(this._async);

  final FakeAsync _async;

  @override
  DateTime now() => DateTime.utc(2026, 11).add(_async.elapsed);
}

/// The server is still starting: no answer at all.
Future<FakeResponse> _noAnswer(RequestOptions options) async =>
    throw const _Unreachable();

class _Unreachable implements Exception {
  const _Unreachable();
}

void main() {
  late FakeHttpAdapter adapter;

  ServerWakeUp build(FakeAsync async) =>
      ServerWakeUp(fakeDio(adapter), _FakeAsyncClock(async));

  /// Runs [wakeUp] and returns whether it completed after [elapsed].
  bool completesWithin(
    FakeAsync async,
    Future<void> wakeUp,
    Duration elapsed,
  ) {
    var done = false;
    unawaited(wakeUp.then((_) => done = true));
    async.elapse(elapsed);
    return done;
  }

  test('an unauthenticated 401 means the server is awake', () {
    fakeAsync((async) {
      adapter = FakeHttpAdapter((_) async => const FakeResponse(401));
      final server = build(async);

      expect(completesWithin(async, server.wakeUp(), Duration.zero), isTrue);
      expect(adapter.requests, hasLength(1));
      final probe = adapter.requests.single;
      expect(probe.path, ApiPaths.wakeUpProbe);
      expect(probe.method, 'GET');
      expect(probe.headers, isNot(contains(HttpHeaders.authorization)));
      expect(probe.connectTimeout, AppConstants.serverWakeUpProbeTimeout);
      expect(probe.receiveTimeout, AppConstants.serverWakeUpProbeTimeout);
    });
  });

  test('retries while the server does not answer or answers 5xx', () {
    fakeAsync((async) {
      var calls = 0;
      adapter = FakeHttpAdapter((options) async {
        calls++;
        return switch (calls) {
          1 => _noAnswer(options),
          2 => const FakeResponse(503),
          _ => const FakeResponse(200, {'data': null}),
        };
      });
      final server = build(async);
      final wakeUp = server.wakeUp();

      expect(completesWithin(async, wakeUp, Duration.zero), isFalse);
      async.elapse(AppConstants.serverWakeUpRetryDelay);
      expect(adapter.requests, hasLength(2));
      async.elapse(AppConstants.serverWakeUpRetryDelay);

      expect(adapter.requests, hasLength(3));
      expect(completesWithin(async, wakeUp, Duration.zero), isTrue);
    });
  });

  test('gives up silently once the budget runs out', () {
    fakeAsync((async) {
      adapter = FakeHttpAdapter(_noAnswer);
      final server = build(async);
      Object? error;
      var done = false;
      unawaited(
        server
            .wakeUp()
            .then((_) => done = true, onError: (Object e) => error = e),
      );

      const almost = Duration(seconds: 1);
      final beforeTheEnd = AppConstants.serverWakeUpBudget -
          AppConstants.serverWakeUpRetryDelay -
          almost;
      async.elapse(beforeTheEnd);
      expect(done, isFalse);
      async.elapse(AppConstants.serverWakeUpBudget - beforeTheEnd);

      expect(done, isTrue);
      expect(error, isNull);
      final attempts = adapter.requests.length;
      async.elapse(AppConstants.serverWakeUpBudget);
      expect(adapter.requests, hasLength(attempts));
    });
  });

  test('limits a probe to what is left of the budget', () {
    fakeAsync((async) {
      const slowAnswer = Duration(seconds: 40);
      adapter = FakeHttpAdapter(
        (_) => Future.delayed(slowAnswer, () => const FakeResponse(503)),
      );
      final server = build(async);
      unawaited(server.wakeUp());
      async.elapse(slowAnswer + AppConstants.serverWakeUpRetryDelay);

      expect(adapter.requests, hasLength(2));
      final left = AppConstants.serverWakeUpBudget -
          slowAnswer -
          AppConstants.serverWakeUpRetryDelay;
      expect(adapter.requests.last.receiveTimeout, left);
      expect(adapter.requests.last.connectTimeout, left);
      async.elapse(AppConstants.serverWakeUpBudget);
    });
  });

  test('concurrent callers share one probe', () {
    fakeAsync((async) {
      final answer = Completer<FakeResponse>();
      adapter = FakeHttpAdapter((_) => answer.future);
      final server = build(async);

      final first = server.wakeUp();
      final second = server.wakeUp();
      async.elapse(Duration.zero);

      expect(second, same(first));
      expect(adapter.requests, hasLength(1));
      answer.complete(const FakeResponse(401));
      expect(completesWithin(async, first, Duration.zero), isTrue);
    });
  });

  test('remembers an awake server for a while, then probes again', () {
    fakeAsync((async) {
      adapter = FakeHttpAdapter((_) async => const FakeResponse(401));
      final server = build(async);
      unawaited(server.wakeUp());
      async.elapse(Duration.zero);

      async.elapse(
        AppConstants.serverAwakeFor - const Duration(seconds: 1),
      );
      expect(completesWithin(async, server.wakeUp(), Duration.zero), isTrue);
      expect(adapter.requests, hasLength(1));

      async.elapse(const Duration(seconds: 1));
      expect(completesWithin(async, server.wakeUp(), Duration.zero), isTrue);
      expect(adapter.requests, hasLength(2));
    });
  });

  test('probes again after giving up', () {
    fakeAsync((async) {
      adapter = FakeHttpAdapter(_noAnswer);
      final server = build(async);
      unawaited(server.wakeUp());
      async.elapse(AppConstants.serverWakeUpBudget);
      final attempts = adapter.requests.length;

      unawaited(server.wakeUp());
      async.elapse(Duration.zero);

      expect(adapter.requests, hasLength(attempts + 1));
      async.elapse(AppConstants.serverWakeUpBudget);
    });
  });
}
