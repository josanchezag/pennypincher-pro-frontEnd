// Fails when vercel.json drifts from nginx.conf or its CSP does not allow
// the API origin of the build.
//
//   dart tool/check_vercel_config.dart --api-base-url https://api.example.com/api/v1
//
// Run from the repository root. The Vercel build runs it with the real
// FLUTTER_API_BASE_URL (tool/vercel_build.sh), and CI with the production
// value.
import 'dart:io';

import 'vercel_config.dart';

void main(List<String> args) {
  if (args.length != 2 || args.first != '--api-base-url') {
    stderr.writeln(
      'usage: dart tool/check_vercel_config.dart --api-base-url <url>',
    );
    exit(64);
  }
  final errors = checkVercelConfig(
    vercelJson: File('vercel.json').readAsStringSync(),
    nginxConf: File('nginx.conf').readAsStringSync(),
    apiBaseUrl: args[1],
  );
  if (errors.isNotEmpty) {
    for (final error in errors) {
      stderr.writeln('ERROR: $error');
    }
    exit(1);
  }
  stdout.writeln(
    'vercel.json matches nginx.conf; CSP allows ${apiOriginOf(args[1])}',
  );
}
