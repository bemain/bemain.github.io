import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:portfolio/layout.dart';

class Article {
  Article({
    required this.id,
    required this.title,
    this.description,
    required this.textPath,
    this.writtenAt,
    this.image,
  });

  final String id;
  final String title;
  final String? description;
  final String textPath;
  final DateTime? writtenAt;
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
    id: "250120",
    title: "Highland green",
    textPath: "assets/writing/250120.md",
    image: AssetImage("assets/writing/250120.jpg"),
    writtenAt: DateTime(2023, 4, 15),
  )
];

class ArticlePane extends StatelessWidget {
  const ArticlePane({super.key, required this.article});

  final Article? article;

  @override
  Widget build(BuildContext context) {
    if (article == null) {
      return const Center(
        child: Text("No moment selected"),
      );
    }

    return FutureBuilder(
      future: DefaultAssetBundle.of(context).loadString(article!.textPath),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        }

        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: MarkdownBody(
              data: snapshot.data!,
              selectable: true,
              styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
              softLineBreak: true,
            ),
          ),
        );
      },
    );
  }
}
