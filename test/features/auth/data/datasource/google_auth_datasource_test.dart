import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/features/auth/data/datasource/google_auth_datasource.dart';
import 'package:pennypincher_pro/features/auth/data/oauth/oauth_constants.dart';
import 'package:pennypincher_pro/features/auth/data/oauth/oauth_exception.dart';
import 'package:pennypincher_pro/features/auth/data/oauth/pkce_generator.dart';
import 'package:pennypincher_pro/features/auth/data/oauth/web_authenticator.dart';

import '../../../../helpers/test_config.dart';

class _MockPkceGenerator extends Mock implements PkceGenerator {}

class _MockWebAuthenticator extends Mock implements WebAuthenticator {}

const String _verifier = 'dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk';
const String _state = 'state-123';

Matcher _throwsOAuth(String code) => throwsA(
      isA<OAuthException>().having((e) => e.code, 'code', code),
    );

void main() {
  late _MockPkceGenerator pkce;
  late _MockWebAuthenticator authenticator;
  late GoogleAuthDataSource dataSource;

  setUpAll(() => registerFallbackValue(Uri()));

  setUp(() {
    pkce = _MockPkceGenerator();
    authenticator = _MockWebAuthenticator();
    when(pkce.generateVerifier).thenReturn(_verifier);
    when(pkce.generateState).thenReturn(_state);
    dataSource =
        GoogleAuthDataSource(TestConfigs.googleOnly, pkce, authenticator);
  });

  void callbackReturns(Map<String, String> params) {
    when(
      () => authenticator.authenticate(
        url: any(named: 'url'),
        callbackUrlScheme: any(named: 'callbackUrlScheme'),
      ),
    ).thenAnswer(
      (_) async => Uri.parse(TestConfigs.redirectUri)
          .replace(queryParameters: params)
          .toString(),
    );
  }

  test('opens Google with the S256 challenge and returns the code', () async {
    callbackReturns({'code': 'auth-code', 'state': _state});

    final authorization = await dataSource.authorize();

    expect(authorization.code, 'auth-code');
    expect(authorization.codeVerifier, _verifier);
    expect(authorization.redirectUri, TestConfigs.redirectUri);
    final captured = verify(
      () => authenticator.authenticate(
        url: captureAny(named: 'url'),
        callbackUrlScheme: 'http',
      ),
    ).captured.single as Uri;
    expect(captured.queryParameters, containsPair('state', _state));
    expect(
      captured.queryParameters,
      containsPair(
        'code_challenge',
        'E9Melhoa2OwvFrEMTJguCHaoeK1t8URWbuGJSstw-cM',
      ),
    );
    expect(
      captured.queryParameters,
      containsPair('client_id', TestConfigs.clientId),
    );
  });

  test('clears a stale stored callback before opening Google', () async {
    callbackReturns({'code': 'auth-code', 'state': _state});

    await dataSource.authorize();

    verifyInOrder([
      authenticator.clearPendingCallback,
      () => authenticator.authenticate(
            url: any(named: 'url'),
            callbackUrlScheme: any(named: 'callbackUrlScheme'),
          ),
    ]);
  });

  test('rejects a callback whose state differs from the request', () {
    callbackReturns({'code': 'auth-code', 'state': 'forged'});

    expect(dataSource.authorize(), _throwsOAuth(OAuthErrorCodes.stateMismatch));
  });

  test('rejects a callback without state', () {
    callbackReturns({'code': 'auth-code'});

    expect(dataSource.authorize(), _throwsOAuth(OAuthErrorCodes.stateMismatch));
  });

  test('reports a denied consent as a cancelled sign-in', () {
    callbackReturns({'error': 'access_denied', 'state': _state});

    expect(dataSource.authorize(), _throwsOAuth(OAuthErrorCodes.cancelled));
  });

  test('fails when the callback carries no code', () {
    callbackReturns({'state': _state});

    expect(dataSource.authorize(), _throwsOAuth(OAuthErrorCodes.failed));
  });

  test('fails when the callback is not a URL', () {
    when(
      () => authenticator.authenticate(
        url: any(named: 'url'),
        callbackUrlScheme: any(named: 'callbackUrlScheme'),
      ),
    ).thenAnswer((_) async => 'http://[::1');

    expect(dataSource.authorize(), _throwsOAuth(OAuthErrorCodes.failed));
  });

  test('propagates a closed window as a cancelled sign-in', () {
    when(
      () => authenticator.authenticate(
        url: any(named: 'url'),
        callbackUrlScheme: any(named: 'callbackUrlScheme'),
      ),
    ).thenThrow(const OAuthException.cancelled());

    expect(dataSource.authorize(), _throwsOAuth(OAuthErrorCodes.cancelled));
  });

  test('does not open Google without a client id', () {
    final unconfigured =
        GoogleAuthDataSource(TestConfigs.unconfigured, pkce, authenticator);

    expect(
      unconfigured.authorize(),
      _throwsOAuth(OAuthErrorCodes.notConfigured),
    );
    verifyNever(
      () => authenticator.authenticate(
        url: any(named: 'url'),
        callbackUrlScheme: any(named: 'callbackUrlScheme'),
      ),
    );
  });
}
