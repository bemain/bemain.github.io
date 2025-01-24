import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/frontpage.dart';
import 'package:portfolio/layout.dart';
import 'package:portfolio/theme.dart';
import 'package:portfolio/writing/article.dart';
import 'package:portfolio/writing/article_list.dart';
import 'package:portfolio/writing/article_pane.dart';
import 'package:portfolio/writing/writing_shell.dart';

class Navigation {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    routes: [
      GoRoute(
        path: "/",
        builder: (context, state) => Frontpage(),
      ),
      ShellRoute(
        restorationScopeId: "writing",
        builder: (context, state, child) {
          return WritingShell(child: child);
        },
        routes: [
          GoRoute(
              path: "/writing",
              builder: (context, state) {
                switch (WindowSize.of(context)) {
                  case WindowSize.compact:
                  case WindowSize.medium:
                    return const ArticleList();

                  default:
                    // On larger screens the shell will already display the article list, so just return something to fill the space
                    return Center(
                      child: _buildPlaceholderText(context),
                    );
                }
              },
              routes: [
                GoRoute(
                  path: ":article",
                  redirect: (context, state) {
                    if (!articles.any(
                      (article) =>
                          article.id == state.pathParameters["article"],
                    )) {
                      return "/writing";
                    }

                    return null;
                  },
                  pageBuilder: (context, state) {
                    final Article article = articles.firstWhere(
                      (article) =>
                          article.id == state.pathParameters["article"],
                    );

                    return CustomTransitionPage(
                        key: state.pageKey,
                        child: ArticlePane(article: article),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        });
                  },
                ),
              ]),
        ],
      ),
    ],
  );

  /// Text shown when no article is selected.
  static Widget _buildPlaceholderText(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) => primaryGradient.createShader(
            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          ),
          child: Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              "Moments",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
        Text(
          "that are forever",
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
