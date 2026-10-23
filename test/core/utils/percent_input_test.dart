import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/utils/percent_input.dart';

void main() {
  test('reads whole and decimal percentages as basis points', () {
    expect(PercentInput.tryParseBasisPoints('11'), 1100);
    expect(PercentInput.tryParseBasisPoints(' 11,5 '), 1150);
    expect(PercentInput.tryParseBasisPoints('11.25'), 1125);
    expect(PercentInput.tryParseBasisPoints('0,05'), 5);
    expect(PercentInput.tryParseBasisPoints('100'), 10000);
  });

  test('rejects anything that is not a percentage with two decimals', () {
    for (final text in ['', 'abc', '11,555', '-5', '1000', '1.000', '11,']) {
      expect(PercentInput.tryParseBasisPoints(text), isNull, reason: text);
    }
  });

  test('converts between basis points and fractions of one', () {
    expect(PercentInput.fractionOf(1150), 0.115);
    expect(PercentInput.fractionOf(1100), 0.11);
    expect(PercentInput.basisPointsOf(0.1125), 1125);
    expect(PercentInput.basisPointsOf(0.11), 1100);
  });

  test('formats basis points for an input without trailing zeros', () {
    expect(PercentInput.format(1100), '11');
    expect(PercentInput.format(1150), '11,5');
    expect(PercentInput.format(1125), '11,25');
    expect(PercentInput.format(5), '0,05');
  });
}
