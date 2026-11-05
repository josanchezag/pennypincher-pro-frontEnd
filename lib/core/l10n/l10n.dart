import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

export 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Languages of the interface. Spanish is the default until the user picks
/// another one in the settings screen.
abstract final class AppLocales {
  static const Locale spanish = Locale('es');
  static const Locale english = Locale('en');
  static const Locale fallback = spanish;

  static const List<Locale> supported = [spanish, english];

  /// The supported locale with [languageCode], or `null` if there is none.
  static Locale? forLanguageCode(String? languageCode) {
    for (final locale in supported) {
      if (locale.languageCode == languageCode) {
        return locale;
      }
    }
    return null;
  }
}

/// A text that depends on the interface language, for configuration built
/// before any [BuildContext] exists: `(l10n) => l10n.routeGoals`.
typedef LocalizedText = String Function(AppLocalizations l10n);

extension AppLocalizationsContext on BuildContext {
  /// Texts of the interface in the current language.
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// Texts in the language the interface currently uses, for code that has
/// no [BuildContext], such as blocs and data sources building messages.
/// `LocaleCubit` keeps [Intl.defaultLocale] in sync with the interface.
abstract final class CurrentL10n {
  static AppLocalizations get texts {
    final current = Intl.defaultLocale;
    final locale = AppLocales.forLanguageCode(
          current == null ? null : Intl.shortLocale(current),
        ) ??
        AppLocales.fallback;
    return lookupAppLocalizations(locale);
  }
}
