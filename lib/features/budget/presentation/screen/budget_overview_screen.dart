import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/widgets/app_snackbar.dart';
import 'package:pennypincher_pro/core/widgets/button_progress_icon.dart';
import 'package:pennypincher_pro/core/widgets/loading_skeleton.dart';
import 'package:pennypincher_pro/core/widgets/month_selector.dart';
import 'package:pennypincher_pro/core/widgets/status_message.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/monthly_budget_entity.dart';
import 'package:pennypincher_pro/features/budget/presentation/bloc/monthly_budget_bloc.dart';
import 'package:pennypincher_pro/features/budget/presentation/budget_texts.dart';
import 'package:pennypincher_pro/features/budget/presentation/widget/budget_overview_content.dart';

/// `/budget/overview`: the budget of one month with a month selector, or
/// a button that creates it. Opens on the current month. Expects a
/// [MonthlyBudgetBloc] above it.
class BudgetOverviewScreen extends StatelessWidget {
  const BudgetOverviewScreen({super.key});

  static const Key createBudgetKey = Key('create-budget-button');

  /// Placeholder of a stat card.
  static const double statSkeletonHeight = AppSpacing.xxxl + AppSpacing.lg;

  /// Placeholder of the category breakdown, about its real height.
  static const double sectionSkeletonHeight = 256;
  static const List<double> skeletonHeights = [
    statSkeletonHeight,
    statSkeletonHeight,
    sectionSkeletonHeight,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<MonthlyBudgetBloc, MonthlyBudgetState>(
        listenWhen: (previous, current) =>
            previous.isBusy && current.finishedAction != null,
        listener: _reportChange,
        builder: (context, state) => ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            _Header(state: state),
            const SizedBox(height: AppSpacing.md),
            _body(context, state),
          ],
        ),
      ),
    );
  }

  static Widget _body(BuildContext context, MonthlyBudgetState state) {
    final budget = state.budget;
    return switch (state.status) {
      BudgetLoadStatus.loading => const _Loading(),
      BudgetLoadStatus.failure => StatusMessage(
          icon: Icons.cloud_off_outlined,
          title: BudgetTexts.loadErrorTitle,
          message: state.loadError ?? '',
          action: FilledButton.icon(
            onPressed: () => context
                .read<MonthlyBudgetBloc>()
                .add(const MonthlyBudgetReloadRequested()),
            icon: const Icon(Icons.refresh),
            label: const Text(BudgetTexts.retry),
          ),
        ),
      BudgetLoadStatus.loaded when budget == null => _NoBudget(state: state),
      BudgetLoadStatus.loaded => BudgetOverviewContent(
          budget: budget!,
          state: state,
        ),
    };
  }

  static void _reportChange(BuildContext context, MonthlyBudgetState state) {
    final error = state.actionError;
    if (error != null) {
      AppSnackbar.showError(context, error);
      return;
    }
    AppSnackbar.showSuccess(
      context,
      switch (state.finishedAction!) {
        BudgetAction.create when state.alreadyExisted =>
          '${BudgetTexts.existingPrefix} ${MonthSelector.label(state.month)} '
              '${BudgetTexts.existingSuffix}',
        BudgetAction.create =>
          '${BudgetTexts.createdPrefix} ${MonthSelector.label(state.month)}',
        BudgetAction.update => BudgetTexts.updated,
        BudgetAction.recalculate => BudgetTexts.recalculated,
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.state});

  final MonthlyBudgetState state;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.sm,
      children: [
        Semantics(
          container: true,
          header: true,
          child: Text(
            AppRoute.budgetOverview.title,
            style: AppTypography.heading1,
          ),
        ),
        MonthSelector(
          month: state.month,
          first: BudgetLimits.firstMonth,
          last: BudgetLimits.lastMonth,
          enabled: !state.isBusy,
          onChanged: (month) => context
              .read<MonthlyBudgetBloc>()
              .add(MonthlyBudgetMonthChanged(month)),
        ),
      ],
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: BudgetTexts.loadingLabel,
      liveRegion: true,
      child: Column(
        children: [
          for (final height in BudgetOverviewScreen.skeletonHeights) ...[
            SkeletonBox(height: height),
            const SizedBox(height: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}

class _NoBudget extends StatelessWidget {
  const _NoBudget({required this.state});

  final MonthlyBudgetState state;

  @override
  Widget build(BuildContext context) {
    final creating = state.runningAction == BudgetAction.create;
    return StatusMessage(
      icon: Icons.pie_chart_outline,
      title: '${BudgetTexts.noBudgetTitlePrefix} '
          '${MonthSelector.label(state.month)}',
      message: BudgetTexts.noBudgetMessage,
      action: FilledButton.icon(
        key: BudgetOverviewScreen.createBudgetKey,
        onPressed: state.canCreate
            ? () => context
                .read<MonthlyBudgetBloc>()
                .add(const MonthlyBudgetCreateRequested())
            : null,
        icon: creating ? const ButtonProgressIcon() : const Icon(Icons.add),
        label: const Text(BudgetTexts.createBudget),
      ),
    );
  }
}
