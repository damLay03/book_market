import 'dart:typed_data';

import 'package:book_market/core/error/app_exception.dart';
import 'package:book_market/core/network/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ApiClient', () {
    test('decodes a successful response', () async {
      final client = ApiClient(_dioWithResponse('[{"id":"1"}]', 200));

      final result = await client.get<List<dynamic>>(
        '/books',
        decode: (data) => data! as List<dynamic>,
      );

      expect(result, hasLength(1));
    });

    test('maps 401 to UnauthorizedException', () async {
      final client = ApiClient(_dioWithResponse('{"message":"expired"}', 401));

      expect(
        () => client.get<void>('/books', decode: (_) {}),
        throwsA(isA<UnauthorizedException>()),
      );
    });

    test('maps malformed payloads to DataParsingException', () async {
      final client = ApiClient(_dioWithResponse('{}', 200));

      expect(
        () => client.get<void>(
          '/books',
          decode: (_) => throw const FormatException('bad payload'),
        ),
        throwsA(isA<DataParsingException>()),
      );
    });

    for (final testCase in <(int, Type)>[
      (403, ForbiddenException),
      (404, NotFoundException),
      (422, ValidationException),
      (500, ServerException),
    ]) {
      test('maps ${testCase.$1} to ${testCase.$2}', () {
        final client = ApiClient(_dioWithResponse('{}', testCase.$1));

        expect(
          () => client.get<void>('/books', decode: (_) {}),
          throwsA(
            isA<AppException>().having(
              (error) => error.runtimeType,
              'runtimeType',
              testCase.$2,
            ),
          ),
        );
      });
    }
  });
}

Dio _dioWithResponse(String body, int statusCode) {
  final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
    ..httpClientAdapter = _StaticAdapter(body, statusCode);
  return dio;
}

final class _StaticAdapter implements HttpClientAdapter {
  const new(this.body, this.statusCode);

  final String body;
  final int statusCode;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async => ResponseBody.fromString(
    body,
    statusCode,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );

  @override
  void close({bool force = false}) {}
}
