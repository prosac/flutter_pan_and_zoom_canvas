import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:flutter_pan_and_zoom/core/domain/values/edge.dart';

class Graph {
  List<Node> nodes = [];
  List<Edge> edges = [];

  Graph();

  void addNode(Node node) {
    nodes.add(node);
  }

  void addEdge(Edge edge) {
    edges.add(edge);
  }

  void removeNode(Node node) {
    edges.removeWhere((edge) => edge.source == node || edge.destination == node);

    nodes.remove(node);
  }

  void removeEdge(Edge edge) {
    edges.remove(edge);
  }

  void removeAll() {
    edges.clear();
    nodes.clear();
  }
}
