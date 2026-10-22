import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/features/auth/data/oauth/oauth_constants.dart';

/// Generates the PKCE code verifier, its S256 challenge and the `state`
/// value that binds the authorization response to this request.
@lazySingleton
class PkceGenerator {
  PkceGenerator({@ignoreParam Random? random})
      : _random = random ?? Random.secure();

  final Random _random;

  /// Random verifier made of RFC 7636 unreserved characters.
  String generateVerifier() {
    const charset = PkceSpec.unreservedCharacters;
    return String.fromCharCodes(
      List.generate(
        PkceSpec.verifierLength,
        (_) => charset.codeUnitAt(_random.nextInt(charset.length)),
      ),
    );
  }

  /// Unguessable, URL-safe value echoed back by the authorization server.
  String generateState() => _base64UrlNoPadding(
        List.generate(
          PkceSpec.stateBytes,
          (_) => _random.nextInt(PkceSpec.byteValues),
        ),
      );

  /// `BASE64URL(SHA256(ASCII(verifier)))` without padding.
  static String challengeFor(String verifier) =>
      _base64UrlNoPadding(sha256.convert(ascii.encode(verifier)).bytes);

  /// Whether the callback [actual] state is the one this client sent.
  static bool stateMatches({required String expected, String? actual}) =>
      expected.isNotEmpty && actual == expected;

  static String _base64UrlNoPadding(List<int> bytes) =>
      base64Url.encode(bytes).replaceAll('=', '');
}
