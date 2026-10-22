import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/auth/session_refresher.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/features/auth/domain/repository/auth_repository.dart';

/// Lets the network layer renew the access token through the repository.
@LazySingleton(as: SessionRefresher)
class RepositorySessionRefresher implements SessionRefresher {
  RepositorySessionRefresher(this._repository);

  final AuthRepository _repository;

  @override
  Future<RefreshOutcome> refreshSession() async {
    final result = await _repository.refreshSession();
    return result.fold(
      (failure) => failure is UnauthorizedFailure
          ? RefreshOutcome.rejected
          : RefreshOutcome.failed,
      (_) => RefreshOutcome.refreshed,
    );
  }
}
