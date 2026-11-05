import 'package:pennypincher_pro/core/network/api_envelope.dart';
import 'package:pennypincher_pro/core/utils/app_currency.dart';
import 'package:pennypincher_pro/features/settings/domain/entity/user_preferences_entity.dart';

/// Keys of the preferences JSON.
abstract final class PreferencesJsonKeys {
  static const String language = 'language';
  static const String currency = 'currency';
  static const String updatedAt = 'updatedAt';
}

/// JSON shape of the preferences: `{language, currency, updatedAt}`, where
/// `updatedAt` is missing while only the defaults apply. A missing or
/// unknown `currency`, as from a backend older than the setting, reads as
/// Colombian pesos. Only the settings being changed are sent back, never
/// `updatedAt`.
abstract final class PreferencesJson {
  static UserPreferences fromJson(JsonMap json) {
    final updatedAt = json[PreferencesJsonKeys.updatedAt] as String?;
    return UserPreferences(
      languageCode: json[PreferencesJsonKeys.language] as String,
      currency: AppCurrency.forCode(
            json[PreferencesJsonKeys.currency] as String?,
          ) ??
          AppCurrency.fallback,
      updatedAt: updatedAt == null ? null : DateTime.parse(updatedAt),
    );
  }

  static JsonMap toJson(PreferencesChange change) {
    final language = change.languageCode;
    final currency = change.currency;
    return {
      if (language != null) PreferencesJsonKeys.language: language,
      if (currency != null) PreferencesJsonKeys.currency: currency.code,
    };
  }
}
