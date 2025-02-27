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

final List<Article> articles = [
  Article(
    id: "what_is_this",
    title: "Vad är det här?",
    type: ArticleType.prose,
    textPath: "assets/writing/what_is_this.md",
    imageUrl: "assets/writing/what_is_this.jpg",
    writtenAt: DateTime(2025, 1, 20),
  ),
  Article(
    id: "250122",
    title: "Fantasy Novel, Prologue: Vim",
    type: ArticleType.novel,
    textPath: "assets/writing/250122.md",
    imageUrl: "assets/writing/250122.jpg",
    writtenAt: DateTime(2025, 1, 22),
  ),
  Article(
    id: "230712",
    title: "Mountain-fog and highland-green",
    type: ArticleType.poem,
    textPath: "assets/writing/230712.md",
    imageUrl: "assets/writing/230712.jpg",
    writtenAt: DateTime(2023, 7, 12),
  ),
  Article(
    id: "210000",
    title: "What is already dead can never die",
    type: ArticleType.poem,
    textPath: "assets/writing/210000.md",
    imageUrl: "assets/writing/210000.jpg",
    writtenAt: DateTime(2021, 7, 24),
  ),
  Article(
    id: "220421",
    title: "När kvällen åter står i brand",
    type: ArticleType.poem,
    textPath: "assets/writing/220421.md",
    imageUrl: "assets/writing/220421.jpg",
    writtenAt: DateTime(2022, 4, 21),
  ),
];
