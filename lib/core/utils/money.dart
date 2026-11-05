import 'package:equatable/equatable.dart';

/// An exact amount in the user's currency (pesos, dollars or euros), held
/// as a whole number of cents so sums and differences never suffer floating
/// point rounding. The currency itself is not part of the amount: every
/// amount of a user is in the currency of their settings.
///
/// The backend sends amounts as JSON numbers with up to two decimals
/// (`NUMERIC(18,2)`); [Money.fromJson] also accepts them as strings.
final class Money extends Equatable implements Comparable<Money> {
  const Money.fromCents(this.cents);

  /// Whole units (pesos, dollars or euros) without cents.
  const Money.fromUnits(int units) : cents = units * centsPerUnit;

  /// Parses a JSON number or numeric string. Throws [FormatException] for
  /// anything else.
  factory Money.fromJson(Object? json) => switch (json) {
        final int units => Money.fromUnits(units),
        final double units => Money._fromDouble(units),
        final String text => _parseText(text),
        _ => throw FormatException(invalidAmountMessage, json),
      };

  /// Like [Money.fromJson], or `null` for a JSON `null`.
  static Money? fromOptionalJson(Object? json) =>
      json == null ? null : Money.fromJson(json);

  factory Money._fromDouble(double units) {
    if (!units.isFinite) {
      throw FormatException(invalidAmountMessage, units);
    }
    return Money.fromCents((units * centsPerUnit).round());
  }

  static const int centsPerUnit = 100;
  static const int _decimalDigits = 2;
  static const String invalidAmountMessage = 'Invalid money amount';
  static const Money zero = Money.fromCents(0);

  /// Largest amount the app accepts: 15 digits of cents (just under ten
  /// trillion units). Every such amount is exact as an integer on the web
  /// and as a JSON decimal number.
  static const int maxCents = 999999999999999;
  static const int _maxDigits = 15;

  static const String _decimalPoint = '.';

  /// API text: `1500000` or `1500000.5`.
  static final RegExp _plain = RegExp(r'^(-?)(\d+)(?:\.(\d{1,2}))?$');
  static final RegExp _digits = RegExp(r'^\d*$');

  final int cents;

  /// Exact amount from the digits of its [whole] units and up to two
  /// [decimals], as an amount field holds them: `('1500000', '5')` is
  /// 1500000.50. Returns `null` when either is not plain digits, there are
  /// more than two decimals, both are empty or the amount exceeds
  /// [maxCents].
  static Money? tryFromDigits(String whole, [String decimals = '']) {
    final valid = _digits.hasMatch(whole) &&
        _digits.hasMatch(decimals) &&
        decimals.length <= _decimalDigits &&
        (whole.isNotEmpty || decimals.isNotEmpty);
    if (!valid) {
      return null;
    }
    final units = whole.replaceFirst(RegExp('^0+(?=.)'), '');
    return _fromParts(units.isEmpty ? '0' : units, decimals);
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
    String units,
    String? decimals, {
    bool negative = false,
  }) {
    final digits = '$units${(decimals ?? '').padRight(_decimalDigits, '0')}';
    final cents = digits.length > _maxDigits ? null : int.tryParse(digits);
    if (cents == null || cents > maxCents) {
      return null;
    }
    return Money.fromCents(negative ? -cents : cents);
  }

  bool get isNegative => cents < 0;

  bool get isZero => cents == 0;

  /// Amount in whole units as a floating point number, for charts and
  /// display formatting only.
  double get units => cents / centsPerUnit;

  Money operator +(Money other) => Money.fromCents(cents + other.cents);

  Money operator -(Money other) => Money.fromCents(cents - other.cents);

  Money abs() => Money.fromCents(cents.abs());

  /// JSON number for the API: an integer when there are no cents, otherwise
  /// a decimal parsed from the exact digits.
  num toJson() => cents % centsPerUnit == 0
      ? cents ~/ centsPerUnit
      : double.parse(_decimalText(_decimalPoint));

  String _decimalText(String separator) {
    final whole = cents.abs() ~/ centsPerUnit;
    final fraction =
        (cents.abs() % centsPerUnit).toString().padLeft(_decimalDigits, '0');
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
