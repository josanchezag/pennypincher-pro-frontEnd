import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/crud/presentation/widget/item_form_fields.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/widgets/money_field.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// What an [AntLimitDialog] resolves to: the new limit, or `null` inside
/// when the user removed it.
typedef AntLimitResult = ({Money? monthlyLimit});

/// Dialog that sets the monthly soft limit, changes it or, when there is
/// one, removes it. Resolves to `null` when cancelled.
class AntLimitDialog extends StatefulWidget {
  const AntLimitDialog({required this.current, super.key});

  static const String field = 'monthlyLimit';
  static const Key fieldKey = Key('ant-limit-field');
  static const Key saveKey = Key('ant-limit-save');
  static const Key removeKey = Key('ant-limit-remove');
  static const int maxMessageLines = 3;

  final Money? current;

  static Future<AntLimitResult?> show(
    BuildContext context, {
    required Money? current,
  }) =>
      showDialog<AntLimitResult>(
        context: context,
        builder: (_) => AntLimitDialog(current: current),
      );

  @override
  State<AntLimitDialog> createState() => _AntLimitDialogState();
}

class _AntLimitDialogState extends State<AntLimitDialog> {
  late final FormGroup _form = FormGroup({
    AntLimitDialog.field: ItemFormFields.positiveAmountControl(widget.current),
  });

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  void _save() {
    if (!_form.valid) {
      _form.markAllAsTouched();
      return;
    }
    final limit = ItemFormFields.amountOf(_form, AntLimitDialog.field);
    Navigator.of(context).pop((monthlyLimit: limit));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.antLimitDialogTitle),
      content: ReactiveForm(
        formGroup: _form,
        child: MoneyField(
          fieldKey: AntLimitDialog.fieldKey,
          formControlName: AntLimitDialog.field,
          label: l10n.antLimitTitle,
          autofocus: true,
          onSubmitted: _save,
          helperText: l10n.antLimitDialogHint,
          messageMaxLines: AntLimitDialog.maxMessageLines,
          validationMessages: {
            ValidationMessage.required: (_) => l10n.crudAmountRequired,
            ItemFormFields.amountNotPositiveError: (_) =>
                l10n.crudAmountNotPositive,
          },
        ),
      ),
      actions: [
        if (widget.current != null)
          TextButton(
            key: AntLimitDialog.removeKey,
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            onPressed: () => Navigator.of(context).pop((monthlyLimit: null)),
            child: Text(l10n.antLimitRemove),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          key: AntLimitDialog.saveKey,
          onPressed: _save,
          child: Text(l10n.commonSave),
        ),
      ],
    );
  }
}
