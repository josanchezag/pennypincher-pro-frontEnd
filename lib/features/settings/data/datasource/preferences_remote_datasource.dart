import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/constants/app_constants.dart';
import 'package:pennypincher_pro/core/network/api_envelope.dart';
import 'package:pennypincher_pro/features/settings/data/model/preferences_json.dart';
import 'package:pennypincher_pro/features/settings/domain/entity/user_preferences_entity.dart';

/// `/users/me/preferences` with the authenticated client. Every method
/// throws `AppException` on failure.
@lazySingleton
class PreferencesRemoteDataSource {
  PreferencesRemoteDataSource(this._dio);

  final Dio _dio;

  /// `GET /users/me/preferences`.
  Future<UserPreferences> get() async {
    final response = await ApiEnvelope.send(
      () => _dio.get<Object?>(ApiPaths.myPreferences),
    );
    return ApiEnvelope.parseData(response.data, PreferencesJson.fromJson);
  }

  /// `PUT /users/me/preferences` with the settings of [change] only; the
  /// backend keeps the others.
  Future<UserPreferences> save(PreferencesChange change) async {
    final response = await ApiEnvelope.send(
      () => _dio.put<Object?>(
        ApiPaths.myPreferences,
        data: PreferencesJson.toJson(change),
      ),
    );
    return ApiEnvelope.parseData(response.data, PreferencesJson.fromJson);
  }
}
