import 'package:equatable/equatable.dart';

/// Settings of the signed-in user that the backend keeps for them.
/// [updatedAt] is `null` while the user never saved any: the values are
/// then the backend defaults.
class UserPreferences extends Equatable {
  const UserPreferences({required this.languageCode, this.updatedAt});

  /// ISO 639-1 code of the interface language, such as `es`.
  final String languageCode;
  final DateTime? updatedAt;

  /// Whether the backend has these settings stored, rather than defaults.
  bool get isSaved => updatedAt != null;

  @override
  List<Object?> get props => [languageCode, updatedAt];
}
