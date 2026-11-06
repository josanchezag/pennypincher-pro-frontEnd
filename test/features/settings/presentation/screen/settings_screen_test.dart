import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/utils/app_currency.dart';
import 'package:pennypincher_pro/core/utils/money_formatter.dart';
import 'package:pennypincher_pro/core/widgets/money_format_scope.dart';
import 'package:pennypincher_pro/features/settings/presentation/screen/settings_screen.dart';
import 'package:pennypincher_pro/features/settings/presentation/widget/currency_options.dart';
import 'package:pennypincher_pro/features/settings/presentation/widget/language_options.dart';
import 'package:pennypincher_pro/features/settings/presentation/widget/settings_section.dart';

import '../../../../helpers/l10n.dart';
import '../../../../helpers/pump_app.dart';
import '../../../../helpers/settings_fakes.dart';

Finder _option(Locale locale) => find.byKey(LanguageOptions.optionKey(locale));

RadioListTile<Locale> _tile(WidgetTester tester, Locale locale) =>
    tester.widget<RadioListTile<Locale>>(_option(locale));

Finder _currency(AppCurrency currency) =>
    find.byKey(CurrencyOptions.optionKey(currency));

RadioListTile<AppCurrency> _currencyTile(
  WidgetTester tester,
  AppCurrency currency,
) =>
    tester.widget<RadioListTile<AppCurrency>>(_currency(currency));

/// The formatter the screens below the app use right now.
MoneyFormatter _appMoney(WidgetTester tester) =>
    MoneyFormatScope.of(tester.element(find.byType(SettingsScreen)));

void main() {
  Future<FakePreferencesRepository> pumpSettings(
    WidgetTester tester, {
    String language = 'en',
    AppCurrency currency = AppCurrency.cop,
    Size size = TestViewports.desktop,
  }) async {
    final account =
        FakePreferencesRepository(savedPreferences(language, currency));
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
      expect(find.text(l10nEs.settingsCurrencyDescription), findsOneWidget);
      for (final section in tester.widgetList(find.byType(SettingsSection))) {
        expect(
          tester.getSize(find.byWidget(section)).width,
          lessThanOrEqualTo(SettingsScreen.maxWidth),
        );
      }
    });
  }

  group('currency', () {
    Future<void> choose(WidgetTester tester, AppCurrency currency) async {
      await tester.ensureVisible(_currency(currency));
      await tester.pumpAndSettle();
      await tester.tap(_currency(currency));
      await tester.pumpAndSettle();
    }

    testWidgets('lists the three currencies with an example of each',
        (tester) async {
      await pumpSettings(tester);

      expect(find.text(l10n.settingsCurrencyTitle), findsOneWidget);
      expect(find.text(l10n.settingsCurrencyDescription), findsOneWidget);
      expect(find.text(l10n.currencyCop), findsOneWidget);
      expect(find.text(l10n.currencyUsd), findsOneWidget);
      expect(find.text(l10n.currencyEur), findsOneWidget);
      expect(find.text('For example, COP\u00A01,234,568'), findsOneWidget);
      expect(find.text(r'For example, $1,234,567.50'), findsOneWidget);
      expect(find.text('For example, €1,234,567.50'), findsOneWidget);
      expect(_currencyTile(tester, AppCurrency.cop).checked, isTrue);
      expect(_currencyTile(tester, AppCurrency.usd).checked, isFalse);
    });

    testWidgets('names the currencies in Spanish for a Spanish account',
        (tester) async {
      await pumpSettings(tester, language: 'es', currency: AppCurrency.eur);

      expect(find.text('COP – Peso colombiano'), findsOneWidget);
      expect(find.text('USD – Dólar estadounidense'), findsOneWidget);
      expect(find.text('EUR – Euro'), findsOneWidget);
      expect(find.text('Por ejemplo, \$\u00A01.234.568'), findsOneWidget);
      expect(find.text('Por ejemplo, US\$\u00A01.234.567,50'), findsOneWidget);
      expect(find.text('Por ejemplo, 1.234.567,50\u00A0€'), findsOneWidget);
      expect(_currencyTile(tester, AppCurrency.eur).checked, isTrue);
      expect(_appMoney(tester).currency, AppCurrency.eur);
    });

    testWidgets('applies a currency to the whole app and saves only it',
        (tester) async {
      final account = await pumpSettings(tester);

      await choose(tester, AppCurrency.usd);

      expect(_currencyTile(tester, AppCurrency.usd).checked, isTrue);
      expect(_appMoney(tester).currency, AppCurrency.usd);
      expect(_appMoney(tester).languageCode, 'en');
      expect(account.saves.single.currency, AppCurrency.usd);
      expect(account.saves.single.languageCode, isNull);
      expect(account.stored, savedPreferences('en', AppCurrency.usd));
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('follows the interface language in the formats',
        (tester) async {
      await pumpSettings(tester, currency: AppCurrency.usd);

      await tester.tap(_option(AppLocales.spanish));
      await tester.pumpAndSettle();

      expect(_appMoney(tester).languageCode, 'es');
      expect(_appMoney(tester).currency, AppCurrency.usd);
    });

    testWidgets('restores the currency and says why when saving fails',
        (tester) async {
      final account = await pumpSettings(tester, currency: AppCurrency.eur);
      account.saveFailure = offline;

      await choose(tester, AppCurrency.usd);

      expect(find.text(l10n.settingsCurrencySaveFailed), findsOneWidget);
      expect(find.text(l10n.settingsLanguageSaveFailed), findsNothing);
      expect(_currencyTile(tester, AppCurrency.eur).checked, isTrue);
      expect(_appMoney(tester).currency, AppCurrency.eur);
      expect(account.stored, savedPreferences('en', AppCurrency.eur));
    });

    testWidgets('waits for a save before taking another change',
        (tester) async {
      final account = await pumpSettings(tester);
      account.pendingSave = Completer<void>();
      await tester.ensureVisible(_currency(AppCurrency.eur));
      await tester.pumpAndSettle();

      await tester.tap(_currency(AppCurrency.eur));
      await tester.pump();

      final busy = find.descendant(
        of: find.byType(SettingsSection),
        matching: find.byType(CircularProgressIndicator),
      );
      expect(busy, findsOneWidget);
      expect(
        tester.widget(
          find.ancestor(of: busy, matching: find.byType(SettingsSection)),
        ),
        tester.widget(
          find.ancestor(
            of: _currency(AppCurrency.eur),
            matching: find.byType(SettingsSection),
          ),
        ),
      );
      expect(_currencyTile(tester, AppCurrency.usd).onChanged, isNull);
      expect(_tile(tester, AppLocales.spanish).onChanged, isNull);
      account.pendingSave!.complete();
      await tester.pumpAndSettle();

      expect(account.saves.map((saved) => saved.currency), [AppCurrency.eur]);
      expect(_currencyTile(tester, AppCurrency.usd).onChanged, isNotNull);
    });
  });
}
