import 'package:flutter/material.dart';
import 'package:portfolio/layout.dart';

class MusbxFrontpage extends StatelessWidget {
  const MusbxFrontpage({super.key});

  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize =
        WindowSize.fromSize(MediaQuery.sizeOf(context));

    return Scaffold(
      appBar: AppBar(
        title: Text("Musician's Toolbox"),
      ),
      body: Padding(
        padding: windowSize.padding,
        child: Column(
          children: [
            Text("Welcome to the frontpage for Musician's Toolbox!"),
          ],
        ),
      ),
    );
  }
}
