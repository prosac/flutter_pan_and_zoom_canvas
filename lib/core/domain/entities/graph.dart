import 'package:flutter/cupertino.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:flutter_pan_and_zoom/core/domain/values/edge.dart';

class Graph extends ChangeNotifier {
  List<Node> nodes = [];
  List<Node> draggingNodes = [];
  List<Edge> edges = [];

  Graph();

  void addNode(Node node) {
    nodes.add(node);
    notifyListeners();
  }

  void addEdge(Edge edge) {
    edges.add(edge);
    notifyListeners();
  }

  void removeNode(Node node) {
    edges.removeWhere((edge) => edge.source == node || edge.destination == node);

    nodes.remove(node);
    notifyListeners();
  }

  void removeEdge(Edge edge) {
    edges.remove(edge);
    notifyListeners();
  }

  void removeAll() {
    edges.clear();
    nodes.clear();
    notifyListeners();
  }

  // TODO: test!
  void drag(node) {
    nodes.remove(node);
    draggingNodes.add(node);
    notifyListeners();
  }

  void leaveDraggingItemAtNewOffset(Offset offset) {
    Node node = draggingNodes.removeLast();
    node.dx = offset.dx;
    node.dy = offset.dy;
    nodes.add(node);
    notifyListeners();
  }
}
