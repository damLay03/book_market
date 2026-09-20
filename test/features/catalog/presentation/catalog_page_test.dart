import 'package:book_market/features/catalog/catalog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('CatalogPage', () {
    testWidgets('renders books returned by repository', (tester) async {
      await tester.pumpApp(
        BlocProvider(
          create: (_) => CatalogCubit(
            const _Repository(
              books: [
                Book(
                  id: '1',
                  title: 'Clean Code',
                  author: 'Uncle Bob',
                  price: 20,
                ),
              ],
            ),
          ),
          child: const CatalogPage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Clean Code'), findsOneWidget);
      expect(find.text('Uncle Bob'), findsOneWidget);
    });

    testWidgets('renders empty state', (tester) async {
      await tester.pumpApp(
        BlocProvider(
          create: (_) => CatalogCubit(const _Repository()),
          child: const CatalogPage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No books found'), findsOneWidget);
      expect(find.text('Clear search'), findsOneWidget);
    });

    testWidgets('renders retry state and retries', (tester) async {
      final repository = _MutableRepository(failuresRemaining: 1);
      await tester.pumpApp(
        BlocProvider(
          create: (_) => CatalogCubit(repository),
          child: const CatalogPage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Could not load books'), findsOneWidget);
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();

      expect(find.text('No books found'), findsOneWidget);
      expect(repository.calls, 2);
    });
  });
}

final class _Repository implements CatalogRepository {
  const new({this.books = const []});

  final List<Book> books;

  @override
  Future<List<Book>> getBooks({String query = ''}) async => books;
}

final class _MutableRepository implements CatalogRepository {
  new({required this.failuresRemaining});

  int failuresRemaining;
  int calls = 0;

  @override
  Future<List<Book>> getBooks({String query = ''}) async {
    calls++;
    if (failuresRemaining > 0) {
      failuresRemaining--;
      throw const CatalogUnavailable('offline');
    }
    return const [];
  }
}
