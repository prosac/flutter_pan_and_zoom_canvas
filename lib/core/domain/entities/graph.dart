import 'package:flutter/foundation.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:flutter_pan_and_zoom/core/domain/values/edge.dart';

class Graph extends ChangeNotifier {
  List<Node> nodes = [];
  // List<Node> draggingNodes = [];
  List<Edge> edges = [];

  int aaa = 0;

  void addNode(Node node) {
    // print('addNode called');
    assert(!nodes.contains(node));

    nodes.add(node);
    // The following enables rebuilding when the list is changed.
    // TODO: this feels like a hack. Maybe ValueNotifiers per attribute are a better approach.
    // let's try next time.
    nodes = List.from(nodes);
    notifyListeners();
  }

  void addEdge(Edge edge) {
    edges.add(edge);
    edges = List.from(edges);
    notifyListeners();
  }

  Node removeNode(Node node) {
    edges.removeWhere((edge) => edge.source == node || edge.destination == node);
    nodes.remove(node);
    edges = List.from(edges);
    nodes = List.from(nodes);
    notifyListeners();
    return node;
  }

  void removeEdge(Edge edge) {
    edges.remove(edge);
    edges = List.from(edges);
    notifyListeners();
  }

  void removeAll() {
    edges.clear();
    nodes.clear();
    notifyListeners();
  }

  // NOTE: bad. the graph must not know about dragging at all
  // void drag(node) {
  //   nodes.remove(node);
  //   draggingNodes.add(node);
  //   // node.drag(); // mark as being dragged
  //   notifyListeners();
  // }

  // TODO: not fitting concept anymore
  // TODO: remove test
  // void leaveDraggingItemAtNewOffset(Offset offset) {
  //   Node node = draggingNodes.removeLast();
  //   node.dx = offset.dx;
  //   node.dy = offset.dy;
  //   nodes.add(node);
  //   notifyListeners();
  // }
}
