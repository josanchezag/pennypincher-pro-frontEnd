import 'package:json_annotation/json_annotation.dart';

part 'google_authorization.g.dart';

/// Authorization code obtained from Google with the PKCE verifier and the
/// redirect URI it was issued for: the body of `POST /auth/google/callback`.
@JsonSerializable(createFactory: false)
class GoogleAuthorization {
  const GoogleAuthorization({
    required this.code,
    required this.redirectUri,
    required this.codeVerifier,
  });

  final String code;
  final String redirectUri;
  final String codeVerifier;

  Map<String, dynamic> toJson() => _$GoogleAuthorizationToJson(this);
}
