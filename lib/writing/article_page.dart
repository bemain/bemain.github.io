import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:portfolio/layout.dart';
import 'package:portfolio/writing/writing_scaffold.dart';

class Article {
  Article({
    required this.id,
    required this.title,
    required this.assetPath,
  });

  final String id;
  final String title;
  final String assetPath;
}

final List<Article> articles = [
  Article(
    id: "what_is_this",
    title: "What is this?",
    assetPath: "assets/writing/what_is_this.md",
  )
];

class ArticlePage extends StatelessWidget {
  const ArticlePage({super.key, required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSize.of(context);

    return WritingScaffold(
      body: ListView(
        children: [
          Center(
            child: Padding(
              padding: windowSize.padding,
              child: FutureBuilder(
                future: DefaultAssetBundle.of(context)
                    .loadString(article.assetPath),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Error: ${snapshot.error}"),
                    );
                  }

                  return ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 1024),
                    child: _buildText(context, snapshot.data!),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildText(BuildContext context, String data) {
    return MarkdownBody(
      data: data,
      selectable: true,
      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
      softLineBreak: true,
    );
  }
}
