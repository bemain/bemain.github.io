import 'dart:math';

import 'package:flutter/material.dart';
import 'package:portfolio/nodegraph/nodegraph_painter.dart';

class Node {
  /// A node in the nodegraph, between which paths can be drawn.
  Node({
    required this.offset,
    this.color,
    this.isStationary = false,
  });

  /// The position of the node relative to the size of the canvas.
  /// Should be between 0 and 1.
  final Offset offset;

  /// The color of the node. If `null`, the [Nodegraph.color] will be used.
  final Color? color;

  /// If true, the node is unaffected by wiggling when rendered using the [NodegraphWidget].
  final bool isStationary;

  Node copyWith({
    Offset? offset,
    Color? color,
    bool? isStationary,
  }) {
    return Node(
      offset: offset ?? this.offset,
      color: color ?? this.color,
      isStationary: isStationary ?? this.isStationary,
    );
  }
}

class Nodegraph {
  Nodegraph({
    required this.nodes,
    required this.paths,
    this.color = Colors.grey,
  });

  /// The nodes in the nodegraph.
  final List<Node> nodes;

  /// The paths between the nodes in the nodegraph. Each path is a tuple of two node indices.
  final List<(int, int)> paths;

  /// Fallback color. To override this for a specific node, set [Node.color].
  final Color color;

  Nodegraph copyWith({
    List<Node>? nodes,
    List<(int, int)>? paths,
    Color? color,
  }) {
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
    this.wiggleRadius = 5.0,
  });

  final Nodegraph nodegraph;

  final Duration wiggleSpeed;
  final double wiggleRadius;

  @override
  State<NodegraphWidget> createState() => _NodegraphWidgetState();
}

class _NodegraphWidgetState extends State<NodegraphWidget>
    with TickerProviderStateMixin {
  /// The controllers responsible for animating the nodes.
  late final List<AnimationController> _wiggleAnimations;

  /// The offset of each node when it was given its last velocity.
  late final List<Offset> _wiggleOffsets =
      List.generate(widget.nodegraph.nodes.length, (_) => Offset.zero);

  /// The current velocity of each node.
  late final List<Offset> _wiggleVelocities = List.generate(
    widget.nodegraph.nodes.length,
    (i) => _getRandomOffset() - _wiggleOffsets[i],
  );

  @override
  void initState() {
    super.initState();

    _wiggleAnimations = List.generate(
      widget.nodegraph.nodes.length,
      (i) => AnimationController(
        duration: widget.wiggleSpeed,
        vsync: this,
      )
        ..addStatusListener((AnimationStatus status) {
          if (status == AnimationStatus.completed) {
            _wiggleOffsets[i] +=
                _wiggleVelocities[i] * _wiggleAnimations[i].value;
            _wiggleVelocities[i] = _getRandomOffset() - _wiggleOffsets[i];
            _wiggleAnimations[i]
              ..duration = _getRandomDuration()
              ..reset()
              ..forward();
          }
        })
        ..forward(),
    );
  }

  @override
  void dispose() {
    for (final controller in _wiggleAnimations) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        Size size = Size.square(constraints.biggest.shortestSide);

        return AnimatedBuilder(
          animation: Listenable.merge(_wiggleAnimations),
          builder: (context, child) {
            final List<Node> nodes = widget.nodegraph.nodes.map((node) {
              if (node.isStationary) return node;

              final int index = widget.nodegraph.nodes.indexOf(node);
              final Offset wiggleOffset = _wiggleOffsets[index] +
                  _wiggleVelocities[index] * _wiggleAnimations[index].value;

              return node.copyWith(
                offset: node.offset +
                    wiggleOffset.scale(1 / size.width, 1 / size.height),
              );
            }).toList();
            return CustomPaint(
              size: size,
              painter: NodegraphPainter(
                nodegraph: widget.nodegraph.copyWith(nodes: nodes),
                nodeRadius: 1.0,
              ),
            );
          },
        );
      },
    );
  }

  /// Get a random duration that is relatively close to [widget.wiggleSpeed].
  Duration _getRandomDuration() {
    return widget.wiggleSpeed +
        Duration(
          microseconds: Random().nextInt(
              (widget.wiggleSpeed * 2.5).inMicroseconds -
                  widget.wiggleSpeed.inMicroseconds ~/ 2),
        );
  }

  /// Get a random offset within [widget.wiggleRadius].
  Offset _getRandomOffset() {
    return Offset(
      Random().nextDouble() * widget.wiggleRadius - widget.wiggleRadius / 2,
      Random().nextDouble() * widget.wiggleRadius - widget.wiggleRadius / 2,
    );
  }
}
