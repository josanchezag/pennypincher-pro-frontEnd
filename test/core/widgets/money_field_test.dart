import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/crud/presentation/widget/item_form_fields.dart';
import 'package:pennypincher_pro/core/utils/app_currency.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/utils/money_formatter.dart';
import 'package:pennypincher_pro/core/widgets/money_field.dart';
import 'package:pennypincher_pro/core/widgets/money_format_scope.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../helpers/l10n.dart';

const String _amount = 'amount';
const String _label = 'Amount';
const Key _otherField = Key('other-field');

/// A form with one [MoneyField] (or [field]) and another field to move the
/// focus to, in [currency] and [language].
Widget _form(
  FormGroup form, {
  AppCurrency currency = AppCurrency.cop,
  String language = 'es',
  bool exchangeRate = false,
  Widget? field,
}) =>
    localizedApp(
      locale: Locale(language),
      home: MoneyFormatScope(
        formatter: MoneyFormatter.of(currency, language),
        child: Scaffold(
          body: ReactiveForm(
            formGroup: form,
            child: Column(
              children: [
                field ??
                    MoneyField(
                      formControlName: _amount,
                      label: _label,
                      exchangeRate: exchangeRate,
                    ),
                const TextField(key: _otherField),
              ],
            ),
          ),
        ),
      ),
    );

FormGroup _group([Money? initial]) =>
    FormGroup({_amount: FormControl<Money>(value: initial)});

Finder get _field => find.byType(TextField).first;

TextEditingController _controller(WidgetTester tester) =>
    tester.widget<TextField>(_field).controller!;

/// Types [keys] one by one at the caret, as a keyboard does.
Future<void> _type(WidgetTester tester, String keys) async {
  await tester.showKeyboard(_field);
  for (final key in keys.split('')) {
    final value = _controller(tester).value;
    final at =
        value.selection.isValid ? value.selection.end : value.text.length;
    final start = value.selection.isValid ? value.selection.start : at;
    tester.testTextInput.updateEditingValue(
      TextEditingValue(
        text: value.text.replaceRange(start, at, key),
        selection: TextSelection.collapsed(offset: start + key.length),
      ),
    );
    await tester.pump();
  }
}

Money? _valueOf(FormGroup form) => form.control(_amount).value as Money?;

void main() {
  testWidgets('formats Spanish pesos as they are typed', (tester) async {
    final form = _group();
    addTearDown(form.dispose);
    await tester.pumpWidget(_form(form));

    await _type(tester, '1500000');

    expect(_controller(tester).text, '1.500.000');
    expect(_controller(tester).selection.baseOffset, 9);
    expect(_valueOf(form), const Money.fromUnits(1500000));
    final field = tester.widget<TextField>(_field);
    expect(field.decoration!.prefixText, '\$ ');
    expect(field.keyboardType, const TextInputType.numberWithOptions());
  });

  testWidgets('formats English dollars with their cents', (tester) async {
    final form = _group();
    addTearDown(form.dispose);
    await tester.pumpWidget(
      _form(form, currency: AppCurrency.usd, language: 'en'),
    );

    await _type(tester, '1,234,567.505');

    expect(_controller(tester).text, '1,234,567.50');
    expect(_valueOf(form), const Money.fromCents(123456750));
    final field = tester.widget<TextField>(_field);
    expect(field.decoration!.prefixText, r'$');
    expect(
      field.keyboardType,
      const TextInputType.numberWithOptions(decimal: true),
    );
  });

  testWidgets('puts the euro after a Spanish amount', (tester) async {
    final form = _group();
    addTearDown(form.dispose);
    await tester.pumpWidget(_form(form, currency: AppCurrency.eur));

    await _type(tester, '2500,7');

    expect(_controller(tester).text, '2.500,7');
    expect(_valueOf(form), const Money.fromCents(250070));
    final field = tester.widget<TextField>(_field);
    expect(field.decoration!.prefixText, isNull);
    expect(field.decoration!.suffixText, ' €');
  });

  testWidgets('reads pasted amounts in either convention', (tester) async {
    final form = _group();
    addTearDown(form.dispose);
    await tester.pumpWidget(_form(form, currency: AppCurrency.usd));

    for (final (pasted, shown, cents) in [
      ('1500000', '1.500.000', 150000000),
      ('1.500.000,50', '1.500.000,50', 150000050),
      (r'$ 1,500.50', '1.500,50', 150050),
      ('1500000.5', '1.500.000,5', 150000050),
    ]) {
      await tester.enterText(_field, pasted);

      expect(_controller(tester).text, shown, reason: pasted);
      expect(_valueOf(form), Money.fromCents(cents), reason: pasted);
    }
    await tester.enterText(_field, '');
    expect(_valueOf(form), isNull);
  });

  testWidgets('shows a saved amount formatted and keeps it exact',
      (tester) async {
    final form = _group(const Money.fromCents(Money.maxCents));
    addTearDown(form.dispose);
    await tester.pumpWidget(
      _form(form, currency: AppCurrency.usd, language: 'en'),
    );

    expect(_controller(tester).text, '9,999,999,999,999.99');
    await _type(tester, '9');
    expect(_controller(tester).text, '9,999,999,999,999.99');
    expect(_valueOf(form), const Money.fromCents(Money.maxCents));
  });

  testWidgets('keeps the cents of a peso amount saved with them',
      (tester) async {
    final form = _group(const Money.fromCents(125000050));
    addTearDown(form.dispose);
    await tester.pumpWidget(_form(form));

    expect(_controller(tester).text, '1.250.000,50');
    _controller(tester).selection = const TextSelection.collapsed(offset: 1);
    await _type(tester, '0');

    expect(_controller(tester).text, '10.250.000,50');
    expect(_valueOf(form), const Money.fromCents(1025000050));
  });

  testWidgets('tidies a typed amount when the field loses the focus',
      (tester) async {
    final form = _group();
    addTearDown(form.dispose);
    await tester.pumpWidget(_form(form, currency: AppCurrency.usd));

    await _type(tester, '1500.5');
    expect(_controller(tester).text, '1.500.5');
    expect(_valueOf(form), const Money.fromCents(150050));

    await tester.tap(find.byKey(_otherField));
    await tester.pump();

    expect(_controller(tester).text, '1.500,50');
    expect(_valueOf(form), const Money.fromCents(150050));
  });

  testWidgets('rewrites the amount when the language or currency changes',
      (tester) async {
    final form = _group(const Money.fromCents(150000050));
    addTearDown(form.dispose);
    await tester.pumpWidget(_form(form, currency: AppCurrency.usd));
    expect(_controller(tester).text, '1.500.000,50');

    await tester.pumpWidget(
      _form(form, currency: AppCurrency.usd, language: 'en'),
    );
    expect(_controller(tester).text, '1,500,000.50');

    await tester.pumpWidget(
      _form(form, currency: AppCurrency.eur, language: 'en'),
    );
    expect(_controller(tester).text, '1,500,000.50');
    expect(tester.widget<TextField>(_field).decoration!.prefixText, '€');
    expect(_valueOf(form), const Money.fromCents(150000050));
  });

  testWidgets('keeps cents typed in dollars after switching to pesos',
      (tester) async {
    final form = _group();
    addTearDown(form.dispose);
    await tester.pumpWidget(_form(form, currency: AppCurrency.usd));
    await _type(tester, '10,25');

    await tester.pumpWidget(_form(form));

    expect(_controller(tester).text, '10,25');
    expect(_valueOf(form), const Money.fromCents(1025));
  });

  testWidgets('writes the TRM as pesos with cents', (tester) async {
    final form = _group(const Money.fromUnits(3300));
    addTearDown(form.dispose);
    await tester.pumpWidget(
      _form(form, currency: AppCurrency.usd, exchangeRate: true),
    );

    expect(_controller(tester).text, '3.300');
    expect(tester.widget<TextField>(_field).decoration!.prefixText, '\$ ');
    await tester.enterText(_field, '');
    await _type(tester, '3950,25');

    expect(_controller(tester).text, '3.950,25');
    expect(_valueOf(form), const Money.fromCents(395025));
  });

  testWidgets('reads the label and the amount to screen readers',
      (tester) async {
    final semantics = tester.ensureSemantics();
    final form = _group(const Money.fromUnits(1500000));
    addTearDown(form.dispose);
    await tester.pumpWidget(_form(form));

    final node = tester.getSemantics(find.byType(EditableText).first);

    expect(node.label, _label);
    expect(node.value, '1.500.000');
    expect(node.getSemanticsData().hasFlag(SemanticsFlag.isTextField), isTrue);
    semantics.dispose();
  });

  group('the item amount field', () {
    Future<FormGroup> pumpItemField(
      WidgetTester tester, {
      required AppCurrency currency,
      required String language,
      bool optional = false,
    }) async {
      final form = FormGroup({
        _amount: optional
            ? ItemFormFields.optionalAmountControl(null)
            : ItemFormFields.positiveAmountControl(null),
      });
      addTearDown(form.dispose);
      await tester.pumpWidget(
        _form(
          form,
          currency: currency,
          language: language,
          field: ItemFormFields.amountField(
            _amount,
            _label,
            optional: optional,
          ),
        ),
      );
      return form;
    }

    testWidgets('gives an example in the currency and language',
        (tester) async {
      await pumpItemField(tester, currency: AppCurrency.cop, language: 'es');
      expect(
        find.text(l10nEs.crudAmountHelper('\$ 1.500.000')),
        findsOneWidget,
      );

      await pumpItemField(tester, currency: AppCurrency.usd, language: 'en');
      expect(
        find.text(l10n.crudAmountHelper(r'$1,500,000.50')),
        findsOneWidget,
      );

      await pumpItemField(
        tester,
        currency: AppCurrency.eur,
        language: 'es',
        optional: true,
      );
      expect(
        find.text(l10nEs.crudOptionalAmountHelper('1.500.000,50 €')),
        findsOneWidget,
      );
    });

    testWidgets('asks for an amount above zero in the interface language',
        (tester) async {
      final form = await pumpItemField(
        tester,
        currency: AppCurrency.usd,
        language: 'es',
      );

      form.markAllAsTouched();
      await tester.pump();
      expect(find.text(l10nEs.crudAmountRequired), findsOneWidget);

      await _type(tester, '0,00');
      expect(find.text(l10nEs.crudAmountNotPositive), findsOneWidget);

      await tester.enterText(_field, '1.234,56');
      await tester.pump();
      expect(form.valid, isTrue);
      expect(
        ItemFormFields.amountOf(form, _amount),
        const Money.fromCents(123456),
      );
    });

    testWidgets('leaves an optional amount empty', (tester) async {
      final form = await pumpItemField(
        tester,
        currency: AppCurrency.eur,
        language: 'en',
        optional: true,
      );

      await _type(tester, 'abc');

      expect(_controller(tester).text, isEmpty);
      expect(form.valid, isTrue);
      expect(ItemFormFields.optionalAmountOf(form, _amount), isNull);
    });
  });
}
