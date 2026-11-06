/// Currencies a user can keep their amounts in. Amounts are never
/// converted: the currency only says how they are labelled and formatted.
enum AppCurrency {
  cop('COP', decimalDigits: 0),
  usd('USD', decimalDigits: 2),
  eur('EUR', decimalDigits: 2);

  const AppCurrency(this.code, {required this.decimalDigits});

  /// ISO 4217 code, as the API sends it.
  final String code;

  /// Decimals shown for an amount: Colombian pesos are written without
  /// cents, dollars and euros with them.
  final int decimalDigits;

  /// Whether the budget's TRM, Colombian pesos per US dollar, concerns
  /// amounts in this currency. It is only a reference that no figure
  /// uses, so for euros it is hidden (and kept as stored).
  bool get hasExchangeRate => this != eur;

  /// Currency of a user who never chose one: every amount entered before
  /// the setting existed is in Colombian pesos.
  static const AppCurrency fallback = cop;

  /// The currency with exactly [code], or `null` if there is none.
  static AppCurrency? forCode(String? code) {
    for (final currency in values) {
      if (currency.code == code) {
        return currency;
      }
    }
    return null;
  }
}
