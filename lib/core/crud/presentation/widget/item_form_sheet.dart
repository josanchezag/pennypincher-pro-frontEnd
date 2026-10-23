import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pennypincher_pro/core/crud/domain/crud_item.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/core/crud/presentation/crud_screen_config.dart';
import 'package:pennypincher_pro/core/crud/presentation/widget/item_form_fields.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/widgets/button_progress_icon.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// Bottom sheet that creates an item, or edits [initial] when given. It
/// stays open while the bloc saves, shows a failed save inside the sheet
/// so the typed values are kept, and closes once the item is saved.
class ItemFormSheet<T extends CrudItem, D> extends StatefulWidget {
  const ItemFormSheet({required this.config, this.initial, super.key});

  static const Key saveKey = Key('item-form-save');
  static const Key errorKey = Key('item-form-error');

  final CrudScreenConfig<T, D> config;
  final T? initial;

  /// Opens the sheet, saving through [bloc].
  static Future<void> show<T extends CrudItem, D>(
    BuildContext context, {
    required CrudScreenConfig<T, D> config,
    required CrudBloc<T, D> bloc,
    T? initial,
  }) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (_) => BlocProvider<CrudBloc<T, D>>.value(
          value: bloc,
          child: ItemFormSheet<T, D>(config: config, initial: initial),
        ),
      );

  @override
  State<ItemFormSheet<T, D>> createState() => _ItemFormSheetState<T, D>();
}

class _ItemFormSheetState<T extends CrudItem, D>
    extends State<ItemFormSheet<T, D>> {
  late final FormGroup _form = widget.config.layout.formGroup(widget.initial);
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
            child: Text(_title, style: AppTypography.heading3),
          ),
          const SizedBox(height: AppSpacing.lg),
          ...ItemFormFields.spaced(widget.config.layout.formFields()),
          if (_error != null) _ErrorText(message: _error!),
          const SizedBox(height: AppSpacing.lg),
          _SaveButton(saving: _saving, onPressed: _submit),
        ],
      );

  String get _title =>
      widget.initial == null ? widget.config.addLabel : widget.config.editTitle;

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
        widget.config.layout.draftOf(_form),
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
