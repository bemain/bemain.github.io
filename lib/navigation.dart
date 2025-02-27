import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/firestore.dart';
import 'package:portfolio/frontpage/frontpage.dart';
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
        builder: (context, state) => awaitFonts(
          (context) => Frontpage(),
        ),
      ),
      ShellRoute(
        restorationScopeId: "writing",
        builder: (context, state, child) {
          return awaitFonts(
            (context) => WritingShell(child: child),
          );
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
                redirect: (context, state) async {
                  final snapshot = await Firestore.articles
                      .where("id", isEqualTo: state.pathParameters["article"])
                      .count()
                      .get();
                  if (snapshot.count != 1) {
                    return "/writing";
                  }
                  return null;
                },
                pageBuilder: (context, state) {
                  final Query<Article> query = Firestore.articles
                      .where("id", isEqualTo: state.pathParameters["article"])
                      .limit(1);

                  return CustomTransitionPage(
                    key: state.pageKey,
                    child: FutureBuilder(
                      future: query.get(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          debugPrint("[FIRESTORE] Error: ${snapshot.error}");
                          return SizedBox();
                        }
                        if (!snapshot.hasData) {
                          return SizedBox();
                        }

                        return ArticlePane(
                          article: snapshot.data!.docs.single.data(),
                        );
                      },
                    ),
                    transitionsBuilder: (
                      context,
                      animation,
                      secondaryAnimation,
                      child,
                    ) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );

  /// The process that is loading fonts. See [awaitFonts].
  static final Future<void> _fontsPending = GoogleFonts.pendingFonts();

  /// Let google_fonts load all fonts used before calling and returning [builder].
  ///
  /// Avoids visual font swaps that occur when a font is loading
  static Widget awaitFonts(Widget Function(BuildContext context) builder) {
    return FutureBuilder(
      future: _fontsPending,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(body: SizedBox());
        }

        // Even if the loading returns an error, we still let the widget build and fallback to the default font.

        return builder(context);
      },
    );
  }

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
