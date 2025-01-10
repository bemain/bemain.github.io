import 'package:flutter/material.dart';
import 'package:portfolio/nodegraph/butterfly_nodegraph.dart';
import 'package:portfolio/nodegraph/nodegraph_widget.dart';

class Frontpage extends StatelessWidget {
  const Frontpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) => LinearGradient(
                  colors: <Color>[Colors.amber, Colors.red],
                ).createShader(
                  Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                ),
                child: Text(
                  "Benjamin Agardh",
                  style: TextStyle(
                    fontSize: 48.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            NodegraphWidget(nodegraph: butterflyNodegraph),
            const SizedBox(height: 20.0),
            const Text(
              'I am a passionate and skilled software developer with a focus on [mention your area of expertise, e.g., mobile app development, web development, etc.]. I have a strong understanding of [mention key technologies, e.g., Flutter, Dart, etc.] and a proven ability to deliver high-quality, user-friendly applications.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
