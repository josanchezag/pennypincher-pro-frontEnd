import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// Answer of [FakeHttpAdapter] for one request.
class FakeResponse {
  const FakeResponse(this.statusCode, [this.body]);

  final int statusCode;
  final Object? body;
}

typedef FakeHandler = Future<FakeResponse> Function(RequestOptions options);

/// In-memory HTTP backend: every request is answered by [handler] and
/// recorded in [requests]. A handler that throws simulates a network error.
class FakeHttpAdapter implements HttpClientAdapter {
  FakeHttpAdapter(this.handler);

  FakeHandler handler;
  final List<RequestOptions> requests = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final response = await handler(options);
    final body = response.body;
    return ResponseBody.fromString(
      body == null ? '' : jsonEncode(body),
      response.statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

/// Dio pointed at a fake API whose responses come from [adapter].
Dio fakeDio(FakeHttpAdapter adapter) =>
    Dio(BaseOptions(baseUrl: 'http://api.test/api/v1'))
      ..httpClientAdapter = adapter;

/// Success envelope of the backend.
Map<String, Object?> envelope(Object? data) => {
      'data': data,
      'meta': {
        'timestamp': '2026-10-22T10:00:00Z',
        'requestId': '0f8fad5b-d9cb-469f-a165-70867728950e',
      },
    };

/// Error envelope of the backend.
Map<String, Object?> errorEnvelope(String code, String message) => {
      'error': {'code': code, 'message': message},
      'meta': {
        'timestamp': '2026-10-22T10:00:00Z',
        'requestId': '0f8fad5b-d9cb-469f-a165-70867728950e',
      },
    };

/// JSON of a session response with [accessToken].
Map<String, Object?> sessionJson({String accessToken = 'access-1'}) => {
      'accessToken': accessToken,
      'tokenType': 'Bearer',
      'expiresIn': 900,
      'user': userJson,
    };

const Map<String, Object?> userJson = {
  'id': '7d3f9a52-0c1e-4b8e-9a51-2f6d8c4b1e07',
  'email': 'ada@example.com',
  'name': 'Ada Lovelace',
  'pictureUrl': 'https://lh3.googleusercontent.com/a/ada',
  'createdAt': '2026-10-01T12:00:00Z',
};
