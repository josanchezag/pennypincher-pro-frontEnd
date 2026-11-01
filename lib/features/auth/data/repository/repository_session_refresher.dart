import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/auth/session_refresher.dart';
import 'package:pennypincher_pro/core/error/error_codes.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/features/auth/domain/repository/auth_repository.dart';

/// Lets the network layer renew the access token through the repository.
/// An account removed from the allowlist ends the session like a rejected
/// refresh cookie.
@LazySingleton(as: SessionRefresher)
class RepositorySessionRefresher implements SessionRefresher {
  RepositorySessionRefresher(this._repository);

  final AuthRepository _repository;

  @override
  Future<RefreshOutcome> refreshSession() async {
    final result = await _repository.refreshSession();
    return result.fold(
      (failure) => _endsSession(failure)
          ? RefreshOutcome.rejected
          : RefreshOutcome.failed,
      (_) => RefreshOutcome.refreshed,
    );
  }

  static bool _endsSession(Failure failure) => switch (failure) {
        UnauthorizedFailure() => true,
        ServerFailure(code: ErrorCodes.accountNotAllowed) => true,
        _ => false,
      };
}
