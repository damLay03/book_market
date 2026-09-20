// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookDto _$BookDtoFromJson(Map<String, dynamic> json) => BookDto(
  id: json['id'] as String,
  title: json['title'] as String,
  author: json['author'] as String,
  price: (json['price'] as num).toDouble(),
  coverUrl: json['coverUrl'] as String?,
);

Map<String, dynamic> _$BookDtoToJson(BookDto instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'author': instance.author,
  'price': instance.price,
  'coverUrl': instance.coverUrl,
};
