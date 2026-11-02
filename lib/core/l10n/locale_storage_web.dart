import 'package:web/web.dart';

/// Browser storage key of the interface language. Only the language code
/// (`es` or `en`) is stored, never anything about the user.
const String _key = 'pennypincher.locale';

/// The stored language code, or `null` when none was stored or the browser
/// blocks its storage (private windows, disabled site data).
String? readStoredLanguageCode() {
  try {
    return window.localStorage.getItem(_key);
  } catch (_) {
    return null;
  }
}

/// Stores [languageCode]; the choice is simply not remembered when the
/// browser blocks its storage.
void writeStoredLanguageCode(String languageCode) {
  try {
    window.localStorage.setItem(_key, languageCode);
  } catch (_) {
    // Storage unavailable: the language still applies to this visit.
  }
}
