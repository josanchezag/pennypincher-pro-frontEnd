import 'package:web/web.dart';

/// The value stored under [key] in the browser's local storage, or `null`
/// when there is none or the browser blocks its storage (private windows,
/// disabled site data). Only interface settings are stored, never anything
/// about the user.
String? readStoredValue(String key) {
  try {
    return window.localStorage.getItem(key);
  } catch (_) {
    return null;
  }
}

/// Stores [value] under [key]; it is simply not remembered when the browser
/// blocks its storage.
void writeStoredValue(String key, String value) {
  try {
    window.localStorage.setItem(key, value);
  } catch (_) {
    // Storage unavailable: the setting still applies to this visit.
  }
}
