import 'package:flutter/foundation.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/graph.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:flutter_pan_and_zoom/core/domain/values/edge.dart';

class GraphWithDraggableNodes extends ChangeNotifier implements Graph {
  GraphWithDraggableNodes(Graph this.graph);

  Graph graph;
  List<Node> nodesBeingDragged = [];

  void drag(Node node) {
    nodesBeingDragged.add(removeNode(node));
    notifyListeners();
  }

  void stopDragging(Node node) {
    nodesBeingDragged.remove(node);
    addNode(node);
    notifyListeners();
  }

  @override
  List<Edge> get edges => graph.edges;

  @override
  List<Node> get nodes => graph.nodes;

  @override
  void set edges(edges) => graph.edges = edges;

  @override
  void set nodes(nodes) => graph.nodes = nodes;

  @override
  void addEdge(Edge edge) => graph.addEdge(edge);

  @override
  void addNode(Node node) => graph.addNode(node);

  @override
  void removeAll() => graph.removeAll();

  @override
  void removeEdge(Edge edge) => graph.removeEdge(edge);

  @override
  Node removeNode(Node node) => graph.removeNode(node);
}
