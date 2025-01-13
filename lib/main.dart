import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/frontpage.dart';
import 'package:portfolio/musbx/frontpage.dart';
import 'package:portfolio/musbx/privacy.dart';

void main() {
  usePathUrlStrategy();
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
      path: "/musbx",
      builder: (context, state) => MusbxFrontpage(),
      routes: [
        GoRoute(
          path: "/privacy",
          builder: (context, state) => MusbxPrivacyPolicy(),
        ),
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
