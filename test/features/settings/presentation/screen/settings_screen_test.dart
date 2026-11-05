import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/features/settings/presentation/screen/settings_screen.dart';
import 'package:pennypincher_pro/features/settings/presentation/widget/language_options.dart';
import 'package:pennypincher_pro/features/settings/presentation/widget/settings_section.dart';

import '../../../../helpers/l10n.dart';
import '../../../../helpers/pump_app.dart';
import '../../../../helpers/settings_fakes.dart';

Finder _option(Locale locale) => find.byKey(LanguageOptions.optionKey(locale));

RadioListTile<Locale> _tile(WidgetTester tester, Locale locale) =>
    tester.widget<RadioListTile<Locale>>(_option(locale));

void main() {
  Future<FakePreferencesRepository> pumpSettings(
    WidgetTester tester, {
    String language = 'en',
    Size size = TestViewports.desktop,
  }) async {
    final account = FakePreferencesRepository(savedPreferences(language));
    await tester.pumpApp(
      location: AppRoute.settings.path,
      size: size,
      locale: Locale(language),
      preferences: account,
    );
    return account;
  }

  testWidgets('shows the language section with the current one chosen',
      (tester) async {
    await pumpSettings(tester);

    expect(find.text(l10n.routeSettings), findsWidgets);
    expect(find.text(l10n.settingsIntro), findsOneWidget);
    expect(find.text(l10n.settingsLanguageTitle), findsOneWidget);
    expect(find.text(l10n.settingsLanguageDescription), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(find.text('Español'), findsOneWidget);
    expect(_tile(tester, AppLocales.english).checked, isTrue);
    expect(_tile(tester, AppLocales.spanish).checked, isFalse);
    expect(find.byKey(SettingsScreen.loadFailedKey), findsNothing);
  });

  testWidgets('is in Spanish for a Spanish account', (tester) async {
    await pumpSettings(tester, language: 'es');

    expect(find.text(l10nEs.settingsIntro), findsOneWidget);
    expect(find.text(l10nEs.settingsLanguageTitle), findsOneWidget);
    expect(_tile(tester, AppLocales.spanish).checked, isTrue);
  });

  testWidgets('switches the whole interface and saves the choice',
      (tester) async {
    final account = await pumpSettings(tester);

    await tester.tap(_option(AppLocales.spanish));
    await tester.pumpAndSettle();

    expect(find.text(l10nEs.settingsLanguageTitle), findsOneWidget);
    expect(find.text(l10nEs.routeDashboard), findsWidgets);
    expect(_tile(tester, AppLocales.spanish).checked, isTrue);
    expect(account.stored, savedPreferences('es'));
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('waits for a save before taking another change', (tester) async {
    final account = await pumpSettings(tester);
    account.pendingSave = Completer<void>();

    await tester.tap(_option(AppLocales.spanish));
    await tester.pump();

    expect(
      find.descendant(
        of: find.byType(SettingsSection),
        matching: find.byType(CircularProgressIndicator),
      ),
      findsOneWidget,
    );
    expect(_tile(tester, AppLocales.english).onChanged, isNull);
    await tester.tap(_option(AppLocales.english));
    account.pendingSave!.complete();
    await tester.pumpAndSettle();

    expect(account.saves.map((saved) => saved.languageCode), ['es']);
    expect(_tile(tester, AppLocales.spanish).checked, isTrue);
    expect(_tile(tester, AppLocales.english).onChanged, isNotNull);
  });

  testWidgets('restores the language and says why when saving fails',
      (tester) async {
    final account = await pumpSettings(tester);
    account.saveFailure = offline;

    await tester.tap(_option(AppLocales.spanish));
    await tester.pumpAndSettle();

    expect(find.text(l10n.settingsLanguageSaveFailed), findsOneWidget);
    expect(find.text(l10n.settingsLanguageTitle), findsOneWidget);
    expect(_tile(tester, AppLocales.english).checked, isTrue);
    expect(account.stored, savedPreferences('en'));
  });

  testWidgets('says so when the saved settings cannot be loaded',
      (tester) async {
    final account = FakePreferencesRepository(savedPreferences('en'))
      ..loadFailure = offline;
    await tester.pumpApp(
      location: AppRoute.settings.path,
      preferences: account,
    );

    expect(find.byKey(SettingsScreen.loadFailedKey), findsOneWidget);
    expect(find.text(l10n.settingsLoadFailed), findsOneWidget);
    expect(_tile(tester, AppLocales.english).onChanged, isNotNull);

    account.loadFailure = null;
    await tester.tap(find.byKey(SettingsScreen.retryKey));
    await tester.pumpAndSettle();

    expect(find.byKey(SettingsScreen.loadFailedKey), findsNothing);
    expect(account.loads, 2);
  });

  for (final size in [const Size(390, 844), TestViewports.desktop]) {
    testWidgets('fits a ${size.width.toInt()} px wide screen in both languages',
        (tester) async {
      await pumpSettings(tester, size: size);
      await tester.tap(_option(AppLocales.spanish));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text(l10nEs.settingsLanguageDescription), findsOneWidget);
      expect(
        tester.getSize(find.byType(SettingsSection)).width,
        lessThanOrEqualTo(SettingsScreen.maxWidth),
      );
    });
  }
}
