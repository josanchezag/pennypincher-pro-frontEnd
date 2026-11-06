import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/storage/browser_storage.dart';

/// Remembers on this device the currency of the last account that signed
/// in, so amounts are shown in it right after a reload, before the account
/// settings arrive, and when they cannot be loaded.
abstract interface class CurrencyStore {
  /// The stored ISO 4217 code, or `null` when none was stored.
  String? read();

  void write(String currencyCode);
}

/// Keeps the currency code (`COP`, `USD` or `EUR`) in the browser's local
/// storage.
@LazySingleton(as: CurrencyStore)
class BrowserCurrencyStore implements CurrencyStore {
  static const String key = 'pennypincher.currency';

  @override
  String? read() => readStoredValue(key);

  @override
  void write(String currencyCode) => writeStoredValue(key, currencyCode);
}
