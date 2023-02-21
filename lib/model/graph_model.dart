import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_pan_and_zoom/model/edge.dart';

import 'node.dart';

class GraphModel with ChangeNotifier {
  final List<Node> nodes = [];
  final List<Node> draggingNodes = [];
  final List<Edge> edges = [];
  Node? nodeToConnect;

  void add(Node node) {
    nodes.add(node);
    node.serialNumber = _nextSerialNumber();
    notifyListeners();
  }

  void addEdge(Node node, Node newNode) {
    edges.add(Edge(node, newNode));
  }

  void addEdgeTo(Node otherNode) {
    final edge = Edge(nodeToConnect!, otherNode);
    if (edges.contains(edge)) return;
    edges.add(edge);
    nodeToConnect = null;
    notifyListeners();
  }

  void drag(node) {
    nodes.remove(node);
    draggingNodes.add(node);
    notifyListeners();
  }

  void leaveDraggingItemAtNewOffset(Offset offset) {
    Node node = draggingNodes.removeLast();
    node.offset = offset;
    nodes.add(node);
    notifyListeners();
  }

  void remove(node) {
    nodes.remove(node);
    edges.removeWhere((edge) => edge.isConnectedTo(node));
    notifyListeners();
  }

  void removeAll() {
    edges.clear();
    nodes.clear();
    notifyListeners();
  }

  int _nextSerialNumber() {
    return nodes.map((node) => node.serialNumber).reduce(max) + 1;
  }

  void initiateConnecting(Node fromNode) {
    nodeToConnect = fromNode;
    notifyListeners();
  }
}
