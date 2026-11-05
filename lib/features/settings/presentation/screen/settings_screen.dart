import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/widgets/app_snackbar.dart';
import 'package:pennypincher_pro/features/settings/presentation/cubit/preferences_cubit.dart';
import 'package:pennypincher_pro/features/settings/presentation/widget/language_options.dart';
import 'package:pennypincher_pro/features/settings/presentation/widget/settings_section.dart';

/// `/settings`: the preferences saved in the user's account, one
/// [SettingsSection] per setting (the language today; the display currency
/// goes below it). A failed save shows a snack bar and the previous value
/// comes back. Expects a [PreferencesCubit] above it.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const Key loadFailedKey = Key('settings-load-failed');
  static const Key retryKey = Key('settings-retry');

  /// Settings read best in a narrow column, even on a desktop.
  static const double maxWidth = 720;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<PreferencesCubit, PreferencesState>(
        listenWhen: (previous, current) =>
            current.saveError != null &&
            current.saveError != previous.saveError,
        // In the language the interface goes back to, which is already in
        // the state while the screen still shows the one that failed.
        listener: (context, state) => AppSnackbar.showError(
          context,
          lookupAppLocalizations(state.language).settingsLanguageSaveFailed,
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: maxWidth),
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: const [
                _Title(),
                _LoadNotice(),
                _LanguageSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(
              AppRoute.settings.title(l10n),
              style: AppTypography.heading1,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.settingsIntro,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Says that the saved settings could not be loaded, with a retry; the
/// screen keeps working with the settings of this device.
class _LoadNotice extends StatelessWidget {
  const _LoadNotice();

  @override
  Widget build(BuildContext context) {
    final failed = context.select(
      (PreferencesCubit cubit) =>
          cubit.state.status == PreferencesStatus.loadFailed,
    );
    if (!failed) {
      return const SizedBox.shrink();
    }
    return Padding(
      key: SettingsScreen.loadFailedKey,
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.cloud_off_outlined, color: AppColors.warning),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.settingsLoadFailed,
                  style: AppTypography.bodyMedium,
                ),
                TextButton(
                  key: SettingsScreen.retryKey,
                  onPressed: () => context.read<PreferencesCubit>().load(),
                  child: Text(context.l10n.commonRetry),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageSection extends StatelessWidget {
  const _LanguageSection();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<PreferencesCubit>().state;
    final cubit = context.read<PreferencesCubit>();
    return SettingsSection(
      icon: Icons.translate,
      title: l10n.settingsLanguageTitle,
      description: l10n.settingsLanguageDescription,
      busy: state.saving,
      child: LanguageOptions(
        selected: state.language,
        onSelected: state.saving ? null : cubit.changeLanguage,
      ),
    );
  }
}
