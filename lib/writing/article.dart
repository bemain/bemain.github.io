import 'package:flutter/material.dart';

class Article {
  /// Representation of a written article.
  Article({
    required this.id,
    required this.title,
    this.description,
    required this.textPath,
    this.writtenAt,
    this.image,
  });

  /// A unique identifier for the article.
  final String id;

  /// The title of the article.
  final String title;

  /// A short description of the article.
  final String? description;

  /// The path to the markdown file containing the article text.
  final String textPath;

  /// The date the article was written.
  final DateTime? writtenAt;

  /// An image to display alongside the article.
  final ImageProvider? image;
}

final List<Article> articles = [
  Article(
    id: "what_is_this",
    title: "What is this?",
    textPath: "assets/writing/what_is_this.md",
    writtenAt: DateTime(2025, 1, 20),
  ),
  Article(
    id: "230712",
    title: "Mountain-fog and highland-green",
    textPath: "assets/writing/230712.md",
    image: AssetImage("assets/writing/230712.jpg"),
    writtenAt: DateTime(2023, 7, 12),
  ),
  Article(
    id: "21000",
    title: "What is already dead can never die",
    textPath: "assets/writing/210000.md",
    writtenAt: DateTime(2021, 7, 24),
  ),
  Article(
    id: "21001",
    title: "Jag tänker aldrig bli psykolog",
    textPath: "assets/writing/210001.md",
    writtenAt: DateTime(2021, 11, 17),
  ),
  Article(
    id: "220421",
    title: "När kvällen åter står i brand",
    textPath: "assets/writing/220421.md",
    image: AssetImage("assets/writing/220421.jpg"),
    writtenAt: DateTime(2022, 4, 21),
  ),
];
