import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pennypincher_pro/core/crud/domain/crud_item.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/core/crud/presentation/crud_screen_config.dart';
import 'package:pennypincher_pro/core/crud/presentation/layout/item_form.dart';
import 'package:pennypincher_pro/core/crud/presentation/widget/item_form_fields.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/widgets/button_progress_icon.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// Bottom sheet that creates an item, or edits [initial] when given. It
/// stays open while the bloc saves, shows a failed save inside the sheet
/// so the typed values are kept, and closes once the item is saved. With a
/// [deleteLabel], editing also offers a delete button that closes the
/// sheet asking its opener to delete the item.
class ItemFormSheet<T extends CrudItem, D> extends StatefulWidget {
  const ItemFormSheet({
    required this.form,
    required this.title,
    this.initial,
    this.deleteLabel,
    super.key,
  });

  static const Key saveKey = Key('item-form-save');
  static const Key deleteKey = Key('item-form-delete');
  static const Key errorKey = Key('item-form-error');

  final ItemForm<T, D> form;
  final String title;
  final T? initial;
  final String? deleteLabel;

  /// Opens the sheet, saving through [bloc]. Resolves to true when the
  /// user asked to delete [initial] instead.
  static Future<bool> show<T extends CrudItem, D>(
    BuildContext context, {
    required ItemForm<T, D> form,
    required String title,
    required CrudBloc<T, D> bloc,
    T? initial,
    String? deleteLabel,
  }) async {
    final deleteRequested = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => BlocProvider<CrudBloc<T, D>>.value(
        value: bloc,
        child: ItemFormSheet<T, D>(
          form: form,
          title: title,
          initial: initial,
          deleteLabel: deleteLabel,
        ),
      ),
    );
    return deleteRequested ?? false;
  }

  @override
  State<ItemFormSheet<T, D>> createState() => _ItemFormSheetState<T, D>();
}

class _ItemFormSheetState<T extends CrudItem, D>
    extends State<ItemFormSheet<T, D>> {
  late final FormGroup _form = widget.form.formGroup(widget.initial);
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_saving,
      child: BlocListener<CrudBloc<T, D>, CrudState<T>>(
        listenWhen: (_, state) =>
            _saving && state is CrudLoaded<T> && !state.busy,
        listener: (context, state) => _onSaved(state as CrudLoaded<T>),
        child: Padding(
          padding: _padding(context),
          child: ReactiveForm(
            formGroup: _form,
            child: SingleChildScrollView(child: _content()),
          ),
        ),
      ),
    );
  }

  Widget _content() => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            header: true,
            namesRoute: true,
            child: Text(widget.title, style: AppTypography.heading3),
          ),
          const SizedBox(height: AppSpacing.lg),
          ...ItemFormFields.spaced(widget.form.formFields()),
          if (_error != null) _ErrorText(message: _error!),
          const SizedBox(height: AppSpacing.lg),
          _SaveButton(saving: _saving, onPressed: _submit),
          if (_deleteLabel case final label?)
            _DeleteButton(
              label: label,
              onPressed: _saving ? null : () => Navigator.of(context).pop(true),
            ),
        ],
      );

  /// Label of the delete button, shown only while editing an item.
  String? get _deleteLabel =>
      widget.initial == null ? null : widget.deleteLabel;

  /// Keeps the form above the on-screen keyboard.
  static EdgeInsets _padding(BuildContext context) => EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg + MediaQuery.viewInsetsOf(context).bottom,
      );

  void _submit() {
    final bloc = context.read<CrudBloc<T, D>>();
    final state = bloc.state;
    if (state is! CrudLoaded<T> || state.busy) {
      return;
    }
    if (!_form.valid) {
      _form.markAllAsTouched();
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    bloc.add(
      CrudSaveRequested<D>(
        widget.form.draftOf(_form),
        id: widget.initial?.id,
      ),
    );
  }

  void _onSaved(CrudLoaded<T> state) {
    if (state.failedAction == CrudAction.save) {
      setState(() {
        _saving = false;
        _error = state.errorMessage;
      });
      return;
    }
    Navigator.of(context).pop();
  }
}

class _ErrorText extends StatelessWidget {
  const _ErrorText({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: Semantics(
        liveRegion: true,
        child: Text(
          message,
          key: ItemFormSheet.errorKey,
          style: AppTypography.bodyMedium.copyWith(color: AppColors.error),
        ),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.saving, required this.onPressed});

  final bool saving;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      key: ItemFormSheet.saveKey,
      onPressed: saving ? null : onPressed,
      child: saving
          ? const ButtonProgressIcon(semanticsLabel: CrudTexts.saving)
          : const Text(CrudTexts.save),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs),
      child: TextButton.icon(
        key: ItemFormSheet.deleteKey,
        style: TextButton.styleFrom(foregroundColor: AppColors.error),
        onPressed: onPressed,
        icon: const Icon(Icons.delete_outline),
        label: Text(label),
      ),
    );
  }
}
