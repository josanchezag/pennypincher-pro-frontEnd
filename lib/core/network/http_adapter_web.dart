import 'package:dio/browser.dart';
import 'package:dio/dio.dart';

/// Browser adapter that sends cookies on cross-origin requests, so the
/// httpOnly refresh cookie reaches the `/auth` endpoints of the API.
HttpClientAdapter createHttpAdapter() =>
    BrowserHttpClientAdapter(withCredentials: true);
