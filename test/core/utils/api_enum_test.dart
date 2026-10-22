import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/utils/api_enum.dart';

enum _Kind { realEstate, cash, other }

void main() {
  test('writes enum values in screaming snake case', () {
    expect(ApiEnum.nameOf(_Kind.realEstate), 'REAL_ESTATE');
    expect(ApiEnum.nameOf(_Kind.cash), 'CASH');
  });

  test('reads known names and falls back for unknown ones', () {
    expect(
      ApiEnum.parse(_Kind.values, 'REAL_ESTATE', fallback: _Kind.other),
      _Kind.realEstate,
    );
    expect(
      ApiEnum.parse(_Kind.values, 'CRYPTO', fallback: _Kind.other),
      _Kind.other,
    );
  });

  test('rejects values that are not strings', () {
    expect(
      () => ApiEnum.parse(_Kind.values, 3, fallback: _Kind.other),
      throwsFormatException,
    );
  });
}
