// Checks that vercel.json serves the bundle like nginx.conf: same security
// headers (plus HSTS), same caching, SPA fallback that never shadows real
// files, and a CSP whose connect-src allows the origin of API_BASE_URL.
//
// Used by tool/check_vercel_config.dart (CI and the Vercel build) and by
// test/tool/vercel_config_test.dart.
import 'dart:convert';

/// Placeholder of nginx.conf replaced by the API origin when the container
/// starts.
const String apiOriginPlaceholder = r'${API_ORIGIN}';

/// HSTS is set by the proxy in front of nginx, and by Vercel from vercel.json.
const String hstsHeader = 'Strict-Transport-Security';
const String hstsValue = 'max-age=63072000; includeSubDomains';

const String securityHeadersSource = '/(.*)';

/// Caching of nginx.conf: everything revalidates (`expires -1`) except the
/// CanvasKit runtime and the icons (`expires 1d`).
const Map<String, String> expectedCacheControl = {
  '/((?!canvaskit/|icons/).*)': 'no-cache',
  '/(canvaskit|icons)/(.*)': 'max-age=86400',
};

/// SPA fallback. Vercel serves existing files before applying rewrites, and
/// missing files under these folders stay 404s, as in nginx.conf.
const String spaRewriteSource = '/((?!assets/|canvaskit/|icons/).*)';
const String spaRewriteDestination = '/index.html';

const Map<String, Object?> expectedBuildSettings = {
  'framework': null,
  'installCommand': 'bash tool/vercel_install.sh',
  'buildCommand': 'bash tool/vercel_build.sh',
  'outputDirectory': 'build/web',
};

/// Properties that would change routing behind the checks above. `cleanUrls`
/// would redirect /auth.html, the Google OAuth redirect URI, to /auth.
const List<String> forbiddenProperties = [
  'routes',
  'redirects',
  'trailingSlash',
  'builds',
];

final RegExp _addHeader = RegExp(
  r'^\s*add_header\s+([A-Za-z-]+)\s+"([^"]*)"\s+always\s*;',
  multiLine: true,
);

/// Headers set with `add_header Name "value" always;` in [nginxConf].
Map<String, String> parseNginxHeaders(String nginxConf) {
  final headers = <String, String>{};
  for (final match in _addHeader.allMatches(nginxConf)) {
    final name = match.group(1)!;
    if (headers.containsKey(name)) {
      throw FormatException('nginx.conf sets $name twice');
    }
    headers[name] = match.group(2)!;
  }
  if (headers.isEmpty) {
    throw const FormatException('nginx.conf sets no headers');
  }
  return headers;
}

/// `https://host[:port]` of [apiBaseUrl], the value of API_BASE_URL.
String apiOriginOf(String apiBaseUrl) {
  final uri = Uri.tryParse(apiBaseUrl);
  if (uri == null ||
      uri.scheme != 'https' ||
      uri.host.isEmpty ||
      uri.userInfo.isNotEmpty ||
      uri.hasQuery ||
      uri.hasFragment) {
    throw FormatException('API base URL must be an https URL: $apiBaseUrl');
  }
  return uri.origin;
}

/// Problems of [vercelJson] compared with [nginxConf] for the API at
/// [apiBaseUrl]; empty when the configuration is correct.
List<String> checkVercelConfig({
  required String vercelJson,
  required String nginxConf,
  required String apiBaseUrl,
}) {
  final errors = <String>[];

  final Object? decoded;
  try {
    decoded = jsonDecode(vercelJson);
  } on FormatException catch (e) {
    return ['vercel.json is not valid JSON: ${e.message}'];
  }
  if (decoded is! Map<String, Object?>) {
    return ['vercel.json must be a JSON object'];
  }
  final Map<String, Object?> config = decoded;

  final String apiOrigin;
  final Map<String, String> nginxHeaders;
  try {
    apiOrigin = apiOriginOf(apiBaseUrl);
    nginxHeaders = parseNginxHeaders(nginxConf);
  } on FormatException catch (e) {
    return [e.message];
  }

  expectedBuildSettings.forEach((key, value) {
    if (!config.containsKey(key) || config[key] != value) {
      errors.add('vercel.json "$key" must be ${jsonEncode(value)}');
    }
  });
  for (final key in forbiddenProperties) {
    if (config.containsKey(key)) {
      errors.add('vercel.json must not use "$key"');
    }
  }
  if (config['cleanUrls'] == true) {
    errors.add('vercel.json "cleanUrls" would redirect /auth.html');
  }

  errors.addAll(_checkRewrites(config['rewrites']));

  final rules = _headerRules(config['headers'], errors);
  if (rules == null) return errors;

  final expectedRules = <String, Map<String, String>>{
    securityHeadersSource: {
      for (final entry in nginxHeaders.entries)
        entry.key: entry.value.replaceAll(apiOriginPlaceholder, apiOrigin),
      hstsHeader: hstsValue,
    },
    for (final entry in expectedCacheControl.entries)
      entry.key: {'Cache-Control': entry.value},
  };

  for (final source in rules.keys) {
    if (!expectedRules.containsKey(source)) {
      errors.add('vercel.json has an unexpected header rule for "$source"');
    }
  }
  expectedRules.forEach((source, expected) {
    final actual = rules[source];
    if (actual == null) {
      errors.add('vercel.json has no header rule for "$source"');
      return;
    }
    expected.forEach((name, value) {
      final actualValue = actual[name];
      if (actualValue == null) {
        errors.add('vercel.json "$source" does not set $name');
      } else if (actualValue != value) {
        errors.add(
          'vercel.json "$source" $name differs from nginx.conf'
          '${name == 'Content-Security-Policy' ? ' with API origin $apiOrigin' : ''}'
          ':\n  expected: $value\n  actual:   $actualValue',
        );
      }
    });
    for (final name in actual.keys) {
      if (!expected.containsKey(name)) {
        errors.add('vercel.json "$source" sets unexpected header $name');
      }
    }
  });

  final csp = rules[securityHeadersSource]?['Content-Security-Policy'];
  if (csp != null) errors.addAll(checkCsp(csp, apiOrigin));
  return errors;
}

/// Invariants of the Content-Security-Policy that hold whatever nginx.conf
/// says.
List<String> checkCsp(String csp, String apiOrigin) {
  final errors = <String>[];
  final directives = <String, List<String>>{};
  for (final part in csp.split(';')) {
    final tokens = part.trim().split(RegExp(r'\s+'));
    if (tokens.first.isEmpty) continue;
    directives[tokens.first] = tokens.sublist(1);
  }
  void expect(String directive, List<String> value) {
    if ((directives[directive] ?? const []).join(' ') != value.join(' ')) {
      errors.add('CSP $directive must be ${value.join(' ')}');
    }
  }

  expect('default-src', ["'self'"]);
  expect('object-src', ["'none'"]);
  expect('base-uri', ["'self'"]);
  expect('frame-ancestors', ["'none'"]);
  final scriptSrc = directives['script-src'] ?? const [];
  for (final unsafe in ["'unsafe-inline'", "'unsafe-eval'", '*', 'data:']) {
    if (scriptSrc.contains(unsafe)) {
      errors.add('CSP script-src must not allow $unsafe');
    }
  }
  final connectSrc = directives['connect-src'] ?? const [];
  if (!connectSrc.contains(apiOrigin)) {
    errors.add('CSP connect-src must allow the API origin $apiOrigin');
  }
  for (final source in connectSrc) {
    if (source != "'self'" && !source.startsWith('https://')) {
      errors.add('CSP connect-src must only allow https origins: $source');
    }
    if (source.contains('localhost') || source.contains('127.0.0.1')) {
      errors.add('CSP connect-src must not allow local addresses: $source');
    }
  }
  return errors;
}

List<String> _checkRewrites(Object? rewrites) {
  const expected = 'vercel.json "rewrites" must be exactly the SPA fallback '
      '{"source": "$spaRewriteSource", "destination": "$spaRewriteDestination"}';
  if (rewrites is! List<Object?> || rewrites.length != 1) return [expected];
  final rewrite = rewrites.single;
  if (rewrite is! Map<String, Object?> ||
      rewrite.length != 2 ||
      rewrite['source'] != spaRewriteSource ||
      rewrite['destination'] != spaRewriteDestination) {
    return [expected];
  }
  return const [];
}

Map<String, Map<String, String>>? _headerRules(
  Object? headers,
  List<String> errors,
) {
  if (headers is! List<Object?>) {
    errors.add('vercel.json "headers" must be a list');
    return null;
  }
  final rules = <String, Map<String, String>>{};
  for (final rule in headers) {
    if (rule is! Map<String, Object?> ||
        rule['source'] is! String ||
        rule['headers'] is! List<Object?> ||
        rule.keys.any((key) => key != 'source' && key != 'headers')) {
      errors.add('vercel.json header rules must only have source and headers');
      return null;
    }
    final source = rule['source']! as String;
    if (rules.containsKey(source)) {
      errors.add('vercel.json has two header rules for "$source"');
      return null;
    }
    final values = <String, String>{};
    for (final header in rule['headers']! as List<Object?>) {
      if (header is! Map<String, Object?> ||
          header['key'] is! String ||
          header['value'] is! String) {
        errors.add('vercel.json "$source" headers must be {key, value}');
        return null;
      }
      final key = header['key']! as String;
      if (values.containsKey(key)) {
        errors.add('vercel.json "$source" sets $key twice');
      }
      values[key] = header['value']! as String;
    }
    rules[source] = values;
  }
  return rules;
}
