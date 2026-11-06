import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/crud/domain/usecase/crud_use_cases.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/core/error/error_codes.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/ant_expenses/domain/entity/ant_expense_entity.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/bloc/ant_expense_bloc.dart';

import '../../../../helpers/ant_fixtures.dart';

class _MockGetItems extends Mock
    implements GetItems<AntExpense, AntExpenseDraft> {}

class _MockSaveItem extends Mock
    implements SaveItem<AntExpense, AntExpenseDraft> {}

class _MockDeleteItem extends Mock
    implements DeleteItem<AntExpense, AntExpenseDraft> {}

void main() {
  late _MockGetItems getItems;
  late _MockSaveItem saveItem;
  late _MockDeleteItem deleteItem;

  final draft = AntExpenseDraft(
    amount: const Money.fromUnits(9000),
    category: AntExpenseCategory.fastFood,
    spentOn: DateTime(2026, 11, 4),
  );

  setUpAll(() => registerFallbackValue(draft));

  setUp(() {
    getItems = _MockGetItems();
    saveItem = _MockSaveItem();
    deleteItem = _MockDeleteItem();
    when(() => getItems()).thenAnswer((_) async => Right(openExpenses));
  });

  AntExpenseBloc buildBloc() => AntExpenseBloc(getItems, saveItem, deleteItem);

  blocTest<AntExpenseBloc, CrudState<AntExpense>>(
    'reloads the period after adding an expense, in the backend order',
    setUp: () => when(() => saveItem(any(), id: any(named: 'id')))
        .thenAnswer((_) async => Right(empanadas)),
    build: buildBloc,
    seed: () => CrudLoaded([taxi, coffee]),
    act: (bloc) => bloc.add(CrudSaveRequested(draft)),
    expect: () => [
      CrudLoaded([taxi, coffee], busy: true),
      CrudLoaded(openExpenses),
    ],
    verify: (_) => verify(() => getItems()).called(1),
  );

  blocTest<AntExpenseBloc, CrudState<AntExpense>>(
    'keeps an expense another cut already took',
    setUp: () => when(() => deleteItem('ae-1')).thenAnswer(
      (_) async => const Left(
        ServerFailure('Already cut', code: ErrorCodes.antExpenseAlreadyCut),
      ),
    ),
    build: buildBloc,
    seed: () => CrudLoaded(openExpenses),
    act: (bloc) => bloc.add(const CrudDeleteRequested('ae-1')),
    expect: () => [
      CrudLoaded(openExpenses, busy: true),
      CrudLoaded(
        openExpenses,
        errorMessage: 'Already cut',
        failedAction: CrudAction.delete,
      ),
    ],
  );
}
