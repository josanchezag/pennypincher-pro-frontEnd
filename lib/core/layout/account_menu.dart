import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/l10n/locale_cubit.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/utils/name_initials.dart';

/// The signed-in person as the navigation shell shows them.
class ShellAccount {
  const ShellAccount({
    required this.name,
    required this.email,
    this.pictureUrl,
  });

  final String name;
  final String email;
  final String? pictureUrl;

  String get initials => NameInitials.of(name);
}

/// Avatar at the top-right corner of the shell that opens the account
/// menu: who is signed in, the interface language and the sign-out action.
/// Expects a [LocaleCubit] above it.
class AccountMenu extends StatelessWidget {
  const AccountMenu({
    required this.account,
    required this.onSignOut,
    super.key,
  });

  static const Key buttonKey = Key('account-menu-button');
  static const Key headerKey = Key('account-menu-header');
  static const Key signOutKey = Key('account-menu-sign-out');

  /// Menu entry that switches the interface to [locale].
  static Key languageKey(Locale locale) =>
      Key('account-menu-language-${locale.languageCode}');

  static const double avatarRadius = 16;
  static const double headerMaxWidth = 280;

  /// `null` while the session is changing; the avatar then shows a
  /// generic person icon.
  final ShellAccount? account;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    final account = this.account;
    final l10n = context.l10n;
    final current = context.watch<LocaleCubit>().state;
    return MenuAnchor(
      alignmentOffset: const Offset(0, AppSpacing.xxs),
      menuChildren: [
        if (account != null) _AccountHeader(account: account),
        if (account != null) const Divider(height: AppSpacing.md),
        _SectionLabel(text: l10n.accountMenuLanguage),
        for (final locale in AppLocales.supported)
          _LanguageItem(
            locale: locale,
            label: _languageName(l10n, locale),
            selected: locale == current,
          ),
        const Divider(height: AppSpacing.md),
        MenuItemButton(
          key: signOutKey,
          leadingIcon: const Icon(Icons.logout, color: AppColors.error),
          onPressed: onSignOut,
          child: Text(
            l10n.accountMenuSignOut,
            style: AppTypography.bodyMedium.copyWith(color: AppColors.error),
          ),
        ),
      ],
      builder: (context, controller, child) => IconButton(
        key: buttonKey,
        tooltip: l10n.accountMenuTooltip,
        onPressed: () =>
            controller.isOpen ? controller.close() : controller.open(),
        icon: _AccountAvatar(account: account),
      ),
    );
  }
}

String _languageName(AppLocalizations l10n, Locale locale) =>
    locale == AppLocales.english ? l10n.languageEnglish : l10n.languageSpanish;

/// One language of the interface; the current one has a check mark.
class _LanguageItem extends StatelessWidget {
  const _LanguageItem({
    required this.locale,
    required this.label,
    required this.selected,
  });

  final Locale locale;
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    // Read now: the menu calls onPressed after it closed and this entry
    // left the tree.
    final cubit = context.read<LocaleCubit>();
    return MenuItemButton(
      key: AccountMenu.languageKey(locale),
      leadingIcon: Icon(
        Icons.check,
        color: selected ? AppColors.brandPrimary : Colors.transparent,
      ),
      onPressed: () => cubit.select(locale),
      child: Semantics(
        selected: selected,
        child: Text(
          label,
          style: selected
              ? AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)
              : AppTypography.bodyMedium,
        ),
      ),
    );
  }
}

/// Non-interactive title of a group of menu entries.
class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.xs,
        AppSpacing.md,
        AppSpacing.xxs,
      ),
      child: Text(
        text.toUpperCase(),
        style: AppTypography.label.copyWith(color: AppColors.textSecondary),
      ),
    );
  }
}

/// Google picture of the user over a disc with their initials, which stay
/// visible when there is no picture or it cannot be loaded. Decorative for
/// screen readers: the button's tooltip names it.
class _AccountAvatar extends StatelessWidget {
  const _AccountAvatar({required this.account});

  final ShellAccount? account;

  @override
  Widget build(BuildContext context) {
    final account = this.account;
    final url = account?.pictureUrl;
    final initials = account?.initials ?? '';
    return ExcludeSemantics(
      child: CircleAvatar(
        radius: AccountMenu.avatarRadius,
        backgroundColor: AppColors.brandPrimary,
        foregroundImage: url == null ? null : NetworkImage(url),
        onForegroundImageError: url == null ? null : _keepInitials,
        child: initials.isEmpty
            ? const Icon(Icons.person, color: AppColors.textOnBrand)
            : Text(
                initials,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textOnBrand,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  /// A picture that fails to load is not drawn, so the initials show.
  static void _keepInitials(Object error, StackTrace? stackTrace) {}
}

/// Name and email of the signed-in user; information only, not a menu
/// action, so it never takes the keyboard focus.
class _AccountHeader extends StatelessWidget {
  const _AccountHeader({required this.account});

  final ShellAccount account;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: AccountMenu.headerKey,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        0,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: AccountMenu.headerMaxWidth,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              account.name,
              style: AppTypography.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              account.email,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
