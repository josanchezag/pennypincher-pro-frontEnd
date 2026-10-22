import 'package:json_annotation/json_annotation.dart';
import 'package:pennypincher_pro/features/auth/data/model/user_model.dart';

part 'auth_session_model.g.dart';

/// Body of the sign-in and refresh responses. The refresh token travels
/// only in the httpOnly cookie and never appears here.
@JsonSerializable(createToJson: false)
class AuthSessionModel {
  const AuthSessionModel({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.user,
  });

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) =>
      _$AuthSessionModelFromJson(json);

  final String accessToken;
  final String tokenType;
  final int expiresIn;
  final UserModel user;
}
