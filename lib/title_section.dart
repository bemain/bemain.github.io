import 'package:flutter/material.dart';
import 'package:portfolio/layout.dart';
import 'package:portfolio/nodegraph/butterfly_nodegraph.dart';
import 'package:portfolio/nodegraph/nodegraph_widget.dart';

class TitleSection extends StatelessWidget {
  const TitleSection({super.key, required this.windowSize});

  final WindowSize windowSize;

  @override
  Widget build(BuildContext context) {
    final RenderBox? box = context.findRenderObject() as RenderBox?;
    final Offset position = box?.localToGlobal(Offset.zero) ?? Offset.zero;

    return SizedBox(
      height: MediaQuery.sizeOf(context).height -
          position.dy -
          MediaQuery.paddingOf(context).bottom,
      child: Padding(
        padding: windowSize.padding,
        child: switch (windowSize) {
          WindowSize.compact || WindowSize.medium => Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTitle(context),
                      _buildSubtitle(context),
                      _buildButterfly(context),
                    ],
                  ),
                ),
                _buildDownArrow(context),
              ],
            ),
          WindowSize.expanded ||
          WindowSize.large ||
          WindowSize.extraLarge =>
            Column(
              children: [
                Expanded(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 1024),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: _buildButterfly(context),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                _buildTitle(context),
                                _buildSubtitle(context),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _buildDownArrow(context),
              ],
            ),
        },
      ),
    );
  }

  Widget _buildTitle(
    BuildContext context, {
    String text = "Benjamin Agardh",
  }) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => LinearGradient(
        colors: <Color>[Colors.amber, Colors.red],
      ).createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }

  Widget _buildSubtitle(
    BuildContext context, {
    String text = "Blending elegant UI and cutting-edge technology",
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 480),
      child: Text(
        text,
        style: Theme.of(context).textTheme.headlineMedium,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildButterfly(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 320),
          child: NodegraphWidget(nodegraph: butterflyNodegraph),
        ),
      ),
    );
  }

  Widget _buildDownArrow(BuildContext context) {
    // TODO: Make this clickable
    return Padding(
      padding: EdgeInsets.all(24),
      child: Icon(
        Icons.keyboard_arrow_down,
        size: 48,
      ),
    );
  }
}
