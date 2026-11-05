import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:pennypincher_pro/core/l10n/document_language.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/l10n/locale_store.dart';

/// Language of the interface: the one picked last on this device, Spanish
/// otherwise. Also sets [Intl.defaultLocale], so dates follow it, and the
/// language of the page. The account's language is applied on sign-in by
/// `PreferencesCubit`.
@lazySingleton
class LocaleCubit extends Cubit<Locale> {
  LocaleCubit(this._store) : super(_initial(_store)) {
    _applyToIntl(state);
  }

  final LocaleStore _store;

  static Locale _initial(LocaleStore store) =>
      AppLocales.forLanguageCode(store.read()) ?? AppLocales.fallback;

  /// Switches the interface to [locale] and remembers the choice.
  void select(Locale locale) {
    final supported = AppLocales.forLanguageCode(locale.languageCode);
    if (supported == null) {
      return;
    }
    _store.write(supported.languageCode);
    _applyToIntl(supported);
    emit(supported);
  }

  static void _applyToIntl(Locale locale) {
    Intl.defaultLocale = locale.languageCode;
    setDocumentLanguage(locale.languageCode);
  }
}
