import 'package:pennypincher_pro/core/crud/domain/balance_item.dart';
import 'package:pennypincher_pro/core/crud/domain/crud_repository.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/loan_entity.dart';

/// The user's loans.
abstract interface class LoanRepository
    implements CrudRepository<Loan, BalanceDraft> {}
