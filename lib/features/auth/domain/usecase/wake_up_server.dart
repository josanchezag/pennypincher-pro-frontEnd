import 'package:pennypincher_pro/features/auth/domain/repository/auth_repository.dart';

/// Wakes the backend up ahead of a sign-in, so the user rarely waits for it.
class WakeUpServer {
  const WakeUpServer(this._repository);

  final AuthRepository _repository;

  Future<void> call() => _repository.wakeUpServer();
}
