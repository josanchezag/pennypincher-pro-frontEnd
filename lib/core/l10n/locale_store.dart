import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/storage/browser_storage.dart';

/// Remembers the interface language chosen by the user.
abstract interface class LocaleStore {
  /// The stored language code, or `null` when the user never chose one.
  String? read();

  void write(String languageCode);
}

/// Keeps the language code (`es` or `en`) in the browser's local storage.
@LazySingleton(as: LocaleStore)
class BrowserLocaleStore implements LocaleStore {
  static const String key = 'pennypincher.locale';

  @override
  String? read() => readStoredValue(key);

  @override
  void write(String languageCode) => writeStoredValue(key, languageCode);
}
