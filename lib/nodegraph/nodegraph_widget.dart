import 'dart:math';

import 'package:flutter/material.dart';
import 'package:portfolio/nodegraph/nodegraph_painter.dart';

class Node {
  Node({
    required this.offset,
    this.color,
  });

  /// The position of the node relative to the size of the canvas.
  /// Should be between 0 and 1.
  final Offset offset;

  final Color? color;
}

class Nodegraph {
  Nodegraph({
    required this.nodes,
    required this.paths,
    this.color = Colors.grey,
  });

  final List<Node> nodes;
  final List<(int, int)> paths;

  /// Fallback color. To override this for a specific node, set [Node.color].
  final Color color;

  Nodegraph copyWith(
      {List<Node>? nodes, List<(int, int)>? paths, Color? color}) {
    return Nodegraph(
      nodes: nodes ?? this.nodes,
      paths: paths ?? this.paths,
      color: color ?? this.color,
    );
  }
}

class NodegraphWidget extends StatefulWidget {
  const NodegraphWidget({
    super.key,
    required this.nodegraph,
    this.wiggleSpeed = const Duration(seconds: 1),
    this.wiggleRadius = 2.0,
  });

  final Nodegraph nodegraph;

  final Duration wiggleSpeed;
  final double wiggleRadius;

  @override
  State<NodegraphWidget> createState() => _NodegraphWidgetState();
}

class _NodegraphWidgetState extends State<NodegraphWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<Offset>> _offsetAnimations;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.wiggleSpeed,
      vsync: this,
    )
      ..addListener(_onAnimationEnd)
      ..forward();

    _offsetAnimations = List.generate(
      widget.nodegraph.nodes.length,
      (index) => Tween<Offset>(
        begin: Offset.zero,
        end: _getRandomOffset(),
      ).animate(_controller),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = Size.square(400);
    return AnimatedBuilder(
      animation: Listenable.merge(_offsetAnimations),
      builder: (context, child) {
        final List<Node> nodes = widget.nodegraph.nodes
            .map((node) => Node(
                  offset: node.offset +
                      _offsetAnimations[widget.nodegraph.nodes.indexOf(node)]
                          .value
                          .scale(1 / size.width, 1 / size.height),
                  color: node.color,
                ))
            .toList();
        return CustomPaint(
          size: size,
          painter: NodegraphPainter(
            nodegraph: widget.nodegraph.copyWith(nodes: nodes),
            nodeRadius: 1.0,
          ),
        );
      },
    );
  }

  void _onAnimationEnd() {
    if (_controller.status == AnimationStatus.completed) {
      _offsetAnimations = List.generate(
        widget.nodegraph.nodes.length,
        (i) => Tween<Offset>(
          begin: _offsetAnimations[i].value, // Start from the current position
          end: _getRandomOffset(),
        ).animate(_controller),
      );

      _controller.reset();
      _controller.forward();
    }
  }

  Offset _getRandomOffset() {
    return Offset(
      Random().nextDouble() * widget.wiggleRadius - widget.wiggleRadius / 2,
      Random().nextDouble() * widget.wiggleRadius - widget.wiggleRadius / 2,
    );
  }
}
