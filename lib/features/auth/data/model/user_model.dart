import 'package:json_annotation/json_annotation.dart';
import 'package:pennypincher_pro/features/auth/domain/entity/user_entity.dart';

part 'user_model.g.dart';

/// JSON shape of a user returned by the backend.
@JsonSerializable(createToJson: false)
class UserModel {
  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.createdAt,
    this.pictureUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  final String id;
  final String email;
  final String name;
  final String? pictureUrl;
  final DateTime createdAt;

  User toEntity() => User(
        id: id,
        email: email,
        name: name,
        pictureUrl: pictureUrl,
        createdAt: createdAt,
      );
}
