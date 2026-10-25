part of 'budget_comparison_bloc.dart';

/// Progress of loading the comparison.
enum ComparisonStatus { loading, loaded, failure }

/// The compared [months], oldest first, once loaded, or the [error] that
/// stopped the load.
final class BudgetComparisonState extends Equatable {
  const BudgetComparisonState({
    this.status = ComparisonStatus.loading,
    this.months = const [],
    this.error,
  });

  final ComparisonStatus status;
  final List<MonthComparison> months;
  final String? error;

  /// Whether any compared month has a budget.
  bool get hasBudgets => months.any((month) => month.exists);

  @override
  List<Object?> get props => [status, months, error];
}
