import 'package:flutter/services.dart';
import 'package:pennypincher_pro/core/utils/money_input_format.dart';

/// Writes an amount in [format] as the user types it: thousands separators
/// appear by themselves, the decimals stop at [MoneyInputFormat.maxDecimals]
/// and the caret stays next to the digit it was next to.
///
/// - Digits are inserted where the caret is: typing `1234567` in Spanish
///   shows `1.234.567`.
/// - The language's decimal separator (`,` in Spanish, `.` in English)
///   starts the decimals; typed again, or once the decimals are full, it is
///   ignored, as is any other character. Every currency takes them,
///   pesos included, so no typed separator is ever silently dropped.
/// - The thousands separator (`.` in Spanish, `,` in English) is not
///   needed, but typed at the end of the amount it is kept as typed, so
///   habits and keypads of either convention work: followed by one or two
///   digits it is the decimal separator (`1500.5` in Spanish dollars is
///   1500.50), and a third digit turns it into grouping (`1,500` in English
///   is 1500). Typed anywhere else it is ignored.
/// - Deleting a thousands separator deletes the digit next to it, since
///   the separator would come back anyway: backspace after the dot of
///   `1.234` leaves `234`.
/// - Pasted text keeps only its digits and separators and reads them in
///   either convention: a separator followed by exactly three digits groups
///   thousands, otherwise the last separator starts the decimals. So
///   `1.500.000,50`, `$ 1,500,000.50` and `1500000.5` all paste as one and
///   a half million; extra decimals are dropped.
/// - Leading zeros are dropped (`007` is `7`) and a lone decimal separator
///   becomes `0,`.
/// - An edit that would leave more than [MoneyInputFormat.maxIntegerDigits]
///   whole digits is ignored.
class MoneyInputFormatter extends TextInputFormatter {
  MoneyInputFormatter(this.format);

  final MoneyInputFormat format;

  static final RegExp _digit = RegExp(r'\d');
  static const String _point = '.';
  static const String _comma = ',';
  static const int _groupSize = 3;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text == oldValue.text) {
      return newValue;
    }
    final edit = _Edit.between(oldValue, newValue);
    final result = edit == null
        ? _normalize(_pasted(newValue.text), typed: false)
        : _apply(oldValue, edit);
    return result ?? oldValue;
  }

  TextEditingValue? _apply(TextEditingValue oldValue, _Edit edit) {
    final old = oldValue.text;
    final kinds = format.classify(old);
    final before = _tokensOf(old, kinds, 0, edit.start);
    final after = _tokensOf(old, kinds, edit.end, old.length);
    final inserted = edit.inserted;
    if (inserted.isEmpty) {
      _deleteNextToSeparator(oldValue, edit, kinds, before, after);
      return _normalize(_Tokens([...before, ...after], before.length));
    }
    if (inserted.length > 1) {
      final pasted = _pasted(inserted).tokens;
      if (pasted.isEmpty) {
        return null;
      }
      return _normalize(
        _Tokens(
          [...before, ...pasted, ...after],
          before.length + pasted.length,
        ),
        typed: false,
      );
    }
    final token = _typed(inserted, before, after);
    if (token == null) {
      return null;
    }
    if (token.kind == MoneyCharKind.decimal) {
      before.removeWhere(_isPending);
      after.removeWhere(_isPending);
    }
    return _normalize(
      _Tokens([...before, token, ...after], before.length + 1),
    );
  }

  /// The token a typed [char] adds between [before] and [after], or `null`
  /// when the keystroke is ignored.
  _Token? _typed(String char, List<_Token> before, List<_Token> after) {
    if (_digit.hasMatch(char)) {
      return _Token.digit(char);
    }
    final isDecimal = char == format.decimalSeparator;
    if (!format.allowsDecimals ||
        !(isDecimal || char == format.groupSeparator)) {
      return null;
    }
    final all = [...before, ...after];
    if (all.any((token) => token.kind == MoneyCharKind.decimal)) {
      return null;
    }
    if (isDecimal || !before.any(_isDigit)) {
      return const _Token(MoneyCharKind.decimal);
    }
    final pending = after.isEmpty && !all.any(_isPending);
    return pending ? const _Token(MoneyCharKind.pendingDecimal) : null;
  }

  /// Deleting only thousands separators deletes the digit they followed
  /// (backspace) or preceded (delete) instead, since the field would put
  /// them back.
  void _deleteNextToSeparator(
    TextEditingValue oldValue,
    _Edit edit,
    List<MoneyCharKind> kinds,
    List<_Token> before,
    List<_Token> after,
  ) {
    final deleted = kinds.sublist(edit.start, edit.end);
    final selection = oldValue.selection;
    if (deleted.isEmpty ||
        !selection.isCollapsed ||
        deleted.any((kind) => kind != MoneyCharKind.group)) {
      return;
    }
    if (selection.baseOffset == edit.end && before.isNotEmpty) {
      before.removeLast();
    } else if (selection.baseOffset == edit.start && after.isNotEmpty) {
      after.removeAt(0);
    }
  }

  /// The amount, caret and all, as the field writes it, or `null` when the
  /// edit is not allowed. A [typed] edit that adds a decimal too many is
  /// refused; a pasted one loses the extra decimals.
  TextEditingValue? _normalize(_Tokens input, {bool typed = true}) {
    final tokens = input.tokens;
    var caret = input.caret;
    void removeAt(int index) {
      tokens.removeAt(index);
      if (index < caret) {
        caret--;
      }
    }

    final definite =
        tokens.where((token) => token.kind == MoneyCharKind.decimal).length;
    if (definite > 1) {
      return null;
    }
    final pending = tokens.indexWhere(_isPending);
    final grouping = definite == 1 ||
        tokens.length - pending - 1 > MoneyInputFormat.centsDigits;
    if (pending >= 0 && grouping) {
      removeAt(pending);
    }
    final marker = tokens.indexWhere(_isMarker);
    if (marker >= 0) {
      final decimals = tokens.length - marker - 1;
      final allowed = format.maxDecimals;
      if (decimals > allowed || !format.allowsDecimals) {
        if (typed) {
          return null;
        }
        final keep = format.allowsDecimals ? marker + 1 + allowed : marker;
        while (tokens.length > keep) {
          removeAt(tokens.length - 1);
        }
      }
    }
    _dropLeadingZeros(tokens, removeAt);
    var integerEnd = tokens.indexWhere(_isMarker);
    if (integerEnd == 0) {
      tokens.insert(0, const _Token.digit('0'));
      if (caret > 0) {
        caret++;
      }
      integerEnd = 1;
    }
    final integerDigits = integerEnd < 0 ? tokens.length : integerEnd;
    if (integerDigits > MoneyInputFormat.maxIntegerDigits) {
      return null;
    }
    return _render(tokens, caret.clamp(0, tokens.length), integerDigits);
  }

  static void _dropLeadingZeros(
    List<_Token> tokens,
    void Function(int index) removeAt,
  ) {
    bool integerHasMore() {
      final end = tokens.indexWhere(_isMarker);
      return (end < 0 ? tokens.length : end) > 1;
    }

    while (tokens.isNotEmpty && tokens.first.char == '0' && integerHasMore()) {
      removeAt(0);
    }
  }

  TextEditingValue _render(List<_Token> tokens, int caret, int integerDigits) {
    final text = StringBuffer();
    var offset = 0;
    for (final (index, token) in tokens.indexed) {
      final digitsLeft = integerDigits - index;
      if (index > 0 && index < integerDigits && digitsLeft % _groupSize == 0) {
        text.write(format.groupSeparator);
      }
      final char = switch (token.kind) {
        MoneyCharKind.decimal => format.decimalSeparator,
        MoneyCharKind.pendingDecimal => format.groupSeparator,
        _ => token.char,
      };
      text.write(char);
      if (index == caret - 1) {
        offset = text.length;
      }
    }
    return TextEditingValue(
      text: '$text',
      selection: TextSelection.collapsed(offset: offset),
    );
  }

  /// Digits and the decimal separator of [text], typed in either
  /// convention, with the caret at the end.
  static _Tokens _pasted(String text) {
    final kept = text.split('').where(
          (char) => _digit.hasMatch(char) || char == _point || char == _comma,
        );
    final chars = kept.toList();
    final separators = [
      for (final (index, char) in chars.indexed)
        if (!_digit.hasMatch(char)) index,
    ];
    final decimalAt = _pastedDecimalAt(chars, separators);
    final tokens = [
      for (final (index, char) in chars.indexed)
        if (index == decimalAt)
          const _Token(MoneyCharKind.decimal)
        else if (_digit.hasMatch(char))
          _Token.digit(char),
    ];
    return _Tokens(tokens, tokens.length);
  }

  /// Which of the [separators] of [chars] starts the decimals, if any.
  static int? _pastedDecimalAt(List<String> chars, List<int> separators) {
    if (separators.isEmpty) {
      return null;
    }
    final last = separators.last;
    final mixed = separators.any((index) => chars[index] != chars[last]);
    if (mixed) {
      return last;
    }
    if (separators.length > 1) {
      return null;
    }
    final digitsAfter = chars.length - last - 1;
    final wholeBefore = chars.sublist(0, last).any((char) => char != '0');
    return digitsAfter == 3 && wholeBefore ? null : last;
  }

  static List<_Token> _tokensOf(
    String text,
    List<MoneyCharKind> kinds,
    int start,
    int end,
  ) =>
      [
        for (var i = start; i < end; i++)
          switch (kinds[i]) {
            MoneyCharKind.digit => _Token.digit(text[i]),
            MoneyCharKind.decimal => const _Token(MoneyCharKind.decimal),
            MoneyCharKind.pendingDecimal =>
              const _Token(MoneyCharKind.pendingDecimal),
            MoneyCharKind.group || MoneyCharKind.other => null,
          },
      ].nonNulls.toList();

  static bool _isDigit(_Token token) => token.kind == MoneyCharKind.digit;

  static bool _isPending(_Token token) =>
      token.kind == MoneyCharKind.pendingDecimal;

  static bool _isMarker(_Token token) => !_isDigit(token);
}

/// A digit or decimal separator of the amount being typed.
final class _Token {
  const _Token(this.kind) : char = '';

  const _Token.digit(this.char) : kind = MoneyCharKind.digit;

  final MoneyCharKind kind;
  final String char;
}

/// The amount being typed with the caret after its first [caret] tokens.
final class _Tokens {
  _Tokens(this.tokens, this.caret);

  final List<_Token> tokens;
  final int caret;
}

/// One edit of the text: what replaced the characters from [start] to
/// [end] of the old text.
final class _Edit {
  const _Edit(this.start, this.end, this.inserted);

  final int start;
  final int end;
  final String inserted;

  /// The edit from [oldValue] to [newValue]: the old selection replaced by
  /// new text when that explains the change (typing, pasting, select all),
  /// otherwise a single-character insertion or a deletion found by
  /// comparing the texts. `null` when the change is none of these, as when
  /// the whole text is set at once; it is then read as pasted.
  static _Edit? between(TextEditingValue oldValue, TextEditingValue newValue) {
    final old = oldValue.text;
    final text = newValue.text;
    final selection = oldValue.selection;
    if (selection.isValid && selection.end <= old.length) {
      final head = old.substring(0, selection.start);
      final tail = old.substring(selection.end);
      if (text.length >= head.length + tail.length &&
          text.startsWith(head) &&
          text.endsWith(tail)) {
        return _Edit(
          selection.start,
          selection.end,
          text.substring(head.length, text.length - tail.length),
        );
      }
    }
    final shorter = old.length < text.length ? old.length : text.length;
    var start = 0;
    while (start < shorter && old[start] == text[start]) {
      start++;
    }
    var common = 0;
    while (common < shorter - start &&
        old[old.length - 1 - common] == text[text.length - 1 - common]) {
      common++;
    }
    final inserted = text.substring(start, text.length - common);
    return inserted.length > 1
        ? null
        : _Edit(start, old.length - common, inserted);
  }
}
