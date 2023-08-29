import 'package:flutter/foundation.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:flutter_pan_and_zoom/core/domain/values/edge.dart';

class Graph extends ChangeNotifier {
  List<Node> _nodes = [];
  List<Node> draggingNodes = [];
  List<Edge> edges = [];

  List<Node> get nodes => _nodes..sort((a, b) => a.createdAt.compareTo(b.createdAt));

  void addNode(Node node) {
    assert(!nodes.contains(node));

    if (nodes.length >= 1) {
      // Node source = nodes.where((element) => element.id == node.id - 1).last;
      addEdge(Edge(source: nodes[nodes.length - 1], destination: node));
      edges = List.from(edges);
    }

    nodes.add(node);
    // NOTE: The following enables rebuilding when the list is changed.
    // TODO: this feels like a hack. Maybe ValueNotifiers per attribute are a better approach.
    _nodes = List.from(nodes);
    notifyListeners();
  }

  void addEdge(Edge edge) {
    assert(!edges.contains(edge));

    edges.add(edge);
    edges = List.from(edges);
    notifyListeners();
  }

  Node removeNode(Node node) {
    edges.removeWhere((edge) => edge.source == node || edge.destination == node);
    nodes.remove(node);
    edges = List.from(edges);
    _nodes = List.from(nodes);
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

  void drag(Node node) {
    _nodes.remove(node);
    draggingNodes.add(node);
    edges = List.from(edges);
    _nodes = List.from(nodes);
    draggingNodes = List.from(draggingNodes);
    notifyListeners();
  }

  void stopDragging() {
    var node = draggingNodes.last;
    draggingNodes.remove(node);
    _nodes.add(node);
    edges = List.from(edges);
    _nodes = List.from(nodes);
    draggingNodes = List.from(draggingNodes);
    notifyListeners();
  }

  void notify() {
    print('graph notified');
    edges = List.from(edges);
    _nodes = List.from(nodes);
    notifyListeners();
  }
}
