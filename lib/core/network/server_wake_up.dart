import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/constants/app_constants.dart';
import 'package:pennypincher_pro/core/time/clock.dart';

/// Wakes the backend up before the requests that cannot wait for it.
///
/// The hosted backend sleeps when idle and needs about a minute to start
/// again, longer than the timeouts of the regular clients. [wakeUp] probes
/// a cheap endpoint until any answer below `5xx` arrives or
/// [AppConstants.serverWakeUpBudget] runs out. It never fails: if the
/// server stays down, the request that follows reports the usual error.
///
/// Concurrent callers share one probe, and a server that answered is
/// assumed awake for [AppConstants.serverAwakeFor].
@lazySingleton
class ServerWakeUp {
  ServerWakeUp(@Named(NetworkNames.plainDio) this._client, this._clock);

  final Dio _client;
  final Clock _clock;
  Future<void>? _inFlight;
  DateTime? _awakeAt;

  /// Completes once the server answers, or once the budget runs out.
  Future<void> wakeUp() {
    if (_isKnownAwake) {
      return Future<void>.value();
    }
    return _inFlight ??= _probeUntilAwake().whenComplete(() {
      _inFlight = null;
    });
  }

  bool get _isKnownAwake {
    final awakeAt = _awakeAt;
    return awakeAt != null &&
        _clock.now().difference(awakeAt) < AppConstants.serverAwakeFor;
  }

  Future<void> _probeUntilAwake() async {
    final deadline = _clock.now().add(AppConstants.serverWakeUpBudget);
    while (true) {
      final remaining = deadline.difference(_clock.now());
      if (remaining <= Duration.zero) {
        return;
      }
      final timeout =
          _shorter(remaining, AppConstants.serverWakeUpProbeTimeout);
      if (await _probe(timeout)) {
        _awakeAt = _clock.now();
        return;
      }
      if (deadline.difference(_clock.now()) <=
          AppConstants.serverWakeUpRetryDelay) {
        return;
      }
      await Future<void>.delayed(AppConstants.serverWakeUpRetryDelay);
    }
  }

  /// Whether the server answered; a `401` or `404` counts as awake.
  Future<bool> _probe(Duration timeout) async {
    try {
      final response = await _client.get<String>(
        ApiPaths.wakeUpProbe,
        options: Options(
          connectTimeout: timeout,
          receiveTimeout: timeout,
          responseType: ResponseType.plain,
          validateStatus: (_) => true,
        ),
      );
      final status = response.statusCode;
      return status != null && status < HttpStatusCodes.firstServerError;
    } on DioException {
      return false;
    }
  }

  static Duration _shorter(Duration a, Duration b) => a < b ? a : b;
}
