import 'package:flutter/material.dart';
import 'package:portfolio/butterfly_nodegraph.dart';
import 'package:portfolio/nodegraph_painter.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: CustomPaint(
          size: Size(300, 300),
          painter: NodepathPainter(
            nodepath: butterflyNodegraph,
            nodeRadius: 1.0,
          ),
        ),
      ),
    );
  }
}
