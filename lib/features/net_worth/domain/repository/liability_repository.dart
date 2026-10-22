import 'package:pennypincher_pro/core/crud/domain/crud_repository.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/liability_entity.dart';

/// The user's debts.
abstract interface class LiabilityRepository
    implements CrudRepository<Liability, LiabilityCategory> {}
