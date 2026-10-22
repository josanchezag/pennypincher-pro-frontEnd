import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/auth/token_service.dart';

void main() {
  test('keeps the access token in memory until cleared', () {
    final tokens = TokenService();
    expect(tokens.hasToken, isFalse);

    tokens.save('access-1');
    expect(tokens.accessToken, 'access-1');
    expect(tokens.hasToken, isTrue);

    tokens.clear();
    expect(tokens.accessToken, isNull);
  });
}
