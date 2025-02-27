import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'article.g.dart';

enum ArticleType {
  /// A short text.
  prose,

  /// A longer text.
  ///
  /// Tab indenting is automatically applied to paragraphs.
  novel,

  /// A poem.
  poem,
}

@JsonSerializable()
class Article {
  /// Representation of a written article.
  Article({
    required this.id,
    required this.title,
    required this.type,
    this.description,
    required this.textPath,
    this.writtenAt,
    this.imageUrl,
  });

  /// A unique identifier for the article.
  final String id;

  /// The title of the article.
  final String title;

  final ArticleType type;

  /// A short description of the article.
  final String? description;

  /// The path to the markdown file containing the article text.
  final String textPath;

  /// The date the article was written.
  final DateTime? writtenAt;

  /// An url to an image to display alongside the article.
  /// TODO: Point this to a document on Cloud Storage
  final String? imageUrl;

  /// An image to display alongside the article.
  @JsonKey(includeFromJson: false, includeToJson: false)
  ImageProvider? get image {
    if (imageUrl == null || imageUrl!.isEmpty) return null;

    return AssetImage(imageUrl!);
  }

  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleToJson(this);
}
