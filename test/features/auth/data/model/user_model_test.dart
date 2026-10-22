import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/features/auth/data/model/user_model.dart';

import '../../../../helpers/fake_http_adapter.dart';
import '../../../../helpers/mocks.dart';

void main() {
  test('maps the backend user JSON to the domain entity', () {
    expect(UserModel.fromJson(userJson).toEntity(), testUser);
  });

  test('accepts a user without picture', () {
    final json = Map<String, Object?>.from(userJson)..remove('pictureUrl');

    expect(UserModel.fromJson(json).toEntity().pictureUrl, isNull);
  });
}
