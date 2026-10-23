import 'package:equatable/equatable.dart';

/// An exact amount of Colombian pesos, held as a whole number of cents so
/// sums and differences never suffer floating point rounding.
///
/// The backend sends amounts as JSON numbers with up to two decimals
/// (`NUMERIC(18,2)`); [Money.fromJson] also accepts them as strings.
final class Money extends Equatable implements Comparable<Money> {
  const Money.fromCents(this.cents);

  /// Whole pesos without cents.
  const Money.fromPesos(int pesos) : cents = pesos * centsPerPeso;

  /// Parses a JSON number or numeric string. Throws [FormatException] for
  /// anything else.
  factory Money.fromJson(Object? json) => switch (json) {
        final int pesos => Money.fromPesos(pesos),
        final double pesos => Money._fromDouble(pesos),
        final String text => _parseText(text),
        _ => throw FormatException(invalidAmountMessage, json),
      };

  /// Like [Money.fromJson], or `null` for a JSON `null`.
  static Money? fromOptionalJson(Object? json) =>
      json == null ? null : Money.fromJson(json);

  factory Money._fromDouble(double pesos) {
    if (!pesos.isFinite) {
      throw FormatException(invalidAmountMessage, pesos);
    }
    return Money.fromCents((pesos * centsPerPeso).round());
  }

  static const int centsPerPeso = 100;
  static const int _decimalDigits = 2;
  static const String invalidAmountMessage = 'Invalid money amount';
  static const Money zero = Money.fromCents(0);

  /// Largest amount the app accepts: 15 digits of cents (just under ten
  /// trillion pesos). Every such amount is exact as an integer on the web
  /// and as a JSON decimal number.
  static const int maxCents = 999999999999999;
  static const int _maxDigits = 15;

  static const String _groupSeparator = '.';
  static const String _decimalComma = ',';
  static const String _decimalPoint = '.';

  /// API text: `1500000` or `1500000.5`.
  static final RegExp _plain = RegExp(r'^(-?)(\d+)(?:\.(\d{1,2}))?$');

  /// Colombian input: optional dot thousands in groups of three and a comma
  /// before up to two decimals, such as `1.500.000,50` or `1500000,5`.
  static final RegExp _colombian =
      RegExp(r'^(\d{1,3}(?:\.\d{3})+|\d+)(?:,(\d{1,2}))?$');

  /// A dot followed by one or two digits can only be a decimal point.
  static final RegExp _dotDecimal = RegExp(r'^(\d+)\.(\d{1,2})$');

  final int cents;

  /// Parses an amount typed by the user. Dots group thousands and a comma
  /// starts the decimals (`1.500.000,50`); a dot followed by one or two
  /// digits is read as a decimal point (`1500000.5`). Returns `null` for
  /// anything else, negative amounts or more than [maxCents].
  static Money? tryParseInput(String text) {
    final trimmed = text.trim();
    final colombian = _colombian.firstMatch(trimmed);
    if (colombian != null) {
      return _fromParts(
        colombian.group(1)!.replaceAll(_groupSeparator, ''),
        colombian.group(2),
      );
    }
    final dotted = _dotDecimal.firstMatch(trimmed);
    return dotted == null
        ? null
        : _fromParts(dotted.group(1)!, dotted.group(2));
  }

  static Money _parseText(String text) {
    final plain = _plain.firstMatch(text.trim());
    final parsed = plain == null
        ? null
        : _fromParts(plain.group(2)!, plain.group(3), negative: plain[1] != '');
    if (parsed != null) {
      return parsed;
    }
    final number = num.tryParse(text.trim());
    if (number == null) {
      throw FormatException(invalidAmountMessage, text);
    }
    return Money.fromJson(number);
  }

  /// Exact amount from its digits, or `null` beyond [maxCents].
  static Money? _fromParts(
    String pesos,
    String? decimals, {
    bool negative = false,
  }) {
    final digits = '$pesos${(decimals ?? '').padRight(_decimalDigits, '0')}';
    final cents = digits.length > _maxDigits ? null : int.tryParse(digits);
    if (cents == null || cents > maxCents) {
      return null;
    }
    return Money.fromCents(negative ? -cents : cents);
  }

  bool get isNegative => cents < 0;

  bool get isZero => cents == 0;

  /// Amount in pesos as a floating point number, for charts only.
  double get pesos => cents / centsPerPeso;

  Money operator +(Money other) => Money.fromCents(cents + other.cents);

  Money operator -(Money other) => Money.fromCents(cents - other.cents);

  Money abs() => Money.fromCents(cents.abs());

  /// JSON number for the API: an integer when there are no cents, otherwise
  /// a decimal parsed from the exact digits.
  num toJson() => cents % centsPerPeso == 0
      ? cents ~/ centsPerPeso
      : double.parse(_decimalText(_decimalPoint));

  /// Text to prefill an input, in the format [tryParseInput] reads:
  /// `1500000` or `1500000,5`.
  String toInputString() => cents % centsPerPeso == 0
      ? '${cents ~/ centsPerPeso}'
      : _decimalText(_decimalComma);

  String _decimalText(String separator) {
    final whole = cents.abs() ~/ centsPerPeso;
    final fraction =
        (cents.abs() % centsPerPeso).toString().padLeft(_decimalDigits, '0');
    final sign = isNegative ? '-' : '';
    return '$sign$whole$separator$fraction';
  }

  @override
  int compareTo(Money other) => cents.compareTo(other.cents);

  @override
  List<Object?> get props => [cents];

  @override
  String toString() => 'Money($cents)';
}

/// Sums the amounts of [items] read with [amountOf].
Money sumMoney<T>(Iterable<T> items, Money Function(T item) amountOf) =>
    items.fold(Money.zero, (total, item) => total + amountOf(item));
