import 'package:flutter/material.dart';
import 'package:portfolio/layout.dart';
import 'package:portfolio/writing/article_list.dart';
import 'package:portfolio/writing/writing_scaffold.dart';

class WritingShell extends StatelessWidget {
  const WritingShell({
    super.key,
    required this.child,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return WritingScaffold(
      body: Padding(
        padding: WindowSize.of(context).padding,
        child: <Widget>() {
          switch (WindowSize.of(context)) {
            case WindowSize.compact:
            case WindowSize.medium:
              return child != null
                  ? Align(
                      alignment: Alignment.topCenter,
                      child: child,
                    )
                  : ArticleList();

            case WindowSize.expanded:
            case WindowSize.large:
            case WindowSize.extraLarge:
              return Row(
                children: [
                  ArticleList(),
                  SizedBox(width: 24),
                  Expanded(
                    child: Card(
                      elevation: 0,
                      margin: EdgeInsets.symmetric(vertical: 24),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: child,
                      ),
                    ),
                  ),
                ],
              );
          }
        }(),
      ),
    );
  }
}
