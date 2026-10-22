import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/auth/session_refresher.dart';
import 'package:pennypincher_pro/core/auth/token_service.dart';
import 'package:pennypincher_pro/core/network/auth_interceptor.dart';

import '../../helpers/fake_http_adapter.dart';

class _MockSessionRefresher extends Mock implements SessionRefresher {}

const String _oldToken = 'access-old';
const String _newToken = 'access-new';

String? _bearerOf(RequestOptions options) =>
    options.headers['Authorization'] as String?;

/// API that only accepts the new token.
Future<FakeResponse> _acceptsNewToken(RequestOptions options) async =>
    _bearerOf(options) == 'Bearer $_newToken'
        ? const FakeResponse(200, {'data': 'ok'})
        : FakeResponse(401, errorEnvelope('UNAUTHORIZED', 'Expired'));

Matcher _throwsStatus(int status) => throwsA(
      isA<DioException>()
          .having((e) => e.response?.statusCode, 'status', status),
    );

void main() {
  late TokenService tokens;
  late _MockSessionRefresher refresher;
  late FakeHttpAdapter adapter;
  late Dio dio;

  setUp(() {
    tokens = TokenService()..save(_oldToken);
    refresher = _MockSessionRefresher();
    adapter = FakeHttpAdapter(_acceptsNewToken);
    dio = fakeDio(adapter)
      ..interceptors.add(AuthInterceptor(tokens, refresher, fakeDio(adapter)));
  });

  tearDown(() => tokens.dispose());

  void refreshSucceeds({Duration delay = Duration.zero}) {
    when(refresher.refreshSession).thenAnswer((_) async {
      await Future<void>.delayed(delay);
      tokens.save(_newToken);
      return RefreshOutcome.refreshed;
    });
  }

  group('requests', () {
    test('carry the access token as a bearer', () async {
      adapter.handler = (_) async => const FakeResponse(200);

      await dio.get<Object?>('/users/me');

      expect(_bearerOf(adapter.requests.single), 'Bearer $_oldToken');
    });

    test('carry no bearer without a session', () async {
      tokens.clear();
      adapter.handler = (_) async => const FakeResponse(200);

      await dio.get<Object?>('/users/me');

      expect(_bearerOf(adapter.requests.single), isNull);
    });

    test('to /auth endpoints never carry a bearer', () async {
      adapter.handler = (_) async => const FakeResponse(200);

      await dio.post<Object?>('/auth/refresh');

      expect(_bearerOf(adapter.requests.single), isNull);
    });
  });

  group('on 401', () {
    test('refreshes the session and retries the request once', () async {
      refreshSucceeds();

      final response = await dio.get<Object?>('/users/me');

      expect(response.statusCode, 200);
      verify(refresher.refreshSession).called(1);
      expect(adapter.requests.map(_bearerOf), [
        'Bearer $_oldToken',
        'Bearer $_newToken',
      ]);
    });

    test('does not refresh again when the retry is also rejected', () async {
      refreshSucceeds();
      adapter.handler = (_) async =>
          FakeResponse(401, errorEnvelope('UNAUTHORIZED', 'Expired'));

      await expectLater(dio.get<Object?>('/users/me'), _throwsStatus(401));

      verify(refresher.refreshSession).called(1);
      expect(adapter.requests, hasLength(2));
    });

    test('shares a single refresh between concurrent requests', () async {
      refreshSucceeds(delay: const Duration(milliseconds: 20));

      final responses = await Future.wait([
        dio.get<Object?>('/assets'),
        dio.get<Object?>('/liabilities'),
        dio.get<Object?>('/users/me'),
      ]);

      expect(responses.map((r) => r.statusCode), everyElement(200));
      verify(refresher.refreshSession).called(1);
    });

    test('ends the session when the refresh is rejected', () async {
      when(refresher.refreshSession)
          .thenAnswer((_) async => RefreshOutcome.rejected);
      final expired = expectLater(tokens.sessionExpired, emits(null));

      await expectLater(dio.get<Object?>('/users/me'), _throwsStatus(401));

      await expired;
      expect(tokens.hasToken, isFalse);
      expect(adapter.requests, hasLength(1));
    });

    test('rejects queued requests without refreshing again after expiry',
        () async {
      when(refresher.refreshSession)
          .thenAnswer((_) async => RefreshOutcome.rejected);

      final results = await Future.wait([
        dio
            .get<Object?>('/assets')
            .then<Object?>((r) => r, onError: (Object e) => e),
        dio
            .get<Object?>('/users/me')
            .then<Object?>((r) => r, onError: (Object e) => e),
      ]);

      expect(results, everyElement(isA<DioException>()));
      verify(refresher.refreshSession).called(1);
    });

    test('keeps the session when the refresh cannot reach the server',
        () async {
      when(refresher.refreshSession)
          .thenAnswer((_) async => RefreshOutcome.failed);

      await expectLater(dio.get<Object?>('/users/me'), _throwsStatus(401));

      expect(tokens.accessToken, _oldToken);
    });

    test('never refreshes for /auth endpoints', () async {
      await expectLater(dio.post<Object?>('/auth/refresh'), _throwsStatus(401));

      verifyNever(refresher.refreshSession);
    });

    test('never refreshes for requests sent without a token', () async {
      tokens.clear();

      await expectLater(dio.get<Object?>('/users/me'), _throwsStatus(401));

      verifyNever(refresher.refreshSession);
    });
  });

  test('passes other errors through untouched', () async {
    adapter.handler =
        (_) async => FakeResponse(500, errorEnvelope('INTERNAL_ERROR', 'Boom'));

    await expectLater(dio.get<Object?>('/users/me'), _throwsStatus(500));

    verifyNever(refresher.refreshSession);
  });
}
