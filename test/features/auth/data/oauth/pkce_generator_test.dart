import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/features/auth/data/oauth/oauth_constants.dart';
import 'package:pennypincher_pro/features/auth/data/oauth/pkce_generator.dart';

final RegExp _unreserved = RegExp(r'^[A-Za-z0-9\-._~]+$');
final RegExp _base64UrlNoPadding = RegExp(r'^[A-Za-z0-9\-_]+$');

void main() {
  group('PkceGenerator', () {
    final generator = PkceGenerator();

    test('creates a 64-character verifier of unreserved characters', () {
      final verifier = generator.generateVerifier();

      expect(verifier, hasLength(PkceSpec.verifierLength));
      expect(verifier, matches(_unreserved));
    });

    test('keeps the verifier within the RFC 7636 length limits', () {
      expect(PkceSpec.verifierLength, inInclusiveRange(43, 128));
    });

    test('creates a different verifier on every call', () {
      final verifiers = List.generate(20, (_) => generator.generateVerifier());

      expect(verifiers.toSet(), hasLength(verifiers.length));
    });

    test('uses every character of the unreserved set', () {
      final seeded = PkceGenerator(random: Random(42));
      final used = List.generate(50, (_) => seeded.generateVerifier()).join();

      expect(
        used.split('').toSet(),
        PkceSpec.unreservedCharacters.split('').toSet(),
      );
    });

    test('creates a URL-safe 256-bit state without padding', () {
      final state = generator.generateState();

      expect(state, matches(_base64UrlNoPadding));
      expect(state, hasLength(43));
      expect(state, isNot(generator.generateState()));
    });

    test('derives the S256 challenge of RFC 7636 appendix B', () {
      expect(
        PkceGenerator.challengeFor(
          'dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk',
        ),
        'E9Melhoa2OwvFrEMTJguCHaoeK1t8URWbuGJSstw-cM',
      );
    });

    test('produces challenges without base64 padding', () {
      final challenge =
          PkceGenerator.challengeFor(generator.generateVerifier());

      expect(challenge, matches(_base64UrlNoPadding));
      expect(challenge, hasLength(43));
    });
  });

  group('PkceGenerator.stateMatches', () {
    test('accepts the state that was sent', () {
      expect(
        PkceGenerator.stateMatches(expected: 'abc', actual: 'abc'),
        isTrue,
      );
    });

    test('rejects a different or missing state', () {
      expect(
        PkceGenerator.stateMatches(expected: 'abc', actual: 'abd'),
        isFalse,
      );
      expect(PkceGenerator.stateMatches(expected: 'abc'), isFalse);
    });

    test('never accepts an empty expected state', () {
      expect(PkceGenerator.stateMatches(expected: '', actual: ''), isFalse);
    });
  });
}
