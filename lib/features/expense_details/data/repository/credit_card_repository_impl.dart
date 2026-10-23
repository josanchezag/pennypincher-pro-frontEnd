import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/crud/data/crud_repository_impl.dart';
import 'package:pennypincher_pro/core/crud/domain/balance_item.dart';
import 'package:pennypincher_pro/features/expense_details/data/datasource/credit_card_remote_datasource.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/credit_card_entity.dart';
import 'package:pennypincher_pro/features/expense_details/domain/repository/credit_card_repository.dart';

@LazySingleton(as: CreditCardRepository)
class CreditCardRepositoryImpl
    extends CrudRepositoryImpl<CreditCard, BalanceDraft>
    implements CreditCardRepository {
  CreditCardRepositoryImpl(CreditCardRemoteDataSource super.remote);
}
