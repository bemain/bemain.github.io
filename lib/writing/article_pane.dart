import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:portfolio/layout.dart';
import 'package:portfolio/writing/article_list.dart';

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

class ArticlePane extends StatelessWidget {
  const ArticlePane({super.key, required this.article});

  final Article? article;

  @override
  Widget build(BuildContext context) {
    if (article == null) {
      switch (WindowSize.of(context)) {
        case WindowSize.compact:
        case WindowSize.medium:
          // On small screens, show the list of articles instead of an empty pane
          return const ArticleList();

        default:
          return const Center(
            child: Text("No moment selected"),
          );
      }
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
            padding: EdgeInsets.symmetric(
                vertical: 24,
                horizontal: switch (WindowSize.of(context)) {
                  WindowSize.compact || WindowSize.medium => 0,
                  _ => 24,
                }),
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
