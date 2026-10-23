import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/crud/domain/usecase/crud_use_cases.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/financial_goal_entity.dart';

import '../../../helpers/goal_fixtures.dart';

class _MockGet extends Mock implements GetItems<FinancialGoal, GoalDraft> {}

class _MockSave extends Mock implements SaveItem<FinancialGoal, GoalDraft> {}

class _MockDelete extends Mock
    implements DeleteItem<FinancialGoal, GoalDraft> {}

typedef _Bloc = CrudBloc<FinancialGoal, GoalDraft>;
typedef _State = CrudState<FinancialGoal>;

void main() {
  late _MockGet getItems;
  late _MockSave saveItem;

  setUp(() {
    getItems = _MockGet();
    saveItem = _MockSave();
  });

  final draft = GoalDraft(
    name: security.name,
    level: security.level,
    targetAmount: security.targetAmount,
    monthlyInvestment: security.monthlyInvestment,
    expectedAnnualReturn: security.expectedAnnualReturn,
  );

  blocTest<_Bloc, _State>(
    'applies a change locally without reloading by default',
    setUp: () => when(() => saveItem(draft, id: 'g1'))
        .thenAnswer((_) async => Right(security)),
    build: () => CrudBloc(getItems, saveItem, _MockDelete()),
    seed: () => CrudLoaded([independence]),
    act: (bloc) => bloc.add(CrudSaveRequested(draft, id: 'g1')),
    expect: () => [
      CrudLoaded([independence], busy: true),
      CrudLoaded([independence, security]),
    ],
    verify: (_) => verifyNever(getItems.call),
  );

  blocTest<_Bloc, _State>(
    'ignores a request for the standard items without a use case',
    build: () => CrudBloc(getItems, saveItem, _MockDelete()),
    seed: () => const CrudLoaded([]),
    act: (bloc) => bloc.add(const CrudDefaultsRequested()),
    expect: () => <_State>[],
  );
}
