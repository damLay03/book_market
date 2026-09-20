part of 'catalog_cubit.dart';

sealed class CatalogState extends Equatable {
  const new();

  @override
  List<Object?> get props => [];
}

final class CatalogInitial extends CatalogState {
  const new();
}

final class CatalogLoading extends CatalogState {
  const new();
}

final class CatalogSuccess extends CatalogState {
  const new({required this.books, required this.query});

  final List<Book> books;
  final String query;

  @override
  List<Object?> get props => [books, query];
}

final class CatalogError extends CatalogState {
  const new({required this.message, required this.query});

  final String message;
  final String query;

  @override
  List<Object?> get props => [message, query];
}
