import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/frontpage.dart';
import 'package:portfolio/writing/article_pane.dart';
import 'package:portfolio/writing/writing_shell.dart';

void main() {
  runApp(const MainApp());
}

const Color seedColor = Colors.deepOrange;

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => Frontpage(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        return WritingShell(child: child);
      },
      routes: [
        GoRoute(
            path: "/writing",
            builder: (context, state) {
              // TODO: Find another way to handle the case where no article is selected
              return ArticlePane(article: null);
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
                builder: (context, state) {
                  final Article article = articles.firstWhere(
                    (article) => article.id == state.pathParameters["article"],
                  );

                  return ArticlePane(article: article);
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
