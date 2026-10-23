import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/features/dashboard/domain/repository/dashboard_repository.dart';
import 'package:pennypincher_pro/features/dashboard/domain/usecase/dashboard_use_cases.dart';

/// Registers the dashboard use cases, keeping the domain layer free of
/// dependency injection annotations.
@module
abstract class DashboardModule {
  @injectable
  GetDashboardSummary getDashboardSummary(DashboardRepository repository) =>
      GetDashboardSummary(repository);

  @injectable
  RecordNetWorthSnapshot recordNetWorthSnapshot(
    DashboardRepository repository,
  ) =>
      RecordNetWorthSnapshot(repository);
}
