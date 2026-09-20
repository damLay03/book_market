import 'package:book_market/core/error/app_exception.dart';
import 'package:book_market/features/catalog/catalog.dart';
import 'package:book_market/features/catalog/data/models/book_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CatalogRepositoryImpl', () {
    test('maps DTOs to domain entities', () async {
      const repository = CatalogRepositoryImpl(
        _StubDataSource(
          result: [
            BookDto(id: '1', title: 'Book', author: 'Author', price: 12),
          ],
        ),
      );

      final books = await repository.getBooks();

      expect(books, const [
        Book(id: '1', title: 'Book', author: 'Author', price: 12),
      ]);
    });

    test('maps infrastructure errors to CatalogUnavailable', () async {
      const repository = CatalogRepositoryImpl(
        _StubDataSource(error: NetworkException('offline')),
      );

      expect(repository.getBooks, throwsA(isA<CatalogUnavailable>()));
    });

    test('maps invalid data to CatalogInvalidData', () async {
      const repository = CatalogRepositoryImpl(
        _StubDataSource(error: FormatException('bad data')),
      );

      expect(repository.getBooks, throwsA(isA<CatalogInvalidData>()));
    });
  });
}

final class _StubDataSource implements CatalogRemoteDataSource {
  const new({this.result = const [], this.error});

  final List<BookDto> result;
  final Exception? error;

  @override
  Future<List<BookDto>> getBooks({String query = ''}) async {
    if (error case final error?) throw error;
    return result;
  }
}
