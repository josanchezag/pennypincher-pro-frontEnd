import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pennypincher_pro/core/crud/domain/crud_item.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/core/crud/presentation/crud_screen_config.dart';
import 'package:pennypincher_pro/core/crud/presentation/widget/crud_list_view.dart';
import 'package:pennypincher_pro/core/crud/presentation/widget/item_form_sheet.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/widgets/app_snackbar.dart';
import 'package:pennypincher_pro/core/widgets/confirmation_dialog.dart';
import 'package:pennypincher_pro/core/widgets/loading_skeleton.dart';
import 'package:pennypincher_pro/core/widgets/status_message.dart';

/// List screen driven by a [CrudBloc] of type [B] provided above it:
/// summary, items as the config's layout arranges them, add button, edit
/// sheet and delete confirmation. Snack bars are shown in this
/// screen's own scaffold so they push the add button up.
class CrudScreen<T extends CrudItem, D, B extends CrudBloc<T, D>>
    extends StatelessWidget {
  const CrudScreen({required this.config, super.key});

  static const Key addButtonKey = Key('crud-add-button');
  static const List<double> skeletonHeights = [
    AppSpacing.xxl,
    AppSpacing.xxxl + AppSpacing.lg,
    AppSpacing.lg,
    AppSpacing.xxxl,
    AppSpacing.xxxl,
    AppSpacing.lg,
    AppSpacing.xxxl,
  ];

  final CrudScreenConfig<T, D> config;

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: BlocConsumer<B, CrudState<T>>(
        listenWhen: (_, state) => _failedDelete(state) != null,
        listener: (context, state) =>
            AppSnackbar.showError(context, _failedDelete(state)!),
        builder: (context, state) => Scaffold(
          floatingActionButton: state is CrudLoaded<T>
              ? FloatingActionButton(
                  key: addButtonKey,
                  tooltip: config.addLabel,
                  onPressed: state.busy ? null : () => _edit(context, null),
                  child: const Icon(Icons.add),
                )
              : null,
          body: _body(context, state),
        ),
      ),
    );
  }

  Widget _body(BuildContext context, CrudState<T> state) => switch (state) {
        CrudLoading<T>() => const LoadingSkeleton(
            heights: skeletonHeights,
            label: CrudTexts.loadingLabel,
          ),
        CrudLoadFailure<T>(:final message) => StatusMessage(
            icon: Icons.cloud_off_outlined,
            title: CrudTexts.loadErrorTitle,
            message: message,
            action: FilledButton.icon(
              onPressed: () => context.read<B>().add(CrudLoadRequested<D>()),
              icon: const Icon(Icons.refresh),
              label: const Text(CrudTexts.retry),
            ),
          ),
        CrudLoaded<T>(:final items, :final busy) => CrudListView<T, D>(
            config: config,
            items: items,
            busy: busy,
            onEdit: (item) => _edit(context, item),
            onDelete: (item) => _delete(context, item),
          ),
      };

  /// Message of a delete that just failed. Failed saves are reported
  /// inside the form sheet instead.
  static String? _failedDelete(Object state) =>
      state is CrudLoaded && state.failedAction == CrudAction.delete
          ? state.errorMessage
          : null;

  Future<void> _edit(BuildContext context, T? item) => ItemFormSheet.show<T, D>(
        context,
        config: config,
        bloc: context.read<B>(),
        initial: item,
      );

  Future<void> _delete(BuildContext context, T item) async {
    final bloc = context.read<B>();
    final confirmed = await ConfirmationDialog.show(
      context,
      title: config.deleteTitle,
      message: config.deleteMessage(item.name),
      confirmLabel: CrudTexts.delete,
    );
    if (confirmed) {
      bloc.add(CrudDeleteRequested<D>(item.id));
    }
  }
}
