import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:portfolio/layout.dart';
import 'package:portfolio/writing/article.dart';

class ArticlePane extends StatelessWidget {
  /// Displays the text of an [article] by rendering it as markdown.
  const ArticlePane({super.key, required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DefaultAssetBundle.of(context).loadString(article.textPath),
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

        return Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: switch (WindowSize.of(context)) {
                WindowSize.compact || WindowSize.medium => 0,
                _ => 24,
              },
            ),
            child: ListView(
              children: [
                SizedBox(height: 24),
                Text(
                  article.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: 8),
                MarkdownBody(
                  data: snapshot.data!,
                  selectable: true,
                  styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
                  softLineBreak: true,
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}
