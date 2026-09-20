import 'package:book_market/core/error/app_exception.dart';
import 'package:book_market/features/catalog/catalog.dart';

final class CatalogRepositoryImpl implements CatalogRepository {
  const new(this._remoteDataSource);

  final CatalogRemoteDataSource _remoteDataSource;

  @override
  Future<List<Book>> getBooks({String query = ''}) async {
    try {
      final books = await _remoteDataSource.getBooks(query: query);
      return books.map((book) => book.toDomain()).toList(growable: false);
    } on DataParsingException catch (error) {
      throw CatalogInvalidData(error.message, cause: error);
    } on AppException catch (error) {
      throw CatalogUnavailable(error.message, cause: error);
    } on FormatException catch (error) {
      throw CatalogInvalidData('Book data is invalid.', cause: error);
    }
  }
}
