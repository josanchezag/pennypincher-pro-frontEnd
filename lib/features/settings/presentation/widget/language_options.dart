import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';

/// One choice per interface language, each written in its own language so
/// anyone can find theirs. [onSelected] is `null` while a change is saved.
class LanguageOptions extends StatelessWidget {
  const LanguageOptions({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  /// Option of [locale], for tests and screen captures.
  static Key optionKey(Locale locale) =>
      Key('settings-language-${locale.languageCode}');

  final Locale selected;
  final ValueChanged<Locale>? onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final onSelected = this.onSelected;
    return Column(
      children: [
        for (final locale in AppLocales.supported)
          RadioListTile<Locale>(
            key: optionKey(locale),
            value: locale,
            groupValue: selected,
            contentPadding: EdgeInsets.zero,
            onChanged: onSelected == null
                ? null
                : (value) => value == null ? null : onSelected(value),
            title: Text(
              locale == AppLocales.english
                  ? l10n.languageEnglish
                  : l10n.languageSpanish,
              style: AppTypography.bodyLarge,
            ),
          ),
      ],
    );
  }
}
