import 'package:pennypincher_pro/features/auth/domain/repository/auth_repository.dart';

/// Notifies whether a sign-in is waiting a while for the backend to wake up.
class WatchServerWakeUp {
  const WatchServerWakeUp(this._repository);

  final AuthRepository _repository;

  Stream<bool> call() => _repository.waitingForServer;
}
