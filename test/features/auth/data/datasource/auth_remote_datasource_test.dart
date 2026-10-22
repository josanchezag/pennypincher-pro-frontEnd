import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/error/app_exception.dart';
import 'package:pennypincher_pro/core/error/error_codes.dart';
import 'package:pennypincher_pro/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:pennypincher_pro/features/auth/data/model/google_authorization.dart';

import '../../../../helpers/fake_http_adapter.dart';

const GoogleAuthorization _authorization = GoogleAuthorization(
  code: 'auth-code',
  redirectUri: 'http://localhost:3000/auth.html',
  codeVerifier: 'verifier',
);

Matcher _throwsApp(String code, {int? status}) => throwsA(
      isA<AppException>()
          .having((e) => e.code, 'code', code)
          .having((e) => e.statusCode, 'statusCode', status),
    );

void main() {
  late FakeHttpAdapter adapter;
  late DioAuthRemoteDataSource dataSource;

  setUp(() {
    adapter = FakeHttpAdapter(
      (_) async => FakeResponse(200, envelope(sessionJson())),
    );
    dataSource = DioAuthRemoteDataSource(fakeDio(adapter));
  });

  test('posts the code, redirect URI and verifier to the callback', () async {
    final session = await dataSource.exchangeGoogleCode(_authorization);

    final request = adapter.requests.single;
    expect(request.method, 'POST');
    expect(request.path, '/auth/google/callback');
    expect(request.data, {
      'code': 'auth-code',
      'redirectUri': 'http://localhost:3000/auth.html',
      'codeVerifier': 'verifier',
    });
    expect(session.accessToken, 'access-1');
    expect(session.tokenType, 'Bearer');
    expect(session.expiresIn, 900);
    expect(session.user.email, 'ada@example.com');
  });

  test('posts to the dev login endpoint without a body', () async {
    final session = await dataSource.devLogin();

    expect(adapter.requests.single.method, 'POST');
    expect(adapter.requests.single.path, '/auth/dev-login');
    expect(adapter.requests.single.data, isNull);
    expect(session.user.name, 'Ada Lovelace');
  });

  test('refreshes the session with the cookie, without a body', () async {
    final session = await dataSource.refresh();

    expect(adapter.requests.single.method, 'POST');
    expect(adapter.requests.single.path, '/auth/refresh');
    expect(adapter.requests.single.data, isNull);
    expect(session.accessToken, 'access-1');
  });

  test('deletes the session on logout', () async {
    adapter.handler = (_) async => const FakeResponse(204);

    await dataSource.logout();

    expect(adapter.requests.single.method, 'DELETE');
    expect(adapter.requests.single.path, '/auth/logout');
  });

  test('surfaces the backend error code, message and status', () {
    adapter.handler = (_) async => FakeResponse(
          401,
          errorEnvelope('GOOGLE_AUTH_FAILED', 'Invalid Google code'),
        );

    expect(
      dataSource.exchangeGoogleCode(_authorization),
      _throwsApp('GOOGLE_AUTH_FAILED', status: 401),
    );
  });

  test('uses a generic error when the body is not an envelope', () {
    adapter.handler = (_) async => const FakeResponse(503, 'unavailable');

    expect(dataSource.devLogin(), _throwsApp(ErrorCodes.unknown, status: 503));
  });

  test('reports unreachable servers as network errors', () {
    adapter.handler = (_) async => throw const SocketLikeException();

    expect(dataSource.devLogin(), _throwsApp(ErrorCodes.networkError));
  });

  test('rejects a success response without the expected data', () {
    adapter.handler = (_) async => FakeResponse(200, envelope({'user': 1}));

    expect(dataSource.devLogin(), _throwsApp(ErrorCodes.invalidResponse));
  });

  test('rejects a success response without an envelope', () {
    adapter.handler = (_) async => const FakeResponse(200, ['not', 'a', 'map']);

    expect(dataSource.devLogin(), _throwsApp(ErrorCodes.invalidResponse));
  });
}

/// Stand-in for a socket failure raised by the platform adapter.
class SocketLikeException implements Exception {
  const SocketLikeException();
}
