import 'dart:math';

import 'package:flutter/material.dart';
import 'package:portfolio/nodegraph_widget.dart';

class NodegraphPainter extends CustomPainter {
  NodegraphPainter({
    required this.nodegraph,
    this.nodeRadius = 3.0,
    this.pathWidth = 2.0,
  });

  final Nodegraph nodegraph;

  final double nodeRadius;
  final double pathWidth;

  @override
  void paint(Canvas canvas, Size size) {
    for ((int, int) path in nodegraph.paths) {
      final (from, to) = path;

      final Offset fromOffset =
          nodegraph.nodes[from].offset.scale(size.width, size.height);
      final Offset toOffset =
          nodegraph.nodes[to].offset.scale(size.width, size.height);

      final Paint paint = Paint()
        ..shader = LinearGradient(
                colors: [
              nodegraph.nodes[from].color ?? nodegraph.color,
              nodegraph.nodes[to].color ?? nodegraph.color,
            ],
                transform: GradientRotation(atan2(
                    toOffset.dy - fromOffset.dy, toOffset.dx - fromOffset.dx)))
            .createShader(Rect.fromPoints(fromOffset, toOffset))
        ..style = PaintingStyle.stroke
        ..strokeWidth = pathWidth;

      canvas.drawLine(fromOffset, toOffset, paint);
    }

    for (Node node in nodegraph.nodes) {
      final Offset nodeOffset = node.offset.scale(size.width, size.height);

      final Paint paint = Paint()
        ..color = node.color ?? nodegraph.color
        ..style = PaintingStyle.fill;

      canvas.drawCircle(nodeOffset, nodeRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant NodegraphPainter oldDelegate) {
    return oldDelegate.nodegraph.nodes != nodegraph.nodes ||
        oldDelegate.nodegraph.nodes != nodegraph.nodes;
  }
}
