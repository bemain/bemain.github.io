import 'package:flutter/material.dart';
import 'package:portfolio/writing/writing_scaffold.dart';

class WritingPage extends StatelessWidget {
  const WritingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WritingScaffold(
      title: Text("Moments that are forever"),
      body: const Placeholder(),
    );
  }
}
