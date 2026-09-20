import 'dart:typed_data';

import 'package:book_market/core/network/auth_interceptor.dart';
import 'package:book_market/core/storage/token_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthInterceptor', () {
    test('adds bearer token when a token exists', () async {
      final dio = Dio()
        ..interceptors.add(AuthInterceptor(_MemoryTokenStorage('token')));
      final adapter = _RecordingAdapter();
      dio.httpClientAdapter = adapter;

      await dio.get<void>('https://example.test/books');

      expect(adapter.options?.headers['Authorization'], 'Bearer token');
    });

    test('does not add authorization when token is absent', () async {
      final dio = Dio()
        ..interceptors.add(AuthInterceptor(_MemoryTokenStorage(null)));
      final adapter = _RecordingAdapter();
      dio.httpClientAdapter = adapter;

      await dio.get<void>('https://example.test/books');

      expect(adapter.options?.headers, isNot(contains('Authorization')));
    });
  });
}

final class _MemoryTokenStorage implements TokenStorage {
  new(this.accessToken);

  String? accessToken;
  String? refreshToken;

  @override
  Future<void> clear() async {
    accessToken = null;
    refreshToken = null;
  }

  @override
  Future<String?> readAccessToken() async => accessToken;

  @override
  Future<String?> readRefreshToken() async => refreshToken;

  @override
  Future<void> writeAccessToken(String token) async => accessToken = token;

  @override
  Future<void> writeRefreshToken(String token) async => refreshToken = token;
}

final class _RecordingAdapter implements HttpClientAdapter {
  RequestOptions? options;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    this.options = options;
    return ResponseBody.fromString('', 204);
  }

  @override
  void close({bool force = false}) {}
}
