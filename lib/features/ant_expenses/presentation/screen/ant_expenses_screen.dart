import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/core/crud/presentation/widget/crud_list_view.dart';
import 'package:pennypincher_pro/core/crud/presentation/widget/item_form_sheet.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/theme/app_breakpoints.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/widgets/app_snackbar.dart';
import 'package:pennypincher_pro/core/widgets/confirmation_dialog.dart';
import 'package:pennypincher_pro/core/widgets/money_format_scope.dart';
import 'package:pennypincher_pro/core/widgets/screen_title_row.dart';
import 'package:pennypincher_pro/core/widgets/status_message.dart';
import 'package:pennypincher_pro/features/ant_expenses/domain/entity/ant_expense_entity.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/ant_expense_categories.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/bloc/ant_expense_bloc.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/bloc/ant_insights_cubit.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/widget/ant_breakdown_card.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/widget/ant_cut_hint.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/widget/ant_cut_sheet.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/widget/ant_cuts_card.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/widget/ant_expense_form.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/widget/ant_expense_list.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/widget/ant_limit_dialog.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/widget/ant_period_card.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/widget/ant_quick_add.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/widget/ant_section_states.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/widget/ant_trend_card.dart';

/// `/expenses/ant`: the current period of ant expenses (totals, limit,
/// quick add chips and the expenses by day) next to the breakdown by
/// category, the monthly trend and the history of cuts on desktop
/// screens, or everything stacked on smaller ones. Expects an
/// [AntExpenseBloc] and an [AntInsightsCubit] above it. Snack bars are
/// shown in this screen's own scaffold so they push the add button up.
class AntExpensesScreen extends StatelessWidget {
  const AntExpensesScreen({super.key});

  static const Key addButtonKey = Key('ant-add-button');
  static const Key scrollKey = Key('ant-expenses-scroll');
  static const List<double> listSkeletonHeights = [
    AppSpacing.md,
    AppSpacing.xxxl,
    AppSpacing.xxxl,
    AppSpacing.xxxl,
  ];

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: MultiBlocListener(
        listeners: [
          const BlocListener<AntExpenseBloc, CrudState<AntExpense>>(
            listenWhen: _changeFinished,
            listener: _onChangeFinished,
          ),
          BlocListener<AntInsightsCubit, AntInsightsState>(
            listenWhen: (previous, current) =>
                previous.savingLimit && !current.savingLimit,
            listener: _onLimitSaved,
          ),
        ],
        child: BlocBuilder<AntExpenseBloc, CrudState<AntExpense>>(
          builder: (context, list) => Scaffold(
            floatingActionButton: list is CrudLoaded<AntExpense>
                ? FloatingActionButton.extended(
                    key: addButtonKey,
                    onPressed: list.busy ? null : () => _edit(context, null),
                    icon: const Icon(Icons.add),
                    label: Text(context.l10n.antAdd),
                  )
                : null,
            body: BlocBuilder<AntInsightsCubit, AntInsightsState>(
              builder: (context, insights) =>
                  _Content(list: list, insights: insights),
            ),
          ),
        ),
      ),
    );
  }

  static bool _changeFinished(
    CrudState<AntExpense> previous,
    CrudState<AntExpense> current,
  ) =>
      previous is CrudLoaded<AntExpense> &&
      previous.busy &&
      current is CrudLoaded<AntExpense> &&
      !current.busy;

  /// A failed delete is reported in a snack bar (a failed save stays in its
  /// sheet); a successful change updates the totals and the trend.
  static void _onChangeFinished(
    BuildContext context,
    CrudState<AntExpense> state,
  ) {
    final loaded = state as CrudLoaded<AntExpense>;
    if (loaded.failedAction == CrudAction.delete) {
      AppSnackbar.showError(context, loaded.errorMessage ?? '');
    }
    if (loaded.failedAction == null) {
      context.read<AntInsightsCubit>().refreshPeriod();
    }
  }

  static void _onLimitSaved(BuildContext context, AntInsightsState state) {
    final error = state.limitError;
    if (error != null) {
      AppSnackbar.showError(context, error);
      return;
    }
    final limit = state.summary.valueOrNull?.limit;
    AppSnackbar.showSuccess(
      context,
      limit == null ? context.l10n.antLimitRemoved : context.l10n.antLimitSaved,
    );
  }

  /// Opens the sheet that adds an expense, in [category] when given, or
  /// edits [item].
  static Future<void> _edit(
    BuildContext context,
    AntExpense? item, {
    AntExpenseCategory? category,
  }) async {
    final bloc = context.read<AntExpenseBloc>();
    final today = context.read<AntInsightsCubit>().state.today;
    final l10n = context.l10n;
    final deleteRequested =
        await ItemFormSheet.show<AntExpense, AntExpenseDraft>(
      context,
      form: AntExpenseForm(today: today, category: category),
      title: item == null ? l10n.antAdd : l10n.antEdit,
      bloc: bloc,
      initial: item,
      deleteLabel: l10n.antDelete,
    );
    if (deleteRequested && item != null && context.mounted) {
      await _delete(context, item);
    }
  }

  static Future<void> _delete(BuildContext context, AntExpense item) async {
    final bloc = context.read<AntExpenseBloc>();
    final l10n = context.l10n;
    final confirmed = await ConfirmationDialog.show(
      context,
      title: l10n.antDeleteTitle,
      message: l10n.antDeleteMessage(
        item.title(l10n),
        context.money.format(item.amount),
      ),
      confirmLabel: l10n.commonDelete,
    );
    if (confirmed) {
      bloc.add(CrudDeleteRequested<AntExpenseDraft>(item.id));
    }
  }

  static Future<void> _editLimit(BuildContext context, Money? current) async {
    final cubit = context.read<AntInsightsCubit>();
    final result = await AntLimitDialog.show(context, current: current);
    if (result != null) {
      await cubit.saveLimit(result.monthlyLimit);
    }
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.list, required this.insights});

  final CrudState<AntExpense> list;
  final AntInsightsState insights;

  bool get _busy =>
      (list is CrudLoaded<AntExpense> &&
          (list as CrudLoaded<AntExpense>).busy) ||
      insights.savingLimit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<AntInsightsCubit>();
    final desktop = ScreenSize.fromWidth(MediaQuery.sizeOf(context).width) ==
        ScreenSize.desktop;
    final canChange = list is CrudLoaded<AntExpense> && !_busy;
    final period = AntPeriodCard(
      summary: insights.summary,
      onRetry: cubit.retrySummary,
      onEditLimit: insights.summary.valueOrNull == null || insights.savingLimit
          ? null
          : () => AntExpensesScreen._editLimit(
                context,
                insights.summary.valueOrNull?.limit?.monthlyLimit,
              ),
    );
    final quickAdd = AntQuickAdd(
      onAdd: canChange
          ? (category) =>
              AntExpensesScreen._edit(context, null, category: category)
          : null,
    );
    final expenses = _ExpensesSection(
      list: list,
      today: insights.today,
      enabled: canChange,
    );
    final reports = [
      AntBreakdownCard(summary: insights.summary, onRetry: cubit.retrySummary),
      AntTrendCard(
        trend: insights.trend,
        months: insights.trendMonths,
        limit: insights.summary.valueOrNull?.limit?.monthlyLimit,
        onMonthsChanged: cubit.changeTrendMonths,
        onRetry: cubit.retryTrend,
      ),
      AntCutsCard(
        cuts: insights.cuts,
        onRetry: cubit.retryCuts,
        onOpen: (cut) =>
            AntCutSheet.show(context, cut: cut, today: insights.today),
      ),
    ];
    return ListView(
      key: AntExpensesScreen.scrollKey,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        CrudListView.bottomInset,
      ),
      children: [
        ScreenTitleRow(
          title: AppRoute.expensesAnt.title(l10n),
          backTooltip: l10n.commonBackTo(AppRoute.expenses.title(l10n)),
          parent: AppRoute.expenses.name,
        ),
        SizedBox(
          height: AppSpacing.xxs,
          child: _busy ? const LinearProgressIndicator() : null,
        ),
        const SizedBox(height: AppSpacing.sm),
        if (desktop)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    period,
                    const SizedBox(height: AppSpacing.md),
                    quickAdd,
                    const SizedBox(height: AppSpacing.md),
                    expenses,
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: _stacked(reports)),
            ],
          )
        else ...[
          period,
          const SizedBox(height: AppSpacing.md),
          quickAdd,
          const SizedBox(height: AppSpacing.md),
          expenses,
          const SizedBox(height: AppSpacing.lg),
          _stacked(reports),
        ],
        const SizedBox(height: AppSpacing.lg),
        const AntCutHint(),
      ],
    );
  }

  static Widget _stacked(List<Widget> cards) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (index, card) in cards.indexed) ...[
            if (index > 0) const SizedBox(height: AppSpacing.md),
            card,
          ],
        ],
      );
}

/// The open expenses by day, or their loading, error and empty states.
class _ExpensesSection extends StatelessWidget {
  const _ExpensesSection({
    required this.list,
    required this.today,
    required this.enabled,
  });

  final CrudState<AntExpense> list;
  final DateTime today;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Text(l10n.antListTitle, style: AppTypography.heading3),
        ),
        switch (list) {
          CrudLoading<AntExpense>() => const Padding(
              padding: EdgeInsets.only(top: AppSpacing.md),
              child: AntSectionSkeleton(
                heights: AntExpensesScreen.listSkeletonHeights,
              ),
            ),
          CrudLoadFailure<AntExpense>(:final message) => StatusMessage(
              icon: Icons.cloud_off_outlined,
              title: l10n.antListLoadError,
              message: message,
              action: FilledButton.icon(
                onPressed: () => context
                    .read<AntExpenseBloc>()
                    .add(const CrudLoadRequested<AntExpenseDraft>()),
                icon: const Icon(Icons.refresh),
                label: Text(l10n.commonRetry),
              ),
            ),
          CrudLoaded<AntExpense>(:final items) when items.isEmpty =>
            StatusMessage(
              icon: Icons.local_cafe_outlined,
              title: l10n.antEmptyTitle,
              message: l10n.antEmptyMessage,
            ),
          CrudLoaded<AntExpense>(:final items) => AntExpenseList(
              items: items,
              today: today,
              onEdit: enabled
                  ? (item) => AntExpensesScreen._edit(context, item)
                  : null,
              onDelete: enabled
                  ? (item) => AntExpensesScreen._delete(context, item)
                  : null,
            ),
        },
      ],
    );
  }
}
