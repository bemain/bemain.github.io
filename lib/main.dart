import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/frontpage.dart';
import 'package:portfolio/writing/article_page.dart';
import 'package:portfolio/writing/writing_page.dart';

void main() {
  runApp(const MainApp());
}

const Color seedColor = Colors.deepOrange;

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => Frontpage(),
    ),
    GoRoute(
      path: "/writing",
      builder: (context, state) {
        return const WritingPage();
      },
      routes: [
        GoRoute(
          path: ":article",
          builder: (context, state) {
            final article = state.pathParameters["article"];
            return ArticlePage(assetPath: "assets/writing/$article.md");
          },
        ),
      ],
    )
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
