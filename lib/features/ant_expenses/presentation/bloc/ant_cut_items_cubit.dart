import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/features/ant_expenses/domain/entity/ant_expense_entity.dart';
import 'package:pennypincher_pro/features/ant_expenses/domain/usecase/ant_expense_use_cases.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/bloc/ant_section.dart';

/// The expenses one past cut took, read only. A new instance is created
/// each time a cut is opened.
@injectable
class AntCutItemsCubit extends Cubit<AntSection<List<AntExpense>>> {
  AntCutItemsCubit(this._getItems) : super(const AntSectionLoading());

  final GetAntCutItems _getItems;

  /// Loads, or loads again, the expenses of the budget [budgetId].
  Future<void> load(String budgetId) async {
    emit(const AntSectionLoading());
    final result = await _getItems(budgetId);
    if (isClosed) {
      return;
    }
    emit(
      result.fold(
        (failure) => AntSectionFailure(failure.message),
        AntSectionLoaded.new,
      ),
    );
  }
}
