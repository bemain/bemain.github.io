import 'package:flutter/material.dart';
import 'package:portfolio/layout.dart';
import 'package:portfolio/frontpage/nodegraph/butterfly_nodegraph.dart';
import 'package:portfolio/frontpage/nodegraph/nodegraph_widget.dart';
import 'package:portfolio/theme.dart';

class TitleSection extends StatelessWidget {
  const TitleSection({
    super.key,
    this.onGetInTouchPressed,
    this.onScrollDownPressed,
  });

  final Function()? onGetInTouchPressed;

  /// Callback for when the down arrow at the end of the section is pressed.
  /// The intention is to scroll down to the next section.
  final Function()? onScrollDownPressed;

  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSize.of(context);

    return Padding(
      padding: windowSize.margin,
      child: switch (windowSize) {
        WindowSize.compact || WindowSize.medium => Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    _buildTitle(context),
                    _buildSubtitle(context),
                    Flexible(
                      child: _buildButterfly(context),
                    ),
                    const SizedBox(height: 8),
                    if (onGetInTouchPressed != null)
                      _buildContactButton(context),
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
                  constraints: BoxConstraints(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: _buildButterfly(context),
                      ),
                      const SizedBox(width: 24),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          _buildTitle(context),
                          _buildSubtitle(context),
                          const SizedBox(height: 32),
                          _buildContactButton(context),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              _buildDownArrow(context),
            ],
          ),
      },
    );
  }

  Widget _buildTitle(
    BuildContext context, {
    String text = "Benjamin Agardh",
  }) {
    final WindowSize windowSize = WindowSize.of(context);

    final TextStyle? textStyle = switch (windowSize) {
      WindowSize.compact => Theme.of(context).textTheme.displaySmall,
      _ => Theme.of(context).textTheme.displayMedium,
    };

    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => primaryGradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: textStyle?.copyWith(
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
    final WindowSize windowSize = WindowSize.of(context);

    final TextStyle? textStyle = switch (windowSize) {
      WindowSize.compact => Theme.of(context).textTheme.headlineSmall,
      _ => Theme.of(context).textTheme.headlineMedium,
    };

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: switch (windowSize) {
          WindowSize.compact => 360,
          _ => 480,
        },
      ),
      child: Text(
        text,
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildButterfly(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.biggest.shortestSide < 240) {
          return const SizedBox(height: 24);
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 320),
            child: AspectRatio(
              aspectRatio: 1,
              child: Center(
                child: NodegraphWidget(nodegraph: butterflyNodegraph),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContactButton(BuildContext context) {
    return Center(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.all(24),
          textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(),
        ),
        onPressed: () {
          onGetInTouchPressed?.call();
        },
        child: Text("Get in touch"),
      ),
    );
  }

  Widget _buildDownArrow(BuildContext context) {
    // TODO: Make this clickable
    return Padding(
      padding: EdgeInsets.all(24),
      child: IconButton(
        onPressed: onScrollDownPressed,
        icon: Icon(
          Icons.keyboard_arrow_down,
          size: 48,
        ),
      ),
    );
  }
}
