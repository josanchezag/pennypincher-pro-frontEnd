import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/expense_summary_entity.dart';
import 'package:pennypincher_pro/features/expense_details/domain/usecase/get_expense_summary.dart';

part 'expenses_hub_event.dart';
part 'expenses_hub_state.dart';

/// State of the expenses hub: the live totals of every expense list, each
/// loaded and retried on its own so one failing list never hides the
/// others. A new instance is created per screen.
@injectable
class ExpensesHubBloc extends Bloc<ExpensesHubEvent, ExpensesHubState> {
  ExpensesHubBloc(this._getSummary) : super(const ExpensesHubState()) {
    on<ExpensesHubStarted>(_onStarted);
    on<ExpenseSummaryRetried>(_onRetried);
  }

  final GetExpenseSummary _getSummary;

  Future<void> _onStarted(
    ExpensesHubStarted event,
    Emitter<ExpensesHubState> emit,
  ) =>
      Future.wait([for (final kind in ExpenseKind.values) _load(kind, emit)]);

  Future<void> _onRetried(
    ExpenseSummaryRetried event,
    Emitter<ExpensesHubState> emit,
  ) {
    emit(state.withStatus(event.kind, const SummaryLoading()));
    return _load(event.kind, emit);
  }

  /// Loads the totals of [kind] and stores them, or the failure, in the
  /// state as soon as they arrive.
  Future<void> _load(ExpenseKind kind, Emitter<ExpensesHubState> emit) async {
    final result = await _getSummary(kind);
    emit(
      state.withStatus(
        kind,
        result.fold(
          (failure) => SummaryLoadFailure(failure.message),
          SummaryLoaded.new,
        ),
      ),
    );
  }
}
