import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';

/// The signed-in person, as known by the backend.
@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    required String name,
    required DateTime createdAt,
    String? pictureUrl,
  }) = _User;
}
