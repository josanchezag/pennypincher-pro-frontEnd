import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _arb(String language) =>
    jsonDecode(File('lib/l10n/app_$language.arb').readAsStringSync())
        as Map<String, dynamic>;

Set<String> _messages(Map<String, dynamic> arb) =>
    arb.keys.where((key) => !key.startsWith('@')).toSet();

/// Placeholders the English template declares for [key].
Iterable<String> _placeholders(Map<String, dynamic> template, String key) {
  final metadata = template['@$key'] as Map<String, dynamic>?;
  final placeholders = metadata?['placeholders'] as Map<String, dynamic>?;
  return placeholders?.keys ?? const [];
}

void main() {
  final english = _arb('en');
  final spanish = _arb('es');

  test('both languages have the same messages', () {
    expect(_messages(spanish), _messages(english));
  });

  test('every Spanish message uses the placeholders of the English one', () {
    for (final key in _messages(english)) {
      for (final name in _placeholders(english, key)) {
        expect(spanish[key], contains('{$name'), reason: '$key: $name');
      }
    }
  });

  test('no message is left empty', () {
    for (final arb in [english, spanish]) {
      for (final key in _messages(arb)) {
        expect((arb[key] as String).trim(), isNotEmpty, reason: key);
      }
    }
  });
}
