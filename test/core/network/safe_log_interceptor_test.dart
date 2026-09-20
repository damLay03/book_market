import 'dart:typed_data';

import 'package:book_market/core/network/safe_log_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('redacts sensitive values recursively', () {
    final sanitized = SafeLogInterceptor.sanitize({
      'email': 'reader@example.test',
      'password': 'do-not-log',
      'profile': {'access_token': 'secret-token', 'display_name': 'Reader'},
      'cards': [
        {'card_number': '4111111111111111'},
      ],
    });

    expect(sanitized, {
      'email': 'reader@example.test',
      'password': '<redacted>',
      'profile': {'access_token': '<redacted>', 'display_name': 'Reader'},
      'cards': [
        {'card_number': '<redacted>'},
      ],
    });
  });

  test('passes successful requests and responses through', () async {
    final dio = Dio()
      ..interceptors.add(SafeLogInterceptor())
      ..httpClientAdapter = const _Adapter(200);

    final response = await dio.post<void>(
      'https://example.test/login',
      data: {'password': 'secret'},
    );

    expect(response.statusCode, 200);
  });

  test('passes errors through', () async {
    final dio = Dio()
      ..interceptors.add(SafeLogInterceptor())
      ..httpClientAdapter = const _Adapter(500);

    expect(
      () => dio.get<void>('https://example.test/books'),
      throwsA(isA<DioException>()),
    );
  });
}

final class _Adapter implements HttpClientAdapter {
  const new(this.statusCode);

  final int statusCode;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async => ResponseBody.fromString('{}', statusCode);

  @override
  void close({bool force = false}) {}
}
