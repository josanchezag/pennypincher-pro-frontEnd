import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/utils/percent_formatter.dart';

/// es_CO separates the percent sign with a no-break space.
String _plain(String text) => text.replaceAll(' ', ' ');

void main() {
  test('formats one decimal with a decimal comma', () {
    expect(_plain(PercentFormatter.format(42.67)), '42,7 %');
    expect(_plain(PercentFormatter.format(8.83)), '8,8 %');
    expect(_plain(PercentFormatter.format(0)), '0,0 %');
    expect(_plain(PercentFormatter.format(1250.5)), '1.250,5 %');
  });

  test('shows a dash without a value', () {
    expect(PercentFormatter.formatOptional(null), '—');
    expect(_plain(PercentFormatter.formatOptional(20)), '20,0 %');
  });
}
