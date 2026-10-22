import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/core/crud/presentation/crud_screen_config.dart';
import 'package:pennypincher_pro/core/crud/presentation/widget/item_form_fields.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// Bottom sheet that creates an item, or edits [initial] when given. It
/// stays open while the bloc saves, shows a failed save inside the sheet
/// so the typed values are kept, and closes once the item is saved.
class ItemFormSheet<T extends CategorizedItem<C>, C extends Enum>
    extends StatefulWidget {
  const ItemFormSheet({required this.config, this.initial, super.key});

  static const Key saveKey = Key('item-form-save');
  static const Key errorKey = Key('item-form-error');
  static const double progressSize = AppSpacing.md;
  static const double progressStroke = 2;

  final CrudScreenConfig<C> config;
  final T? initial;

  /// Opens the sheet, saving through [bloc].
  static Future<void> show<T extends CategorizedItem<C>, C extends Enum>(
    BuildContext context, {
    required CrudScreenConfig<C> config,
    required CrudBloc<T, C> bloc,
    T? initial,
  }) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (_) => BlocProvider<CrudBloc<T, C>>.value(
          value: bloc,
          child: ItemFormSheet<T, C>(config: config, initial: initial),
        ),
      );

  @override
  State<ItemFormSheet<T, C>> createState() => _ItemFormSheetState<T, C>();
}

class _ItemFormSheetState<T extends CategorizedItem<C>, C extends Enum>
    extends State<ItemFormSheet<T, C>> {
  late final FormGroup _form = ItemFormFields.group<C>(widget.initial);
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
      child: BlocListener<CrudBloc<T, C>, CrudState<T>>(
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
          ...ItemFormFields.build<C>(widget.config),
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
    final bloc = context.read<CrudBloc<T, C>>();
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
    bloc.add(CrudSaveRequested<C>(_draft(), id: widget.initial?.id));
  }

  ItemDraft<C> _draft() => ItemDraft<C>(
        name: (_form.control(ItemFormFields.name).value as String).trim(),
        amount: Money.tryParseInput(
          _form.control(ItemFormFields.amount).value as String,
        )!,
        category: _form.control(ItemFormFields.category).value as C,
      );

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
          ? const SizedBox.square(
              dimension: ItemFormSheet.progressSize,
              child: CircularProgressIndicator(
                strokeWidth: ItemFormSheet.progressStroke,
                semanticsLabel: CrudTexts.saving,
              ),
            )
          : const Text(CrudTexts.save),
    );
  }
}
