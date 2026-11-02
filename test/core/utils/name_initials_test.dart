import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/utils/name_initials.dart';

void main() {
  group('NameInitials', () {
    const cases = {
      'Josimar Sanchez': 'JS',
      '  ada   byron lovelace ': 'AL',
      'ana': 'A',
      'Ángela Díaz': 'ÁD',
      '   ': '',
    };
    for (final MapEntry(key: name, value: initials) in cases.entries) {
      test('reads "$name" as "$initials"', () {
        expect(NameInitials.of(name), initials);
      });
    }

    test('splits the name into its non-empty words', () {
      expect(NameInitials.words(' Ada  Lovelace '), ['Ada', 'Lovelace']);
      expect(NameInitials.words(''), isEmpty);
    });
  });
}
