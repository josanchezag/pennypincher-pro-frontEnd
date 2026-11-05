import 'package:equatable/equatable.dart';
import 'package:pennypincher_pro/core/utils/money.dart';

/// What a character of an amount field stands for.
enum MoneyCharKind {
  digit,

  /// Thousands separator, inserted by the field itself.
  group,

  /// The language's decimal separator: the decimals start after it.
  decimal,

  /// The language's thousands separator typed at the end of the amount,
  /// with at most two digits after it so far. It is read as the start of
  /// the decimals: `1,5` in English is 1.50, because no currency has three
  /// decimals. A third digit turns it into grouping (`1,500`).
  pendingDecimal,

  /// Anything else, such as a currency symbol: ignored.
  other,
}

/// How an amount field writes amounts as the user types them: the digit
/// separators of the interface language, at most [maxDecimals] decimals
/// and the currency symbol shown before ([prefix]) or after ([suffix]) the
/// number. The text never holds the symbol, only digits and separators:
///
/// | | es | en |
/// |---|---|---|
/// | COP | `$ 1.234.568` | `COP 1,234,568` |
/// | USD | `US$ 1.234.567,50` | `$1,234,567.50` |
/// | EUR | `1.234.567,50 €` | `€1,234,567.50` |
///
/// [format] and [parse] are exact: amounts are built from their digits,
/// never through floating point.
final class MoneyInputFormat extends Equatable {
  const MoneyInputFormat({
    required this.groupSeparator,
    required this.decimalSeparator,
    required this.maxDecimals,
    this.prefix = '',
    this.suffix = '',
  });

  /// Whole digits an amount may have: [Money.maxCents] holds 15 digits of
  /// cents, so 13 of units.
  static const int maxIntegerDigits = 13;

  /// Decimals of an amount with cents.
  static const int centsDigits = 2;

  static const int _groupSize = 3;
  static final RegExp _digit = RegExp(r'\d');

  final String groupSeparator;
  final String decimalSeparator;

  /// 0 for Colombian pesos, 2 for dollars, euros and the TRM.
  final int maxDecimals;

  /// Text shown before the number, such as `$ ` or `€`; empty when the
  /// symbol goes after it.
  final String prefix;

  /// Text shown after the number, such as ` €`; usually empty.
  final String suffix;

  bool get allowsDecimals => maxDecimals > 0;

  /// The same format allowing [decimals] decimals.
  MoneyInputFormat withMaxDecimals(int decimals) => MoneyInputFormat(
        groupSeparator: groupSeparator,
        decimalSeparator: decimalSeparator,
        maxDecimals: decimals,
        prefix: prefix,
        suffix: suffix,
      );

  /// The same format, with room for the cents of [amount] when it has some
  /// and the currency writes none: a peso amount with cents saved before
  /// is kept exact instead of being rounded when edited.
  MoneyInputFormat keepingCentsOf(Money? amount) =>
      amount != null && _hasCents(amount) && maxDecimals < centsDigits
          ? withMaxDecimals(centsDigits)
          : this;

  /// Text of [amount] as the field shows it: grouped units, and the two
  /// decimals only when there are cents (`1.500.000`, `1.500.000,50`).
  /// Empty for `null`.
  String format(Money? amount) {
    if (amount == null) {
      return '';
    }
    final cents = amount.cents.abs();
    final whole = group('${cents ~/ Money.centsPerUnit}');
    if (!_hasCents(amount)) {
      return whole;
    }
    final fraction = '${cents % Money.centsPerUnit}'.padLeft(centsDigits, '0');
    return '$whole$decimalSeparator$fraction';
  }

  /// The amount written in [text], as the field writes it, or `null` when
  /// it holds no digits, too many decimals or more than [Money.maxCents].
  /// Characters other than digits and separators are ignored.
  Money? parse(String text) {
    final whole = StringBuffer();
    final decimals = StringBuffer();
    var inDecimals = false;
    final kinds = classify(text);
    for (var i = 0; i < text.length; i++) {
      switch (kinds[i]) {
        case MoneyCharKind.digit:
          (inDecimals ? decimals : whole).write(text[i]);
        case MoneyCharKind.decimal || MoneyCharKind.pendingDecimal:
          inDecimals = true;
        case MoneyCharKind.group || MoneyCharKind.other:
          break;
      }
    }
    if (decimals.length > maxDecimals) {
      return null;
    }
    return Money.tryFromDigits('$whole', '$decimals');
  }

  /// What each character of [text] stands for, [text] being written as
  /// this format writes it (see [MoneyCharKind.pendingDecimal]).
  List<MoneyCharKind> classify(String text) {
    final kinds = [
      for (var i = 0; i < text.length; i++) _kindOf(text[i]),
    ];
    var decimalSeen = false;
    for (var i = 0; i < kinds.length; i++) {
      if (kinds[i] == MoneyCharKind.decimal) {
        if (decimalSeen) {
          kinds[i] = MoneyCharKind.other;
        }
        decimalSeen = true;
      }
    }
    if (decimalSeen || !allowsDecimals) {
      return kinds;
    }
    final last = kinds.lastIndexOf(MoneyCharKind.group);
    if (last < 0) {
      return kinds;
    }
    final after = kinds.sublist(last + 1);
    final pending = after.length <= centsDigits &&
        after.every((kind) => kind == MoneyCharKind.digit) &&
        kinds.sublist(0, last).contains(MoneyCharKind.digit);
    if (pending) {
      kinds[last] = MoneyCharKind.pendingDecimal;
    }
    return kinds;
  }

  /// [digits] with a [groupSeparator] every three digits from the right.
  String group(String digits) {
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % _groupSize == 0) {
        buffer.write(groupSeparator);
      }
      buffer.write(digits[i]);
    }
    return '$buffer';
  }

  MoneyCharKind _kindOf(String char) {
    if (_digit.hasMatch(char)) {
      return MoneyCharKind.digit;
    }
    if (char == decimalSeparator) {
      return MoneyCharKind.decimal;
    }
    return char == groupSeparator ? MoneyCharKind.group : MoneyCharKind.other;
  }

  static bool _hasCents(Money amount) => amount.cents % Money.centsPerUnit != 0;

  @override
  List<Object?> get props =>
      [groupSeparator, decimalSeparator, maxDecimals, prefix, suffix];
}
