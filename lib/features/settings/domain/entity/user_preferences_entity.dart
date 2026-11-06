import 'package:equatable/equatable.dart';
import 'package:pennypincher_pro/core/utils/app_currency.dart';

/// Settings of the signed-in user that the backend keeps for them.
/// [updatedAt] is `null` while the user never saved any: the values are
/// then the backend defaults.
class UserPreferences extends Equatable {
  const UserPreferences({
    required this.languageCode,
    this.currency = AppCurrency.fallback,
    this.updatedAt,
  });

  /// ISO 639-1 code of the interface language, such as `es`.
  final String languageCode;

  /// Currency the user's amounts are in.
  final AppCurrency currency;
  final DateTime? updatedAt;

  /// Whether the backend has these settings stored, rather than defaults.
  bool get isSaved => updatedAt != null;

  @override
  List<Object?> get props => [languageCode, currency, updatedAt];
}

/// Settings to save; a `null` one keeps the value stored in the account.
/// Each change sends only the setting it changes, so a setting that could
/// not be loaded is never overwritten with this device's value.
class PreferencesChange extends Equatable {
  const PreferencesChange({this.languageCode, this.currency})
      : assert(
          languageCode != null || currency != null,
          'A change needs at least one setting',
        );

  const PreferencesChange.language(String this.languageCode) : currency = null;

  const PreferencesChange.currency(AppCurrency this.currency)
      : languageCode = null;

  final String? languageCode;
  final AppCurrency? currency;

  @override
  List<Object?> get props => [languageCode, currency];
}
