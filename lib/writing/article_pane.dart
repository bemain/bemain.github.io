import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:portfolio/layout.dart';
import 'package:portfolio/writing/article.dart';
import 'package:portfolio/writing/article_list.dart';

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
