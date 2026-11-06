import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:pennypincher_pro/core/utils/percent_formatter.dart';

void main() {
  final initialLocale = Intl.defaultLocale;
  tearDown(() => Intl.defaultLocale = initialLocale);

  group('in Spanish', () {
    setUp(() => Intl.defaultLocale = 'es');

    test('formats one decimal with a decimal comma', () {
      expect(PercentFormatter.format(42.67), '42,7\u00A0%');
      expect(PercentFormatter.format(8.83), '8,8\u00A0%');
      expect(PercentFormatter.format(0), '0,0\u00A0%');
      expect(PercentFormatter.format(1250.5), '1.250,5\u00A0%');
    });

    test('shows a dash without a value', () {
      expect(PercentFormatter.formatOptional(null), '—');
      expect(PercentFormatter.formatOptional(20), '20,0\u00A0%');
    });
  });

  group('in English', () {
    setUp(() => Intl.defaultLocale = 'en');

    test('formats one decimal with a decimal point and no space', () {
      expect(PercentFormatter.format(42.67), '42.7%');
      expect(PercentFormatter.format(-8.83), '-8.8%');
      expect(PercentFormatter.format(1250.5), '1,250.5%');
    });

    test('shows a dash without a value', () {
      expect(PercentFormatter.formatOptional(null), '—');
      expect(PercentFormatter.formatOptional(20), '20.0%');
    });
  });
}
