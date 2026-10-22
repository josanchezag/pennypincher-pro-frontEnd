import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/constants/app_constants.dart';
import 'package:pennypincher_pro/core/network/api_envelope.dart';
import 'package:pennypincher_pro/features/auth/data/model/auth_session_model.dart';
import 'package:pennypincher_pro/features/auth/data/model/google_authorization.dart';

/// Calls the backend `/auth` endpoints. Every method throws
/// [AppException] on failure.
abstract interface class AuthRemoteDataSource {
  /// `POST /auth/google/callback`: exchanges the Google code for a session.
  Future<AuthSessionModel> exchangeGoogleCode(
    GoogleAuthorization authorization,
  );

  /// `POST /auth/dev-login`: session for the local test user.
  Future<AuthSessionModel> devLogin();

  /// `POST /auth/refresh`: new session from the httpOnly refresh cookie.
  Future<AuthSessionModel> refresh();

  /// `DELETE /auth/logout`: revokes the refresh cookie.
  Future<void> logout();
}

/// Uses the plain client: `/auth` calls rely on the cookie, never on the
/// bearer token, and must not trigger the token refresh interceptor.
@LazySingleton(as: AuthRemoteDataSource)
class DioAuthRemoteDataSource implements AuthRemoteDataSource {
  DioAuthRemoteDataSource(@Named(NetworkNames.plainDio) this._dio);

  final Dio _dio;

  @override
  Future<AuthSessionModel> exchangeGoogleCode(
    GoogleAuthorization authorization,
  ) =>
      _postSession(ApiPaths.googleCallback, body: authorization.toJson());

  @override
  Future<AuthSessionModel> devLogin() => _postSession(ApiPaths.devLogin);

  @override
  Future<AuthSessionModel> refresh() => _postSession(ApiPaths.refresh);

  @override
  Future<void> logout() =>
      ApiEnvelope.send(() => _dio.delete<Object?>(ApiPaths.logout));

  Future<AuthSessionModel> _postSession(String path, {Object? body}) async {
    final response = await ApiEnvelope.send(
      () => _dio.post<Object?>(path, data: body),
    );
    return ApiEnvelope.parseData(response.data, AuthSessionModel.fromJson);
  }
}
