import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/crud/data/crud_repository_impl.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/features/budget/data/datasource/income_source_remote_datasource.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/income_source_entity.dart';
import 'package:pennypincher_pro/features/budget/domain/repository/income_source_repository.dart';

@LazySingleton(as: IncomeSourceRepository)
class IncomeSourceRepositoryImpl
    extends CrudRepositoryImpl<IncomeSource, CategorizedDraft<IncomeCategory>>
    implements IncomeSourceRepository {
  IncomeSourceRepositoryImpl(IncomeSourceRemoteDataSource super.remote);
}
