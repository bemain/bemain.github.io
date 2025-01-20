import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:portfolio/layout.dart';
import 'package:portfolio/writing/writing_scaffold.dart';

class Article {
  Article({
    required this.id,
    required this.title,
    required this.textPath,
    this.image,
  });

  final String id;
  final String title;
  final String textPath;
  final ImageProvider? image;
}

final List<Article> articles = [
  Article(
    id: "what_is_this",
    title: "What is this?",
    textPath: "assets/writing/what_is_this.md",
  )
];

class ArticlePage extends StatefulWidget {
  const ArticlePage({super.key, required this.article});

  final Article article;

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  late final Future<String> futureText =
      DefaultAssetBundle.of(context).loadString(widget.article.textPath);

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
                future: futureText,
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
