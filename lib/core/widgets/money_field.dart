import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/utils/money_input_format.dart';
import 'package:pennypincher_pro/core/utils/money_input_formatter.dart';
import 'package:pennypincher_pro/core/widgets/money_format_scope.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// Text field of the [Money] control [formControlName], written in the
/// user's currency and interface language as it is typed (see
/// [MoneyInputFormatter]): `$ 1.500.000` in Spanish pesos, `$1,500.50` in
/// English dollars. The control holds the exact amount, or `null` while the
/// field is empty, so required and range checks are ordinary validators.
///
/// With [exchangeRate] the field takes the TRM instead: Colombian pesos with
/// two decimals whatever the user's currency.
///
/// A peso amount saved with cents keeps them when edited instead of being
/// rounded. A change of currency or language while the field is open
/// rewrites its amount at once, and leaving the field tidies what was typed
/// (`1500.5` becomes `1.500,50`).
class MoneyField extends StatefulWidget {
  const MoneyField({
    required this.formControlName,
    required this.label,
    this.helperText,
    this.validationMessages = const {},
    this.exchangeRate = false,
    this.autofocus = false,
    this.onSubmitted,
    this.messageMaxLines,
    this.fieldKey,
    super.key,
  });

  final String formControlName;
  final String label;
  final String? helperText;
  final Map<String, ValidationMessageFunction> validationMessages;
  final bool exchangeRate;
  final bool autofocus;
  final VoidCallback? onSubmitted;

  /// Lines the helper and error texts may wrap to.
  final int? messageMaxLines;

  /// Key of the inner text field.
  final Key? fieldKey;

  @override
  State<MoneyField> createState() => _MoneyFieldState();
}

class _MoneyFieldState extends State<MoneyField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final _MoneyValueAccessor _accessor = _MoneyValueAccessor();
  MoneyInputFormat? _format;
  late MoneyInputFormatter _formatter;
  bool _keepsCents = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final money = context.money;
    final value = _control.value;
    _keepsCents = _keepsCents ||
        money.inputFormat.keepingCentsOf(value) != money.inputFormat;
    final base =
        widget.exchangeRate ? money.exchangeRateInputFormat : money.inputFormat;
    final format =
        _keepsCents ? base.withMaxDecimals(MoneyInputFormat.centsDigits) : base;
    if (format == _format) {
      return;
    }
    final changed = _format != null;
    _format = format;
    _accessor.format = format;
    _formatter = MoneyInputFormatter(format);
    if (changed) {
      _showValue(value);
    }
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_onFocusChanged)
      ..dispose();
    _controller.dispose();
    super.dispose();
  }

  FormControl<Money> get _control =>
      (ReactiveForm.of(context, listen: false)! as FormGroup)
          .control(widget.formControlName) as FormControl<Money>;

  void _onFocusChanged() {
    if (!_focusNode.hasFocus) {
      _showValue(_control.value);
    }
  }

  /// Rewrites the field with [value] as the current format writes it.
  void _showValue(Money? value) {
    final text = _accessor.modelToViewValue(value);
    if (text == _controller.text) {
      return;
    }
    _controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    final format = _format!;
    return ReactiveTextField<Money>(
      key: widget.fieldKey,
      formControlName: widget.formControlName,
      controller: _controller,
      focusNode: _focusNode,
      valueAccessor: _accessor,
      autofocus: widget.autofocus,
      keyboardType:
          TextInputType.numberWithOptions(decimal: format.allowsDecimals),
      inputFormatters: [_formatter],
      onSubmitted:
          widget.onSubmitted == null ? null : (_) => widget.onSubmitted!.call(),
      decoration: InputDecoration(
        labelText: widget.label,
        prefixText: format.prefix.isEmpty ? null : format.prefix,
        suffixText: format.suffix.isEmpty ? null : format.suffix,
        helperText: widget.helperText,
        helperMaxLines: widget.messageMaxLines,
        errorMaxLines: widget.messageMaxLines,
      ),
      validationMessages: widget.validationMessages,
    );
  }
}

/// Converts between the exact amount of the control and the field's text.
class _MoneyValueAccessor extends ControlValueAccessor<Money, String> {
  late MoneyInputFormat format;

  @override
  String modelToViewValue(Money? modelValue) => format.format(modelValue);

  @override
  Money? viewToModelValue(String? viewValue) =>
      viewValue == null ? null : format.parse(viewValue);
}
