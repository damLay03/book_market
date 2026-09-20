import 'package:book_market/core/network/api_client.dart';
import 'package:book_market/features/catalog/catalog.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ApiCatalogRemoteDataSource', () {
    test('decodes a wrapped book list', () async {
      final source = ApiCatalogRemoteDataSource(
        _StubApiClient({
          'data': [
            {
              'id': '1',
              'title': 'Clean Code',
              'author': 'Robert C. Martin',
              'price': 24.99,
              'coverUrl': 'https://example.test/cover.jpg',
            },
          ],
        }),
      );

      final books = await source.getBooks(query: 'clean');

      expect(books.single.title, 'Clean Code');
      expect(books.single.toDomain().coverUrl?.host, 'example.test');
      expect(books.single.toJson()['price'], 24.99);
    });

    test('decodes a bare book list', () async {
      final source = ApiCatalogRemoteDataSource(
        _StubApiClient([
          {'id': '1', 'title': 'Book', 'author': 'Author', 'price': 10},
        ]),
      );

      expect(await source.getBooks(), hasLength(1));
    });

    test('rejects an invalid response shape', () {
      final source = ApiCatalogRemoteDataSource(
        _StubApiClient(<String, Object?>{'book': <String, dynamic>{}}),
      );

      expect(source.getBooks, throwsA(isA<FormatException>()));
    });
  });
}

final class _StubApiClient extends ApiClient {
  new(this.response) : super(Dio());

  final Object? response;

  @override
  Future<T> get<T>(
    String path, {
    required JsonDecoder<T> decode,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async => decode(response);
}
