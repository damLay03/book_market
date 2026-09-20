import 'dart:developer';

import 'package:dio/dio.dart';

final class SafeLogInterceptor extends Interceptor {
  static const _sensitiveKeys = {
    'authorization',
    'password',
    'token',
    'access_token',
    'refresh_token',
    'otp',
    'secret',
    'card_number',
    'cvv',
  };

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log(
      '${options.method} ${options.uri} '
      'query=${sanitize(options.queryParameters)} '
      'body=${sanitize(options.data)}',
      name: 'network',
    );
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    log(
      '${response.statusCode} ${response.requestOptions.uri} '
      'body=${sanitize(response.data)}',
      name: 'network',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log(
      '${err.response?.statusCode ?? 'NETWORK'} '
      '${err.requestOptions.uri} ${err.type.name}',
      name: 'network',
    );
    handler.next(err);
  }

  static Object? sanitize(Object? value) {
    if (value is Map) {
      return value.map<Object?, Object?>((key, nestedValue) {
        final normalizedKey = key.toString().toLowerCase();
        final isSensitive = _sensitiveKeys.any(normalizedKey.contains);
        return MapEntry(
          key,
          isSensitive ? '<redacted>' : sanitize(nestedValue),
        );
      });
    }
    if (value is Iterable) return value.map(sanitize).toList(growable: false);
    return value;
  }
}
