import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/l10n/locale_cubit.dart';
import 'package:pennypincher_pro/features/settings/domain/entity/user_preferences_entity.dart';
import 'package:pennypincher_pro/features/settings/presentation/cubit/preferences_cubit.dart';

import '../../../../helpers/l10n.dart';
import '../../../../helpers/settings_fakes.dart';

void main() {
  late MemoryLocaleStore store;
  late LocaleCubit locale;
  late FakePreferencesRepository account;

  /// A device that remembers [remembered] (nothing by default) and an
  /// account that holds [stored].
  PreferencesCubit build({
    String? remembered,
    UserPreferences stored = defaultPreferences,
  }) {
    store = MemoryLocaleStore(remembered);
    locale = LocaleCubit(store);
    account = FakePreferencesRepository(stored);
    final cubit = preferencesCubit(account, locale, store);
    addTearDown(cubit.close);
    addTearDown(locale.close);
    return cubit;
  }

  tearDown(() => Intl.defaultLocale = testLocale.languageCode);

  group('before sign-in', () {
    test('uses the language remembered on this device', () {
      final cubit = build(remembered: 'en');

      expect(cubit.state.language, AppLocales.english);
      expect(cubit.state.status, PreferencesStatus.initial);
    });

    test('uses Spanish when nothing is remembered', () {
      expect(build().state.language, AppLocales.spanish);
    });
  });

  group('load', () {
    test('applies the language saved in the account', () async {
      final cubit = build(remembered: 'es', stored: savedPreferences('en'));

      await cubit.load();

      expect(cubit.state.status, PreferencesStatus.ready);
      expect(cubit.state.language, AppLocales.english);
      expect(locale.state, AppLocales.english);
      expect(store.languageCode, 'en');
      expect(Intl.defaultLocale, 'en');
      expect(account.saves, isEmpty);
    });

    test('reports loading while the request runs', () async {
      final cubit = build(stored: savedPreferences('es'));
      final states = <PreferencesStatus>[];
      final subscription =
          cubit.stream.listen((state) => states.add(state.status));
      addTearDown(subscription.cancel);

      await cubit.load();
      await Future<void>.delayed(Duration.zero);

      expect(states, [PreferencesStatus.loading, PreferencesStatus.ready]);
    });

    test('keeps and saves the device language of a user who never saved one',
        () async {
      final cubit = build(remembered: 'en');

      await cubit.load();

      expect(cubit.state.language, AppLocales.english);
      expect(cubit.state.saving, isFalse);
      expect(account.saves.single.languageCode, 'en');
      expect(account.stored, savedPreferences('en'));
    });

    test('applies the defaults when the device has no choice either', () async {
      final cubit = build();

      await cubit.load();

      expect(cubit.state.language, AppLocales.spanish);
      expect(account.saves, isEmpty);
    });

    test('keeps the device language when the account cannot be reached',
        () async {
      final cubit = build(remembered: 'en', stored: savedPreferences('es'));
      account.loadFailure = offline;

      await cubit.load();

      expect(cubit.state.status, PreferencesStatus.loadFailed);
      expect(cubit.state.language, AppLocales.english);
      expect(locale.state, AppLocales.english);
    });

    test('ignores an account language the interface does not have', () async {
      final cubit = build(remembered: 'en', stored: savedPreferences('fr'));

      await cubit.load();

      expect(cubit.state.status, PreferencesStatus.ready);
      expect(cubit.state.language, AppLocales.english);
    });

    test('drops a load that a sign-out made obsolete', () async {
      final cubit = build(remembered: 'es', stored: savedPreferences('en'));

      final loading = cubit.load();
      cubit.reset();
      await loading;

      expect(cubit.state.status, PreferencesStatus.initial);
      expect(cubit.state.language, AppLocales.spanish);
    });
  });

  group('changeLanguage', () {
    test('applies the language at once and saves it', () async {
      final cubit = build(stored: savedPreferences('es'));
      await cubit.load();
      account.pendingSave = Completer<void>();

      final saving = cubit.changeLanguage(AppLocales.english);

      expect(cubit.state.language, AppLocales.english);
      expect(cubit.state.saving, isTrue);
      expect(locale.state, AppLocales.english);
      account.pendingSave!.complete();
      await saving;

      expect(cubit.state.saving, isFalse);
      expect(cubit.state.saveError, isNull);
      expect(account.stored, savedPreferences('en'));
      expect(store.languageCode, 'en');
    });

    test('brings the previous language back when saving fails', () async {
      final cubit = build(stored: savedPreferences('es'));
      await cubit.load();
      account.saveFailure = offline;

      await cubit.changeLanguage(AppLocales.english);

      expect(cubit.state.language, AppLocales.spanish);
      expect(cubit.state.saving, isFalse);
      expect(cubit.state.saveError, offline);
      expect(locale.state, AppLocales.spanish);
      expect(store.languageCode, 'es');
      expect(Intl.defaultLocale, 'es');
    });

    test('reports every failed save, and clears it on the next change',
        () async {
      final cubit = build(stored: savedPreferences('es'));
      account.saveFailure = offline;
      await cubit.changeLanguage(AppLocales.english);
      final first = cubit.state;

      account.saveFailure = null;
      await cubit.changeLanguage(AppLocales.english);

      expect(first.saveError, offline);
      expect(cubit.state.saveError, isNull);
      expect(cubit.state.language, AppLocales.english);
    });

    test('ignores the current language, unknown ones and changes while saving',
        () async {
      final cubit = build(stored: savedPreferences('es'));
      account.pendingSave = Completer<void>();

      await cubit.changeLanguage(AppLocales.spanish);
      await cubit.changeLanguage(const Locale('fr'));
      final saving = cubit.changeLanguage(AppLocales.english);
      await cubit.changeLanguage(AppLocales.spanish);
      account.pendingSave!.complete();
      await saving;

      expect(account.saves.map((saved) => saved.languageCode), ['en']);
      expect(cubit.state.language, AppLocales.english);
    });

    test('also saves before the account was loaded', () async {
      final cubit = build();

      await cubit.changeLanguage(AppLocales.english);

      expect(account.stored, savedPreferences('en'));
    });
  });

  test('reset forgets the account but keeps the interface language', () async {
    final cubit = build(stored: savedPreferences('en'));
    await cubit.load();

    cubit.reset();

    expect(cubit.state.status, PreferencesStatus.initial);
    expect(cubit.state.language, AppLocales.english);
    expect(locale.state, AppLocales.english);
  });
}
