// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Article _$ArticleFromJson(Map<String, dynamic> json) => Article(
      id: json['id'] as String,
      title: json['title'] as String,
      type: $enumDecode(_$ArticleTypeEnumMap, json['type']),
      description: json['description'] as String?,
      textPath: json['textPath'] as String,
      writtenAt: json['writtenAt'] == null
          ? null
          : DateTime.parse(json['writtenAt'] as String),
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$ArticleToJson(Article instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'type': _$ArticleTypeEnumMap[instance.type]!,
      'description': instance.description,
      'textPath': instance.textPath,
      'writtenAt': instance.writtenAt?.toIso8601String(),
      'imageUrl': instance.imageUrl,
    };

const _$ArticleTypeEnumMap = {
  ArticleType.prose: 'prose',
  ArticleType.novel: 'novel',
  ArticleType.poem: 'poem',
};
