import 'package:flutter/material.dart';
import 'package:portfolio/nodegraph/nodegraph_widget.dart';

extension ColorMap on Map<Offset, Color> {
  /// Calculate the color at a [point] by using 2D interpolation.
  Color colorAt(Offset point) {
    // Calculate weights for each color based on inverse distance
    Map<Color, double> weightedColors = {};
    for (MapEntry<Offset, Color> entry in entries) {
      final double distance = (entry.key - point).distance;
      final double weight = 1 / (distance + 1e-6); // Avoid division by zero
      weightedColors[entry.value] = weight;
    }

    Color result = Color.fromARGB(0, 0, 0, 0); // Start with transparent color
    // Interpolate colors based on weights
    for (MapEntry<Color, double> entry in weightedColors.entries) {
      // Normalize weights
      final double weight =
          entry.value / weightedColors.values.fold(0, (p, c) => p + c);
      // This method of interpolation isn't perfect, as colors that are applied later are more dominant... but it works good enough for now
      result = Color.lerp(result, entry.key, weight)!;
    }

    return result;
  }
}

final List<Node> butterflyNodes = [
  Node(offset: Offset(0.0, 0.0), color: Colors.transparent), // 0
  Node(offset: Offset(0.043, 0.120)),
  Node(offset: Offset(0.099, 0.092)),
  Node(offset: Offset(0.196, 0.155)),
  Node(offset: Offset(0.010, 0.358)),
  Node(offset: Offset(0.095, 0.526)),
  Node(offset: Offset(0.206, 0.535)),
  Node(offset: Offset(0.236, 0.260)),
  Node(offset: Offset(0.308, 0.321)),
  Node(offset: Offset(0.384, 0.147)),
  Node(offset: Offset(0.497, 0.028)), // 10
  Node(offset: Offset(0.584, 0.023)),
  Node(offset: Offset(0.570, 0.180)),
  Node(offset: Offset(0.405, 0.390)),
  Node(offset: Offset(0.596, 0.257)),
  Node(offset: Offset(0.656, 0.352)),
  Node(offset: Offset(0.293, 0.557)),
  Node(offset: Offset(0.397, 0.533)),
  Node(offset: Offset(0.317, 0.732)),
  Node(offset: Offset(0.378, 0.657)),
  Node(offset: Offset(0.656, 0.518)), // 20
  Node(offset: Offset(0.798, 0.523)),
  Node(offset: Offset(0.884, 0.609)),
  Node(offset: Offset(0.644, 0.709)),
  Node(offset: Offset(0.762, 0.660)),
  Node(offset: Offset(0.911, 0.724)),
  Node(offset: Offset(0.491, 0.857)),
  Node(offset: Offset(0.832, 0.844)),
  Node(offset: Offset(0.911, 0.839)),
  Node(offset: Offset(0.646, 0.909)),
  Node(offset: Offset(0.779, 0.921)), // 30
  Node(offset: Offset(0.875, 0.914)),
  Node(offset: Offset(0.372, 0.825)),
  Node(offset: Offset(0.358, 0.858)),
  Node(offset: Offset(0.442, 0.858)),
  Node(offset: Offset(0.491, 0.882)),
  Node(offset: Offset(0.533, 0.928)),
  Node(offset: Offset(0.594, 0.951)),
  Node(offset: Offset(0.565, 0.979)),
  Node(offset: Offset(0.466, 0.932)),
  Node(offset: Offset(0.414, 0.888)), // 40
  Node(offset: Offset(0.684, 0.432)),
  Node(offset: Offset(0.298, 0.778)),
  Node(offset: Offset(0.292, 0.795)),
  Node(offset: Offset(0.301, 0.816)),
  Node(offset: Offset(0.269, 0.817)),
  Node(offset: Offset(0.150, 0.769)),
  Node(offset: Offset(0.157, 0.784)),
  Node(offset: Offset(0.064, 0.749)),
  Node(offset: Offset(0.059, 0.731)), // 50
  Node(offset: Offset(0.033, 0.747)),
  Node(offset: Offset(0.220, 0.721)),
  Node(offset: Offset(0.210, 0.732)),
  Node(offset: Offset(0.135, 0.665)),
  Node(offset: Offset(0.138, 0.648)),
  Node(offset: Offset(0.110, 0.662)),
  Node(offset: Offset(0.295, 0.785)),
];

final List<(int, int)> _butterflyPaths = [
  (1, 2),
  (1, 4),
  (2, 3),
  (2, 4),
  (2, 6),
  (3, 6),
  (3, 7),
  (4, 5),
  (4, 6),
  (5, 6),
  (5, 42),
  (6, 7),
  (6, 8),
  (6, 16),
  (6, 42),
  (7, 8),
  (8, 9),
  (8, 13),
  (8, 16),
  (9, 10),
  (10, 11),
  (10, 12),
  (10, 13),
  (11, 12),
  (12, 13),
  (12, 14),
  (13, 15),
  (13, 16),
  (13, 17),
  (13, 18),
  (14, 15),
  (15, 17),
  (15, 19),
  (15, 41),
  (16, 18),
  (17, 19),
  (18, 19),
  (18, 32),
  (18, 42),
  (19, 20),
  (19, 32),
  (20, 21),
  (20, 23),
  (20, 32),
  (21, 22),
  (21, 23),
  (22, 24),
  (22, 25),
  (23, 24),
  (23, 26),
  (23, 32),
  (24, 25),
  (24, 26),
  (25, 26),
  (25, 27),
  (25, 28),
  (26, 27),
  (26, 29),
  (26, 34),
  (27, 28),
  (27, 29),
  (27, 30),
  (28, 30),
  (28, 31),
  (29, 30),
  (30, 31),
  (32, 33),
  (32, 34),
  (32, 42),
  (33, 34),
  (33, 40),
  (33, 42),
  (33, 44),
  (34, 35),
  (34, 39),
  (35, 36),
  (36, 37),
  (36, 38),
  (36, 39),
  (37, 38),
  (38, 39),
  (39, 40),
  (42, 43),
  (42, 51),
  (43, 44),
  (43, 45),
  (43, 47),
  (44, 45),
  (46, 47),
  (46, 48),
  (46, 49),
  (46, 56),
  (47, 48),
  (48, 49),
  (48, 50),
  (49, 50),
  (51, 52),
  (51, 54),
  (52, 53),
  (52, 54),
  (52, 56),
  (53, 54),
  (53, 55),
  (54, 55),
  (41, 20),
];

final Map<Offset, Color> _butterflyColorMap = {
  Offset(0, 0.3): Colors.amber,
  Offset(1, 0.7): Colors.red,
};

final Nodegraph butterflyNodegraph = Nodegraph(
  nodes: butterflyNodes.map((node) {
    // Apply gradient color to nodes
    final Color color = _butterflyColorMap.colorAt(node.offset).withAlpha(255);
    return Node(
      offset: node.offset,
      color: node.color ?? color,
      isStationary: butterflyNodes.indexOf(node) >= 32,
    );
  }).toList(),
  paths: _butterflyPaths,
);
