import 'package:book_market/features/catalog/domain/entities/book.dart';
import 'package:json_annotation/json_annotation.dart';

part 'book_dto.g.dart';

@JsonSerializable()
final class BookDto {
  const new({
    required this.id,
    required this.title,
    required this.author,
    required this.price,
    this.coverUrl,
  });

  factory fromJson(Map<String, dynamic> json) => _$BookDtoFromJson(json);

  final String id;
  final String title;
  final String author;
  final double price;
  final String? coverUrl;

  Map<String, dynamic> toJson() => _$BookDtoToJson(this);

  Book toDomain() => Book(
    id: id,
    title: title,
    author: author,
    price: price,
    coverUrl: coverUrl == null ? null : Uri.tryParse(coverUrl!),
  );
}
