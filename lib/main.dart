import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/frontpage.dart';
import 'package:portfolio/layout.dart';
import 'package:portfolio/writing/article.dart';
import 'package:portfolio/writing/article_list.dart';
import 'package:portfolio/writing/article_pane.dart';
import 'package:portfolio/writing/writing_shell.dart';

void main() {
  runApp(const MainApp());
}

const Color seedColor = Colors.deepOrange;

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  initialLocation: "/writing",
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
                  // On larger screens the shell will already display the article list, so just return an empty container
                  return const Center(
                    child: Text("No moment selected"),
                  );
              }
            },
            routes: [
              GoRoute(
                path: ":article",
                redirect: (context, state) {
                  if (!articles.any(
                    (article) => article.id == state.pathParameters["article"],
                  )) {
                    return "/writing";
                  }

                  return null;
                },
                pageBuilder: (context, state) {
                  final Article article = articles.firstWhere(
                    (article) => article.id == state.pathParameters["article"],
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

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.dark,
      ),
    );

    return MaterialApp.router(
      theme: theme.copyWith(
        textTheme: GoogleFonts.openSansTextTheme(theme.textTheme),
      ),
      routerConfig: router,
    );
  }
}
