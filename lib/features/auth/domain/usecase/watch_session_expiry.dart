import 'package:pennypincher_pro/features/auth/domain/repository/auth_repository.dart';

/// Notifies when the session ended without the user signing out.
class WatchSessionExpiry {
  const WatchSessionExpiry(this._repository);

  final AuthRepository _repository;

  Stream<void> call() => _repository.sessionExpirations;
}
