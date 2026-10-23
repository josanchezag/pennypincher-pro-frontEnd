import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/core/crud/presentation/widget/item_form_sheet.dart';
import 'package:pennypincher_pro/core/utils/currency_formatter.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/widgets/stat_card.dart';

/// Shared steps of the list screen widget tests.

Finder fieldLabeled(String label) => find.widgetWithText(TextField, label);

StatCard statCard(WidgetTester tester, String label) => tester
    .widgetList<StatCard>(find.byType(StatCard))
    .singleWhere((card) => card.label == label);

/// Expects the [StatCard] labelled [label] to show [amount].
void expectStat(WidgetTester tester, String label, Money amount) =>
    expect(statCard(tester, label).value, CurrencyFormatter.format(amount));

/// An amount inside a tile's labelled details.
Finder labeledAmount(Money amount) => find.textContaining(
      CurrencyFormatter.format(amount),
      findRichText: true,
    );

double topOf(WidgetTester tester, Finder finder) =>
    tester.getTopLeft(finder).dy;

/// Types [values] into the sheet fields with those labels and saves.
Future<void> fillAndSave(
  WidgetTester tester,
  Map<String, String> values,
) async {
  for (final entry in values.entries) {
    await tester.enterText(fieldLabeled(entry.key), entry.value);
  }
  await tester.tap(find.byKey(ItemFormSheet.saveKey));
  await tester.pump();
}

/// Plays a save that fails on the server after it started.
Future<void> failSave<T>(
  WidgetTester tester,
  StreamController<CrudState<T>> states,
  List<T> items,
) async {
  states
    ..add(CrudLoaded(items, busy: true))
    ..add(
      CrudLoaded(
        items,
        errorMessage: 'Validation failed',
        failedAction: CrudAction.save,
      ),
    );
  await tester.pumpAndSettle();
  expect(find.byKey(ItemFormSheet.errorKey), findsOneWidget);
}
