import 'package:flutter/material.dart';
import 'package:portfolio/nodegraph/butterfly_nodegraph.dart';
import 'package:portfolio/nodegraph/nodegraph_widget.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: NodegraphWidget(nodegraph: butterflyNodegraph),
      ),
    );
  }
}
