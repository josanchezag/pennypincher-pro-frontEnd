import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/crud/domain/crud_repository.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/income_source_entity.dart';

/// The user's recurring income sources.
abstract interface class IncomeSourceRepository
    implements CrudRepository<IncomeSource, CategorizedDraft<IncomeCategory>> {}
