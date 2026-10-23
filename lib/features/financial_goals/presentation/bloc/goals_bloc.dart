import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/crud/domain/usecase/crud_use_cases.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/financial_goal_entity.dart';

/// State of the goals screen: the goals with their projections, reloaded
/// after every change so a new monthly investment moves the projected date
/// at once, and the standard goals on request. A new instance is created
/// per screen.
@injectable
class GoalsBloc extends CrudBloc<FinancialGoal, GoalDraft> {
  GoalsBloc(
    super.getItems,
    super.saveItem,
    super.deleteItem,
    CreateDefaultItems<FinancialGoal> createDefaults,
  ) : super(createDefaults: createDefaults, reloadAfterChange: true);
}
