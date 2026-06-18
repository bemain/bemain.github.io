import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:portfolio/navigation.dart';
import 'package:portfolio/theme.dart';

import 'firebase_options.dart';

void main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MainApp());
}

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
        textTheme: theme.textTheme.apply(fontFamily: "OpenSans"),
        actionIconTheme: ActionIconThemeData(
          backButtonIconBuilder: (context) => Icon(Symbols.arrow_back),
          closeButtonIconBuilder: (context) => Icon(Symbols.close),
          drawerButtonIconBuilder: (context) => Icon(Symbols.menu),
          endDrawerButtonIconBuilder: (context) => Icon(Symbols.menu),
        ),
      ),
      routerConfig: Navigation.router,
    );
  }
}
