import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/crud/domain/usecase/crud_use_cases.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/core/crud/presentation/widget/item_form_sheet.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/shortcuts/ant_expense_shortcut.dart';
import 'package:pennypincher_pro/core/time/clock.dart';
import 'package:pennypincher_pro/core/time/day_format.dart';
import 'package:pennypincher_pro/features/ant_expenses/domain/entity/ant_expense_entity.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/widget/ant_expense_form.dart';

/// Opens the add sheet of the ant expenses screen ([AntExpenseForm] in an
/// [ItemFormSheet]) anywhere in the app. It saves through the same use
/// case and repository, with a bloc of its own that does not load the
/// list first and is closed with the sheet. The day starts at the
/// device's local today.
@LazySingleton(as: AntExpenseShortcut)
class AntExpenseSheetShortcut implements AntExpenseShortcut {
  AntExpenseSheetShortcut(
    this._getItems,
    this._saveItem,
    this._deleteItem,
    this._clock,
  );

  final GetItems<AntExpense, AntExpenseDraft> _getItems;
  final SaveItem<AntExpense, AntExpenseDraft> _saveItem;
  final DeleteItem<AntExpense, AntExpenseDraft> _deleteItem;
  final Clock _clock;

  @override
  Future<bool> addExpense(BuildContext context) async {
    final bloc = CrudBloc<AntExpense, AntExpenseDraft>(
      _getItems,
      _saveItem,
      _deleteItem,
      startEmpty: true,
    );
    try {
      await ItemFormSheet.show<AntExpense, AntExpenseDraft>(
        context,
        form: AntExpenseForm(today: DayFormat.dayOf(_clock.now())),
        title: context.l10n.antAdd,
        bloc: bloc,
      );
      final state = bloc.state;
      return state is CrudLoaded<AntExpense> && state.items.isNotEmpty;
    } finally {
      // Not awaited: the sheet's listener is still subscribed until its
      // closing animation ends.
      unawaited(bloc.close());
    }
  }
}
