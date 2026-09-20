import 'package:bloc_test/bloc_test.dart';
import 'package:book_market/features/catalog/catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CatalogCubit', () {
    const books = [Book(id: '1', title: 'Book', author: 'Author', price: 12)];

    blocTest<CatalogCubit, CatalogState>(
      'emits loading then success',
      build: () => CatalogCubit(const _StubRepository(result: books)),
      act: (cubit) => cubit.load(),
      expect: () => const [
        CatalogLoading(),
        CatalogSuccess(books: books, query: ''),
      ],
    );

    blocTest<CatalogCubit, CatalogState>(
      'emits loading then empty success for an unmatched search',
      build: () =>
          CatalogCubit(const FakeCatalogRepository(delay: Duration.zero)),
      act: (cubit) => cubit.load(query: 'not-found'),
      expect: () => const [
        CatalogLoading(),
        CatalogSuccess(books: [], query: 'not-found'),
      ],
    );

    blocTest<CatalogCubit, CatalogState>(
      'emits loading then error',
      build: () => CatalogCubit(
        const _StubRepository(error: CatalogUnavailable('offline')),
      ),
      act: (cubit) => cubit.load(query: 'dart'),
      expect: () => const [
        CatalogLoading(),
        CatalogError(message: 'offline', query: 'dart'),
      ],
    );
  });
}

final class _StubRepository implements CatalogRepository {
  const new({this.result = const [], this.error});

  final List<Book> result;
  final Exception? error;

  @override
  Future<List<Book>> getBooks({String query = ''}) async {
    if (error case final error?) throw error;
    return result;
  }
}
