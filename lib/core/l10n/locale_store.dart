import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/l10n/locale_storage.dart';

/// Remembers the interface language chosen by the user.
abstract interface class LocaleStore {
  /// The stored language code, or `null` when the user never chose one.
  String? read();

  void write(String languageCode);
}

/// Keeps the language code in the browser's local storage.
@LazySingleton(as: LocaleStore)
class BrowserLocaleStore implements LocaleStore {
  @override
  String? read() => readStoredLanguageCode();

  @override
  void write(String languageCode) => writeStoredLanguageCode(languageCode);
}
