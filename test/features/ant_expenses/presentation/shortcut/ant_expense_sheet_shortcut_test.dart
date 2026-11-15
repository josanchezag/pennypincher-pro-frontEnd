import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/crud/domain/usecase/crud_use_cases.dart';
import 'package:pennypincher_pro/core/crud/presentation/widget/item_form_sheet.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/core/time/clock.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/ant_expenses/domain/entity/ant_expense_entity.dart';
import 'package:pennypincher_pro/features/ant_expenses/domain/repository/ant_expense_repository.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/ant_expense_sheet_shortcut.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/widget/ant_expense_form.dart';

import '../../../../helpers/ant_fixtures.dart';
import '../../../../helpers/crud_screen_helpers.dart';
import '../../../../helpers/l10n.dart';

class _MockRepository extends Mock implements AntExpenseRepository {}

class _FixedClock implements Clock {
  _FixedClock(this.value);

  final DateTime value;

  @override
  DateTime now() => value;
}

const Key _openKey = Key('open-sheet');

void main() {
  late _MockRepository repository;
  late AntExpenseSheetShortcut shortcut;

  // Late in the evening: the local day, not the UTC one, is today.
  final now = DateTime(2026, 11, 5, 23, 30);
  final draft = AntExpenseDraft(
    amount: const Money.fromUnits(4200),
    category: AntExpenseCategory.coffeeAndDrinks,
    spentOn: antToday,
  );

  setUpAll(() => registerFallbackValue(draft));

  setUp(() {
    repository = _MockRepository();
    shortcut = AntExpenseSheetShortcut(
      GetItems(repository),
      SaveItem(repository),
      DeleteItem(repository),
      _FixedClock(now),
    );
  });

  /// Pumps a button that opens the sheet and returns the results the
  /// sheet resolved to.
  Future<List<bool>> pumpOpener(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final results = <bool>[];
    await tester.pumpWidget(
      localizedApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              key: _openKey,
              onPressed: () async =>
                  results.add(await shortcut.addExpense(context)),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.byKey(_openKey));
    await tester.pumpAndSettle();
    return results;
  }

  Future<void> fillAndSave(WidgetTester tester) async {
    await tester.enterText(fieldLabeled(l10n.antAmountLabel), '4200');
    await tester.tap(find.text(l10n.antCategoryCoffeeAndDrinks).last);
    await tester.tap(find.byKey(ItemFormSheet.saveKey));
    await tester.pumpAndSettle();
  }

  testWidgets('opens the ant expense form for today without loading the list',
      (tester) async {
    await pumpOpener(tester);

    expect(find.text(l10n.antAdd), findsOneWidget);
    expect(find.byKey(AntExpenseForm.amountKey), findsOneWidget);
    expect(find.byKey(AntExpenseForm.dateKey), findsOneWidget);
    expect(find.text(l10n.antToday), findsOneWidget);
    expect(find.byKey(ItemFormSheet.deleteKey), findsNothing);
    verifyNever(repository.getAll);
  });

  testWidgets('keeps the validations of the ant expenses screen',
      (tester) async {
    await pumpOpener(tester);

    await tester.tap(find.byKey(ItemFormSheet.saveKey));
    await tester.pumpAndSettle();

    expect(find.text(l10n.crudAmountRequired), findsOneWidget);
    expect(find.text(l10n.crudCategoryRequired), findsOneWidget);
    verifyNever(() => repository.create(any()));
  });

  testWidgets('saves with the local day, closes and resolves to true',
      (tester) async {
    when(() => repository.create(any())).thenAnswer((_) async => Right(coffee));
    final results = await pumpOpener(tester);

    await fillAndSave(tester);

    verify(() => repository.create(draft)).called(1);
    verifyNever(repository.getAll);
    expect(find.byKey(ItemFormSheet.saveKey), findsNothing);
    expect(results, [true]);
  });

  testWidgets('keeps the sheet open with the error when the save fails',
      (tester) async {
    when(() => repository.create(any()))
        .thenAnswer((_) async => const Left(NetworkFailure('Offline')));
    final results = await pumpOpener(tester);

    await fillAndSave(tester);

    expect(find.byKey(ItemFormSheet.saveKey), findsOneWidget);
    expect(find.byKey(ItemFormSheet.errorKey), findsOneWidget);
    expect(find.text('Offline'), findsOneWidget);
    expect(results, isEmpty);

    // Closing it afterwards reports that nothing was saved.
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
    expect(results, [false]);
  });

  testWidgets('resolves to false when closed without saving', (tester) async {
    final results = await pumpOpener(tester);

    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();

    expect(results, [false]);
    verifyNever(() => repository.create(any()));
  });
}
