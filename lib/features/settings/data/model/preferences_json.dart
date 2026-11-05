import 'package:pennypincher_pro/core/network/api_envelope.dart';
import 'package:pennypincher_pro/features/settings/domain/entity/user_preferences_entity.dart';

/// Keys of the preferences JSON.
abstract final class PreferencesJsonKeys {
  static const String language = 'language';
  static const String updatedAt = 'updatedAt';
}

/// JSON shape of the preferences: `{language, updatedAt}`, where
/// `updatedAt` is missing while only the defaults apply. Only the settings
/// are sent back, never `updatedAt`.
abstract final class PreferencesJson {
  static UserPreferences fromJson(JsonMap json) {
    final updatedAt = json[PreferencesJsonKeys.updatedAt] as String?;
    return UserPreferences(
      languageCode: json[PreferencesJsonKeys.language] as String,
      updatedAt: updatedAt == null ? null : DateTime.parse(updatedAt),
    );
  }

  static JsonMap toJson(UserPreferences preferences) => {
        PreferencesJsonKeys.language: preferences.languageCode,
      };
}
