import 'package:book_market/core/network/api_client.dart';
import 'package:book_market/features/catalog/data/models/book_dto.dart';

abstract interface class CatalogRemoteDataSource {
  Future<List<BookDto>> getBooks({String query = ''});
}

final class ApiCatalogRemoteDataSource implements CatalogRemoteDataSource {
  const new(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<List<BookDto>> getBooks({String query = ''}) {
    return _apiClient.get<List<BookDto>>(
      '/books',
      queryParameters: query.isEmpty ? null : {'q': query},
      decode: (data) {
        final items = switch (data) {
          {'data': final List<dynamic> items} => items,
          final List<dynamic> items => items,
          _ => throw const FormatException('Expected a list of books.'),
        };
        return items
            .map(
              (item) =>
                  BookDto.fromJson(Map<String, dynamic>.from(item as Map)),
            )
            .toList(growable: false);
      },
    );
  }
}
