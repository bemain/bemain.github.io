import 'package:flutter/material.dart';
import 'package:portfolio/layout.dart';
import 'package:portfolio/nodegraph/butterfly_nodegraph.dart';
import 'package:portfolio/nodegraph/nodegraph_widget.dart';

class TitleSection extends StatelessWidget {
  const TitleSection({super.key, required this.windowSize});

  final WindowSize windowSize;

  @override
  Widget build(BuildContext context) {
    switch (windowSize) {
      case WindowSize.compact:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: _buildTitle(),
            ),
            _buildSubtitle(context),
          ],
        );

      case WindowSize.medium:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 24),
            Center(
              child: _buildTitle(),
            ),
            _buildSubtitle(context),
            const SizedBox(height: 48),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 320.0),
              child: NodegraphWidget(nodegraph: butterflyNodegraph),
            ),
            const SizedBox(height: 24),
          ],
        );

      case WindowSize.expanded:
      case WindowSize.large:
      case WindowSize.extraLarge:
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 1024),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 48),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 320),
                        child: NodegraphWidget(nodegraph: butterflyNodegraph),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        _buildTitle(),
                        _buildSubtitle(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
    }
  }

  Widget _buildTitle({String text = "Benjamin Agardh"}) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => LinearGradient(
        colors: <Color>[Colors.amber, Colors.red],
      ).createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 48.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSubtitle(
    BuildContext context, {
    String text = "Blending elegant UI and cutting-edge technology",
  }) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headlineLarge,
      textAlign: TextAlign.center,
    );
  }
}
