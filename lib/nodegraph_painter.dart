import 'dart:math';

import 'package:flutter/material.dart';

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
}

class NodepathPainter extends CustomPainter {
  NodepathPainter({
    required this.nodepath,
    this.nodeRadius = 3.0,
    this.pathWidth = 2.0,
  });

  final Nodegraph nodepath;

  final double nodeRadius;
  final double pathWidth;

  @override
  void paint(Canvas canvas, Size size) {
    for ((int, int) path in nodepath.paths) {
      final (from, to) = path;

      final Offset fromOffset =
          nodepath.nodes[from].offset.scale(size.width, size.height);
      final Offset toOffset =
          nodepath.nodes[to].offset.scale(size.width, size.height);

      final Paint paint = Paint()
        ..shader = LinearGradient(
                colors: [
              nodepath.nodes[from].color ?? nodepath.color,
              nodepath.nodes[to].color ?? nodepath.color,
            ],
                transform: GradientRotation(atan2(
                    toOffset.dy - fromOffset.dy, toOffset.dx - fromOffset.dx)))
            .createShader(Rect.fromPoints(fromOffset, toOffset))
        ..style = PaintingStyle.stroke
        ..strokeWidth = pathWidth;

      canvas.drawLine(fromOffset, toOffset, paint);
    }

    for (Node node in nodepath.nodes) {
      final Offset nodeOffset = node.offset.scale(size.width, size.height);

      final Paint paint = Paint()
        ..color = node.color ?? nodepath.color
        ..style = PaintingStyle.fill;

      canvas.drawCircle(nodeOffset, nodeRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant NodepathPainter oldDelegate) {
    return oldDelegate.nodepath.nodes != nodepath.nodes ||
        oldDelegate.nodepath.nodes != nodepath.nodes;
  }
}
