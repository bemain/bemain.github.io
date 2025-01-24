import 'package:flutter/material.dart';
import 'package:portfolio/layout.dart';
import 'package:portfolio/writing/article_list.dart';
import 'package:portfolio/writing/writing_scaffold.dart';

class WritingShell extends StatelessWidget {
  /// Wraps [child] with navigation elements and, on larger screens, an [ArticleList].
  const WritingShell({
    super.key,
    required this.child,
  });

  /// The main content of the shell.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return WritingScaffold(
      body: <Widget>() {
        switch (WindowSize.of(context)) {
          case WindowSize.compact:
          case WindowSize.medium:
            return child;

          case WindowSize.expanded:
          case WindowSize.large:
          case WindowSize.extraLarge:
            return Padding(
              padding: WindowSize.of(context).margin,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 24),
                    child: ArticleList(),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Card(
                      elevation: 0,
                      margin: EdgeInsets.symmetric(vertical: 24),
                      child: child,
                    ),
                  ),
                ],
              ),
            );
        }
      }(),
    );
  }
}
