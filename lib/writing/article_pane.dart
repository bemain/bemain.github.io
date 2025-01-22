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
    // TODO: Maybe split the pane in two "lanes" on wider screens?
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
            RegExp("\n\n(?=[A-Z]|\")"),
            "\n\n&ensp;&ensp;&ensp;",
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
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: 8),
                MarkdownBody(
                  data: data,
                  softLineBreak: true,
                  selectable: true,
                  styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
                  // Fix so that the horizontal rule is actually build using the custom builder.
                  // See https://github.com/flutter/flutter/issues/153550
                  extensionSet: md.ExtensionSet([_HorizontalRuleSyntax()], []),
                  builders: {
                    "hhrr": _HorizontalRuleBuilder(),
                    "p": _IndentedParagraphBuilder(),
                  },
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
    return super.visitText(text, preferredStyle) ?? SizedBox();
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

class _IndentedParagraphBuilder extends MarkdownElementBuilder {
  @override
  bool isBlockElement() => true;

  @override
  Widget visitText(md.Text text, TextStyle? preferredStyle) {
    return super.visitText(text, preferredStyle) ?? SizedBox();
  }

  @override
  Widget? visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    return Text(
      element.textContent,
      style: preferredStyle ??
          parentStyle ??
          Theme.of(context).textTheme.bodyMedium,
    );
  }
}
