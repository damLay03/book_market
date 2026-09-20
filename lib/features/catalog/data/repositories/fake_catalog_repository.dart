import 'package:book_market/features/catalog/catalog.dart';

final class FakeCatalogRepository implements CatalogRepository {
  const new({this.delay = const Duration(milliseconds: 350)});

  final Duration delay;

  static const _books = [
    Book(
      id: 'clean-code',
      title: 'Clean Code',
      author: 'Robert C. Martin',
      price: 24.99,
    ),
    Book(
      id: 'pragmatic-programmer',
      title: 'The Pragmatic Programmer',
      author: 'David Thomas & Andrew Hunt',
      price: 29.99,
    ),
    Book(
      id: 'designing-data-intensive-applications',
      title: 'Designing Data-Intensive Applications',
      author: 'Martin Kleppmann',
      price: 34.99,
    ),
  ];

  @override
  Future<List<Book>> getBooks({String query = ''}) async {
    await Future<void>.delayed(delay);
    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) return _books;
    return _books
        .where(
          (book) =>
              book.title.toLowerCase().contains(normalizedQuery) ||
              book.author.toLowerCase().contains(normalizedQuery),
        )
        .toList(growable: false);
  }
}
