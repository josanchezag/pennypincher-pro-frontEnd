import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/features/ant_expenses/domain/entity/ant_expense_entity.dart';
import 'package:pennypincher_pro/features/ant_expenses/domain/usecase/ant_expense_use_cases.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/bloc/ant_cut_items_cubit.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/bloc/ant_section.dart';

import '../../../../helpers/ant_fixtures.dart';

class _MockGetItems extends Mock implements GetAntCutItems {}

void main() {
  late _MockGetItems getItems;

  setUp(() => getItems = _MockGetItems());

  blocTest<AntCutItemsCubit, AntSection<List<AntExpense>>>(
    'loads the expenses of one cut',
    setUp: () => when(() => getItems(octoberBudgetId))
        .thenAnswer((_) async => Right([octoberSnack])),
    build: () => AntCutItemsCubit(getItems),
    act: (cubit) => cubit.load(octoberBudgetId),
    expect: () => [
      const AntSectionLoading<List<AntExpense>>(),
      AntSectionLoaded([octoberSnack]),
    ],
  );

  blocTest<AntCutItemsCubit, AntSection<List<AntExpense>>>(
    'reports a failure that can be retried',
    setUp: () => when(() => getItems(octoberBudgetId))
        .thenAnswer((_) async => const Left(NotFoundFailure('Gone'))),
    build: () => AntCutItemsCubit(getItems),
    act: (cubit) => cubit.load(octoberBudgetId),
    expect: () => [
      const AntSectionLoading<List<AntExpense>>(),
      const AntSectionFailure<List<AntExpense>>('Gone'),
    ],
  );

  test('a section only has a value once loaded', () {
    expect(const AntSectionLoading<int>().valueOrNull, isNull);
    expect(const AntSectionFailure<int>('x').valueOrNull, isNull);
    expect(const AntSectionLoaded(3).valueOrNull, 3);
  });
}
