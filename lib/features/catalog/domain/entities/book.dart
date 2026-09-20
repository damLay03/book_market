import 'package:equatable/equatable.dart';

final class Book extends Equatable {
  const new({
    required this.id,
    required this.title,
    required this.author,
    required this.price,
    this.coverUrl,
  });

  final String id;
  final String title;
  final String author;
  final double price;
  final Uri? coverUrl;

  @override
  List<Object?> get props => [id, title, author, price, coverUrl];
}
