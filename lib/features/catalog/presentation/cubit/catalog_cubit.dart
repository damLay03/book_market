import 'package:bloc/bloc.dart';
import 'package:book_market/features/catalog/catalog.dart';
import 'package:equatable/equatable.dart';

part 'catalog_state.dart';

final class CatalogCubit extends Cubit<CatalogState> {
  new(this._repository) : super(const CatalogInitial());

  final CatalogRepository _repository;

  Future<void> load({String query = ''}) async {
    emit(const CatalogLoading());
    try {
      final books = await _repository.getBooks(query: query);
      emit(CatalogSuccess(books: books, query: query));
    } on CatalogFailure catch (error) {
      emit(CatalogError(message: error.message, query: query));
    } on Object {
      emit(CatalogError(message: 'unexpected_error', query: query));
    }
  }
}
