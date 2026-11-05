import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/utils/app_currency.dart';
import 'package:pennypincher_pro/core/utils/money_formatter.dart';
import 'package:pennypincher_pro/core/utils/money_input_format.dart';
import 'package:pennypincher_pro/core/utils/money_input_formatter.dart';

/// The caret, written into texts as `|`; `[` and `]` mark a selection.
const String _caret = '|';

/// [text] with its caret or selection marked.
TextEditingValue _value(String text) {
  final start = text.indexOf('[');
  if (start >= 0) {
    final end = text.indexOf(']') - 1;
    return TextEditingValue(
      text: text.replaceAll('[', '').replaceAll(']', ''),
      selection: TextSelection(baseOffset: start, extentOffset: end),
    );
  }
  final caret = text.indexOf(_caret);
  return TextEditingValue(
    text: text.replaceAll(_caret, ''),
    selection: TextSelection.collapsed(
      offset: caret < 0 ? text.length : caret,
    ),
  );
}

String _marked(TextEditingValue value) {
  final offset = value.selection.extentOffset;
  return '${value.text.substring(0, offset)}$_caret'
      '${value.text.substring(offset)}';
}

/// A keystroke or clipboard action applied the way a text field does.
sealed class _Action {
  const _Action();

  TextEditingValue raw(TextEditingValue value);

  /// [text] in place of the selection, caret after it.
  static TextEditingValue replaceSelection(
    TextEditingValue value,
    String text,
  ) {
    final selection = value.selection;
    final result =
        value.text.replaceRange(selection.start, selection.end, text);
    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: selection.start + text.length),
    );
  }
}

final class _Type extends _Action {
  const _Type(this.text);

  final String text;

  @override
  TextEditingValue raw(TextEditingValue value) =>
      _Action.replaceSelection(value, text);

  @override
  String toString() => 'type "$text"';
}

final class _Paste extends _Type {
  const _Paste(super.text);

  @override
  String toString() => 'paste "$text"';
}

final class _Backspace extends _Action {
  const _Backspace();

  @override
  TextEditingValue raw(TextEditingValue value) {
    final selection = value.selection;
    if (!selection.isCollapsed) {
      return _Action.replaceSelection(value, '');
    }
    final at = selection.baseOffset;
    if (at == 0) {
      return value;
    }
    return TextEditingValue(
      text: value.text.replaceRange(at - 1, at, ''),
      selection: TextSelection.collapsed(offset: at - 1),
    );
  }

  @override
  String toString() => 'backspace';
}

final class _Delete extends _Action {
  const _Delete();

  @override
  TextEditingValue raw(TextEditingValue value) {
    final at = value.selection.baseOffset;
    if (!value.selection.isCollapsed) {
      return _Action.replaceSelection(value, '');
    }
    if (at == value.text.length) {
      return value;
    }
    return TextEditingValue(
      text: value.text.replaceRange(at, at + 1, ''),
      selection: TextSelection.collapsed(offset: at),
    );
  }

  @override
  String toString() => 'delete';
}

/// Moves the caret, or selects with `[` `]`, in the current text.
final class _Select extends _Action {
  const _Select(this.marked);

  final String marked;

  @override
  TextEditingValue raw(TextEditingValue value) {
    final target = _value(marked);
    expect(target.text, value.text, reason: 'select in "${value.text}"');
    return target;
  }

  @override
  String toString() => 'select "$marked"';
}

/// Every character typed one by one.
List<_Action> _keys(String text) =>
    [for (final char in text.split('')) _Type(char)];

TextEditingValue _run(
  MoneyInputFormatter formatter,
  String start,
  List<_Action> actions,
) {
  var value = _value(start);
  for (final action in actions) {
    final raw = action.raw(value);
    value = action is _Select ? raw : formatter.formatEditUpdate(value, raw);
  }
  return value;
}

typedef _Case = (String start, List<_Action> actions, String expected);

MoneyInputFormatter _formatterOf(AppCurrency currency, String language) =>
    MoneyInputFormatter(MoneyFormatter.of(currency, language).inputFormat);

void _check(MoneyInputFormatter formatter, List<_Case> cases) {
  for (final (start, actions, expected) in cases) {
    expect(
      _marked(_run(formatter, start, actions)),
      expected,
      reason: 'from "$start": ${actions.join(', ')}',
    );
  }
}

void main() {
  group('Colombian pesos in Spanish', () {
    final formatter = _formatterOf(AppCurrency.cop, 'es');

    test('groups thousands as digits are typed', () {
      _check(formatter, [
        ('', _keys('1'), '1|'),
        ('', _keys('1234'), '1.234|'),
        ('', _keys('1234567'), '1.234.567|'),
        ('', _keys('1500000'), '1.500.000|'),
        ('', _keys('0'), '0|'),
        ('', _keys('007'), '7|'),
      ]);
    });

    test('takes typed cents instead of dropping the separator', () {
      _check(formatter, [
        ('', _keys('8500000,5'), '8.500.000,5|'),
        ('', _keys('8500000,50'), '8.500.000,50|'),
        ('', _keys('8500000,505'), '8.500.000,50|'),
        ('', _keys('8500000.5'), '8.500.000.5|'),
        ('', _keys('1.500.000'), '1.500.000|'),
        ('1.234|', _keys(','), '1.234,|'),
        ('', _keys(','), '0,|'),
      ]);
    });

    test('ignores other characters', () {
      _check(formatter, [
        ('', _keys('12a-b 3'), '123|'),
        ('1.234|', _keys('x'), '1.234|'),
      ]);
    });

    test('keeps the caret next to the digit typed in the middle', () {
      _check(formatter, [
        ('1|234', _keys('5'), '15|.234'),
        ('|234', _keys('9'), '9|.234'),
        ('1.23|4', _keys('0'), '12.30|4'),
        ('9|99.999', _keys('9'), '9.9|99.999'),
        ('|5', _keys('0'), '|5'),
      ]);
    });

    test('deletes digits and the digit next to a separator', () {
      _check(formatter, [
        ('1.234|', [const _Backspace()], '123|'),
        ('1.|234', [const _Backspace()], '|234'),
        ('1|.234', [const _Delete()], '1|34'),
        ('12.|345', [const _Backspace()], '1|.345'),
        ('1.2|34', [const _Backspace()], '1|34'),
        ('1.234.5|67', [const _Backspace()], '123.4|67'),
        ('|1.234', [const _Backspace()], '|1.234'),
        ('1.000|', [for (var i = 0; i < 5; i++) const _Backspace()], '|'),
        ('1|.000', [const _Backspace()], '|0'),
      ]);
    });

    test('replaces a selection', () {
      _check(formatter, [
        ('1.234|', [const _Select('[1.234]'), ..._keys('5')], '5|'),
        (
          '1.234.567|',
          [const _Select('1.234|.567'), const _Backspace(), ..._keys('9')],
          '1.239|.567',
        ),
        ('[1.234.567]', _keys('8'), '8|'),
        ('[1.234.567]', [const _Backspace()], '|'),
        ('1.[234].567', _keys('9'), '19|.567'),
        ('1[.2]34', [const _Delete()], '1|34'),
      ]);
    });

    test('pastes amounts written either way, with their cents', () {
      _check(formatter, [
        ('', [const _Paste('1500000')], '1.500.000|'),
        ('', [const _Paste('1.500.000,50')], '1.500.000,50|'),
        ('', [const _Paste(r'$ 1,500.50')], '1.500,50|'),
        ('', [const _Paste('1500000.5')], '1.500.000,5|'),
        ('', [const _Paste('1.500.000,505')], '1.500.000,50|'),
        ('', [const _Paste('COP 2,450,000')], '2.450.000|'),
        ('[9.999]', [const _Paste('1.500')], '1.500|'),
        ('1|0', [const _Paste('23')], '1.23|0'),
        ('12|', [const _Paste('abc')], '12|'),
      ]);
    });

    test('ignores edits beyond thirteen digits', () {
      _check(formatter, [
        ('', _keys('12345678901234'), '1.234.567.890.123|'),
        ('', [const _Paste('12345678901234')], '|'),
        ('', [const _Paste('9999999999999')], '9.999.999.999.999|'),
      ]);
    });
  });

  group('Colombian pesos in English', () {
    final formatter = _formatterOf(AppCurrency.cop, 'en');

    test('groups with commas and takes typed cents', () {
      _check(formatter, [
        ('', _keys('8500000'), '8,500,000|'),
        ('', _keys('8500000.5'), '8,500,000.5|'),
        ('', _keys('8500000,5'), '8,500,000,5|'),
        ('', _keys('1,500,000'), '1,500,000|'),
        ('', [const _Paste('1.500.000,50')], '1,500,000.50|'),
      ]);
    });
  });

  group('dollars in English', () {
    final formatter = _formatterOf(AppCurrency.usd, 'en');

    test('groups with commas and starts decimals with a point', () {
      _check(formatter, [
        ('', _keys('1234567'), '1,234,567|'),
        ('', _keys('1234.5'), '1,234.5|'),
        ('', _keys('1234.56'), '1,234.56|'),
        ('', _keys('1234.567'), '1,234.56|'),
        ('', _keys('1.2.3'), '1.23|'),
        ('', _keys('.5'), '0.5|'),
        ('', _keys('0.05'), '0.05|'),
      ]);
    });

    test('reads a typed comma by what follows it', () {
      _check(formatter, [
        ('', _keys('1,'), '1,|'),
        ('', _keys('1,5'), '1,5|'),
        ('', _keys('1,500'), '1,500|'),
        ('', _keys('1,500,000.50'), '1,500,000.50|'),
        ('', _keys('1,500,'), '1,500,|'),
        ('', _keys('1,5.'), '15.|'),
        ('', _keys('1,,5'), '1,5|'),
        ('1|,234', _keys(','), '1|,234'),
        ('', _keys(','), '0.|'),
      ]);
    });

    test('keeps the decimal point and caret while editing', () {
      _check(formatter, [
        ('1,234.5|6', [const _Backspace()], '1,234.|6'),
        ('1,234.|56', [const _Backspace()], '123,4|56'),
        ('1,234|.56', [const _Delete()], '123,4|56'),
        ('1,234.|56', _keys('7'), '1,234.|56'),
        ('1|,234.56', _keys('9'), '19|,234.56'),
        ('12|,345', _keys('.'), '12|,345'),
        ('123,4|56', _keys('.'), '1,234.|56'),
        ('0|.5', _keys('3'), '3|.5'),
        ('|0.5', _keys('3'), '3|0.5'),
      ]);
    });

    test('pastes amounts written either way', () {
      _check(formatter, [
        ('', [const _Paste('1500000')], '1,500,000|'),
        ('', [const _Paste('1.500.000,50')], '1,500,000.50|'),
        ('', [const _Paste(r'$ 1,500.50')], '1,500.50|'),
        ('', [const _Paste('1500000.5')], '1,500,000.5|'),
        ('', [const _Paste('1,500')], '1,500|'),
        ('', [const _Paste('1,50')], '1.50|'),
        ('', [const _Paste('0.500')], '0.50|'),
        ('', [const _Paste('12.3456')], '12.34|'),
        ('[1,234.56]', [const _Paste('7,890.12')], '7,890.12|'),
        ('1,234.56|', [const _Paste('.1')], '1,234.56|'),
        ('1,234,|', [const _Paste('.25')], '1,234.25|'),
      ]);
    });

    test('allows up to 9,999,999,999,999.99', () {
      _check(formatter, [
        ('', [const _Paste('9999999999999.99')], '9,999,999,999,999.99|'),
        ('9,999,999,999,999.99|', _keys('9'), '9,999,999,999,999.99|'),
      ]);
    });
  });

  group('dollars and euros in Spanish', () {
    for (final currency in [AppCurrency.usd, AppCurrency.eur]) {
      final formatter = _formatterOf(currency, 'es');

      test('${currency.code}: groups with dots and a decimal comma', () {
        _check(formatter, [
          ('', _keys('1234567,5'), '1.234.567,5|'),
          ('', _keys('1500,50'), '1.500,50|'),
          ('', _keys('1500,505'), '1.500,50|'),
          ('', _keys(','), '0,|'),
        ]);
      });

      test('${currency.code}: reads a typed dot by what follows it', () {
        _check(formatter, [
          ('', _keys('1500.5'), '1.500.5|'),
          ('', _keys('1500.50'), '1.500.50|'),
          ('', _keys('1.500'), '1.500|'),
          ('', _keys('1.500.000'), '1.500.000|'),
          ('', _keys('1.500,25'), '1.500,25|'),
        ]);
      });

      test('${currency.code}: pastes amounts written either way', () {
        _check(formatter, [
          ('', [const _Paste('1.500.000,50')], '1.500.000,50|'),
          ('', [const _Paste(r'$ 1,500.50')], '1.500,50|'),
          ('', [const _Paste('1500000.5')], '1.500.000,5|'),
          ('', [const _Paste('1,500')], '1.500|'),
          ('', [const _Paste('€1,234,567.50')], '1.234.567,50|'),
        ]);
      });
    }
  });

  group('the TRM', () {
    test('is written as pesos with cents in each language', () {
      final spanish = MoneyInputFormatter(
        MoneyFormatter.of(AppCurrency.usd, 'es').exchangeRateInputFormat,
      );
      final english = MoneyInputFormatter(
        MoneyFormatter.of(AppCurrency.cop, 'en').exchangeRateInputFormat,
      );

      _check(spanish, [
        ('', _keys('3950,25'), '3.950,25|'),
        ('', _keys('3950.25'), '3.950.25|'),
        ('', [const _Paste('3,950.25')], '3.950,25|'),
      ]);
      _check(english, [
        ('', _keys('3950.25'), '3,950.25|'),
        ('', [const _Paste('3.950,25')], '3,950.25|'),
      ]);
    });
  });

  test('leaves the text alone when only the selection moves', () {
    final formatter = _formatterOf(AppCurrency.cop, 'es');
    final moved = _value('1.2|34');

    expect(formatter.formatEditUpdate(_value('1.234|'), moved), moved);
  });

  test('reads a whole text set at once as pasted', () {
    final formatter = _formatterOf(AppCurrency.usd, 'en');
    const old = TextEditingValue(text: '9,999');
    const set = TextEditingValue(text: '1.234,5');

    expect(_marked(formatter.formatEditUpdate(old, set)), '1,234.5|');
  });

  test('writes whole numbers only in a format without decimals', () {
    const whole = MoneyInputFormat(
      groupSeparator: '.',
      decimalSeparator: ',',
      maxDecimals: 0,
    );

    _check(MoneyInputFormatter(whole), [
      ('', _keys('1500,50'), '150.050|'),
      ('1.234|', _keys(','), '1.234|'),
      ('', _keys('1.5'), '15|'),
      ('', [const _Paste('1.500.000,50')], '1.500.000|'),
    ]);
  });
}
