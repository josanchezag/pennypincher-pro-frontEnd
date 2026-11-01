import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/vercel_config.dart';

const String _apiBaseUrl = 'https://api.pennypincherpro.online/api/v1';

void main() {
  final vercelJson = File('vercel.json').readAsStringSync();
  final nginxConf = File('nginx.conf').readAsStringSync();

  Map<String, Object?> vercelConfig() =>
      jsonDecode(vercelJson) as Map<String, Object?>;

  List<Object?> headerRules(Map<String, Object?> config) =>
      config['headers']! as List<Object?>;

  Map<String, Object?> rule(Map<String, Object?> config, String source) =>
      headerRules(config).cast<Map<String, Object?>>().singleWhere(
            (rule) => rule['source'] == source,
          );

  List<Map<String, Object?>> headersOf(
    Map<String, Object?> config,
    String source,
  ) =>
      (rule(config, source)['headers']! as List<Object?>)
          .cast<Map<String, Object?>>();

  void setHeader(
    Map<String, Object?> config,
    String source,
    String key,
    String value,
  ) {
    headersOf(config, source).singleWhere((h) => h['key'] == key)['value'] =
        value;
  }

  List<String> check(
    Map<String, Object?> config, {
    String apiBaseUrl = _apiBaseUrl,
  }) =>
      checkVercelConfig(
        vercelJson: jsonEncode(config),
        nginxConf: nginxConf,
        apiBaseUrl: apiBaseUrl,
      );

  String csp(Map<String, Object?> config) =>
      headersOf(config, securityHeadersSource).singleWhere(
        (h) => h['key'] == 'Content-Security-Policy',
      )['value']! as String;

  group('repository files', () {
    test('vercel.json matches nginx.conf for the production API', () {
      expect(
        checkVercelConfig(
          vercelJson: vercelJson,
          nginxConf: nginxConf,
          apiBaseUrl: _apiBaseUrl,
        ),
        isEmpty,
      );
    });

    test('nginx.conf sets the six security headers', () {
      expect(parseNginxHeaders(nginxConf).keys, [
        'X-Content-Type-Options',
        'X-Frame-Options',
        'Referrer-Policy',
        'Permissions-Policy',
        'Cross-Origin-Opener-Policy',
        'Content-Security-Policy',
      ]);
    });

    test('auth.html and index.html load no inline scripts', () {
      for (final page in ['web/auth.html', 'web/index.html']) {
        final html = File(page).readAsStringSync();
        final scripts = RegExp(r'<script\b([^>]*)>([\s\S]*?)</script>')
            .allMatches(html)
            .toList();
        expect(scripts, isNotEmpty, reason: page);
        for (final script in scripts) {
          expect(script.group(1), contains('src='), reason: page);
          expect(script.group(2)!.trim(), isEmpty, reason: page);
        }
        expect(html, isNot(matches(RegExp(r'\son[a-z]+\s*='))), reason: page);
      }
    });
  });

  group('checkVercelConfig', () {
    test('fails when the API origin differs from the CSP', () {
      final errors = check(
        vercelConfig(),
        apiBaseUrl: 'https://other.example.com/api/v1',
      );

      expect(
        errors,
        contains(contains('Content-Security-Policy differs from nginx.conf')),
      );
      expect(
        errors,
        contains(contains('connect-src must allow the API origin')),
      );
    });

    test('rejects an API base URL that is not https', () {
      expect(
        check(vercelConfig(), apiBaseUrl: 'http://localhost:8080/api/v1'),
        [contains('must be an https URL')],
      );
    });

    test('fails when a security header is missing', () {
      final config = vercelConfig();
      headersOf(config, securityHeadersSource)
          .removeWhere((h) => h['key'] == 'X-Frame-Options');

      expect(check(config), [contains('does not set X-Frame-Options')]);
    });

    test('fails when a security header value drifts from nginx.conf', () {
      final config = vercelConfig();
      setHeader(config, securityHeadersSource, 'Referrer-Policy', 'origin');

      expect(check(config), [contains('Referrer-Policy differs')]);
    });

    test('fails without HSTS', () {
      final config = vercelConfig();
      setHeader(config, securityHeadersSource, hstsHeader, 'max-age=0');

      expect(check(config), [contains('Strict-Transport-Security differs')]);
    });

    test('fails when the CSP allows inline scripts', () {
      final config = vercelConfig();
      final unsafe = csp(config).replaceFirst(
        "script-src 'self'",
        "script-src 'self' 'unsafe-inline'",
      );
      setHeader(
        config,
        securityHeadersSource,
        'Content-Security-Policy',
        unsafe,
      );

      expect(
        check(config),
        containsAll(<Matcher>[
          contains('Content-Security-Policy differs'),
          contains("must not allow 'unsafe-inline'"),
        ]),
      );
    });

    test('fails on unexpected headers and header rules', () {
      final config = vercelConfig();
      headersOf(config, securityHeadersSource)
          .add({'key': 'X-Powered-By', 'value': 'x'});
      headerRules(config).add({
        'source': '/main.dart.js',
        'headers': [
          {'key': 'Cache-Control', 'value': 'max-age=31536000'},
        ],
      });

      expect(
        check(config),
        containsAll(<Matcher>[
          contains('unexpected header X-Powered-By'),
          contains('unexpected header rule for "/main.dart.js"'),
        ]),
      );
    });

    test('fails when the cache rules differ from nginx.conf', () {
      final config = vercelConfig();
      setHeader(
        config,
        '/(canvaskit|icons)/(.*)',
        'Cache-Control',
        'max-age=31536000, immutable',
      );

      expect(check(config), [contains('Cache-Control differs')]);
    });

    test('fails when the SPA rewrite shadows the asset folders', () {
      final config = vercelConfig()
        ..['rewrites'] = [
          {'source': '/(.*)', 'destination': '/index.html'},
        ];

      expect(check(config), [contains('SPA fallback')]);
    });

    test('fails with clean URLs, which would redirect /auth.html', () {
      final config = vercelConfig()..['cleanUrls'] = true;

      expect(check(config), [contains('cleanUrls')]);
    });

    test('fails when the build settings change', () {
      final config = vercelConfig()
        ..['outputDirectory'] = 'build'
        ..['routes'] = <Object?>[];

      expect(
        check(config),
        containsAll(<Matcher>[
          contains('"outputDirectory" must be "build/web"'),
          contains('must not use "routes"'),
        ]),
      );
    });

    test('reports invalid JSON', () {
      expect(
        checkVercelConfig(
          vercelJson: '{"headers": [',
          nginxConf: nginxConf,
          apiBaseUrl: _apiBaseUrl,
        ),
        [contains('not valid JSON')],
      );
    });
  });

  group('apiOriginOf', () {
    test('keeps scheme, host and port', () {
      expect(apiOriginOf(_apiBaseUrl), 'https://api.pennypincherpro.online');
      expect(
        apiOriginOf('https://api.example.com:8443/api/v1'),
        'https://api.example.com:8443',
      );
    });

    test('rejects user info', () {
      expect(
        () => apiOriginOf('https://user@api.example.com/api/v1'),
        throwsFormatException,
      );
    });
  });
}
