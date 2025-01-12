import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/frontpage.dart';

void main() {
  runApp(const MainApp());
}

const Color seedColor = Colors.deepOrange;

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
    final ThemeData darkTheme = ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.dark,
      ),
    );

    return MaterialApp(
      theme: theme.copyWith(
        textTheme: GoogleFonts.openSansTextTheme(theme.textTheme),
      ),
      darkTheme: darkTheme.copyWith(
        textTheme: GoogleFonts.openSansTextTheme(darkTheme.textTheme),
      ),
      home: Frontpage(),
    );
  }
}
