import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/expense_summary_entity.dart';
import 'package:pennypincher_pro/features/expense_details/domain/repository/expense_summary_repository.dart';
import 'package:pennypincher_pro/features/expense_details/domain/usecase/get_expense_summary.dart';

import '../../../helpers/expense_fixtures.dart';

class _MockRepository extends Mock implements ExpenseSummaryRepository {}

void main() {
  test('loads the summary of the given list', () async {
    final repository = _MockRepository();
    when(() => repository.getSummary(ExpenseKind.fixedExpenses))
        .thenAnswer((_) async => const Right(fixedSummary));

    final result =
        await GetExpenseSummary(repository)(ExpenseKind.fixedExpenses);

    expect(result, const Right<Failure, ExpenseSummary>(fixedSummary));
  });
}
