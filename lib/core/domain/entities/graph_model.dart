import 'package:flutter/widgets.dart';
import 'package:flutter_pan_and_zoom/core/domain/values/edge.dart';

import 'node.dart';

// TODO: transfer everything to the clean arch approach
// TODO: think about if a graph entity as facade should maybe still exist
class GraphModel with ChangeNotifier {
  final List<Node> draggingNodes = [];
  // Node? nodeToConnect;

  // void addEdgeTo(Node otherNode) {
  //   // TODO: what to do when there is no nodeToConnect?
  //   final edge = Edge(node: nodeToConnect!, otherNode: otherNode);
  //   if (edges.contains(edge)) return;
  //   edges.add(edge);
  //   nodeToConnect = null;
  // }

  void drag(node) {
    nodes.remove(node);
    draggingNodes.add(node);
  }

  void leaveDraggingItemAtNewOffset(Offset offset) {
    Node node = draggingNodes.removeLast();
    node.offset = offset;
    nodes.add(node);
  }

  void initiateConnecting(Node fromNode) {
    nodeToConnect = fromNode;
  }
}
