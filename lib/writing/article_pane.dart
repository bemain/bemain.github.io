import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:portfolio/layout.dart';
import 'package:portfolio/writing/article.dart';
import 'package:markdown/markdown.dart' as md;

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

        String data = snapshot.data!;
        if (article.type == ArticleType.novel) {
          // Use tab indenting for paragraphs in novels.
          data = data.replaceAll(
            RegExp("\n(?=[A-Z]|\")"),
            "\n&ensp;&ensp;&ensp;",
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: WindowSize.of(context).margin.add(
                  EdgeInsets.symmetric(vertical: 24),
                ),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 512),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      article.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    MarkdownBody(
                      data: data,
                      softLineBreak: true,
                      selectable: true,
                      styleSheet:
                          MarkdownStyleSheet.fromTheme(Theme.of(context)),
                      // Fix so that the horizontal rule is actually built using the custom builder.
                      // See https://github.com/flutter/flutter/issues/153550
                      extensionSet:
                          md.ExtensionSet([_HorizontalRuleSyntax()], []),
                      builders: {
                        "hhrr": _HorizontalRuleBuilder(),
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HorizontalRuleSyntax extends md.HorizontalRuleSyntax {
  @override
  md.Node parse(md.BlockParser parser) {
    parser.advance();
    return md.Element.empty('hhrr');
  }
}

/// Builds a custom horizontal rule element with more padding around it than the default one.
class _HorizontalRuleBuilder extends MarkdownElementBuilder {
  @override
  bool isBlockElement() => true;

  @override
  Widget visitText(md.Text text, TextStyle? preferredStyle) {
    return super.visitText(text, preferredStyle) ?? const SizedBox();
  }

  @override
  Widget? visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    return Divider();
  }
}
