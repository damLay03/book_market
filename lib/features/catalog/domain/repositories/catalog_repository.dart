import 'package:book_market/features/catalog/domain/entities/book.dart';

abstract interface class CatalogRepository {
  Future<List<Book>> getBooks({String query = ''});
}

sealed class CatalogFailure implements Exception {
  const new(this.message, {this.cause});

  final String message;
  final Object? cause;
}

final class CatalogUnavailable extends CatalogFailure {
  const new(super.message, {super.cause});
}

final class CatalogInvalidData extends CatalogFailure {
  const new(super.message, {super.cause});
}
