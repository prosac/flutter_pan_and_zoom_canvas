import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';

class Edge {
  Edge({required this.node, required this.otherNode});

  final Node node;
  final Node otherNode;

  bool isConnectedTo(node) {
    return (node == node || node == otherNode);
  }

  @override
  bool operator ==(Object other) {
    if (other is Edge) {
      return node == other.node && otherNode == other.otherNode;
    }
    return false;
  }
}
