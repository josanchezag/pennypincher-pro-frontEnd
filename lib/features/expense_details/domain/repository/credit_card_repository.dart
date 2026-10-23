import 'package:pennypincher_pro/core/crud/domain/balance_item.dart';
import 'package:pennypincher_pro/core/crud/domain/crud_repository.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/credit_card_entity.dart';

/// The user's credit cards.
abstract interface class CreditCardRepository
    implements CrudRepository<CreditCard, BalanceDraft> {}
