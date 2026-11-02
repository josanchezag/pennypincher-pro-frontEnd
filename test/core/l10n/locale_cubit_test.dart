import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/l10n/locale_cubit.dart';
import 'package:pennypincher_pro/core/time/month_format.dart';

import '../../helpers/l10n.dart';

void main() {
  tearDown(() => Intl.defaultLocale = testLocale.languageCode);

  test('starts in Spanish when nothing was picked', () {
    final cubit = LocaleCubit(MemoryLocaleStore());
    addTearDown(cubit.close);

    expect(cubit.state, AppLocales.spanish);
    expect(Intl.defaultLocale, 'es');
  });

  test('starts in the language picked last', () {
    final cubit = LocaleCubit(MemoryLocaleStore('en'));
    addTearDown(cubit.close);

    expect(cubit.state, AppLocales.english);
    expect(Intl.defaultLocale, 'en');
  });

  test('falls back to Spanish when the stored language is not supported', () {
    final cubit = LocaleCubit(MemoryLocaleStore('fr'));
    addTearDown(cubit.close);

    expect(cubit.state, AppLocales.spanish);
  });

  final store = MemoryLocaleStore();
  blocTest<LocaleCubit, Locale>(
    'switches the language and remembers it',
    setUp: () => store.languageCode = null,
    build: () => LocaleCubit(store),
    act: (cubit) => cubit.select(AppLocales.english),
    expect: () => [AppLocales.english],
    verify: (_) {
      expect(store.languageCode, 'en');
      expect(Intl.defaultLocale, 'en');
      expect(MonthFormat.long.format(DateTime(2026, 10)), 'October 2026');
    },
  );

  blocTest<LocaleCubit, Locale>(
    'names the months in Spanish after switching back',
    build: () => LocaleCubit(MemoryLocaleStore('en')),
    act: (cubit) => cubit.select(AppLocales.spanish),
    expect: () => [AppLocales.spanish],
    verify: (_) => expect(
      MonthFormat.long.format(DateTime(2026, 10)),
      'octubre 2026',
    ),
  );

  blocTest<LocaleCubit, Locale>(
    'ignores languages the interface does not have',
    build: () => LocaleCubit(MemoryLocaleStore('en')),
    act: (cubit) => cubit.select(const Locale('fr')),
    expect: () => <Locale>[],
  );

  test('gives the texts of the current language outside widgets', () {
    Intl.defaultLocale = 'es';
    expect(CurrentL10n.texts.commonRetry, l10nEs.commonRetry);

    Intl.defaultLocale = 'en_US';
    expect(CurrentL10n.texts.commonRetry, l10n.commonRetry);
  });
}
