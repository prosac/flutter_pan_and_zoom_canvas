import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_pan_and_zoom/model/edge.dart';
import 'package:flutter_pan_and_zoom/test_data.dart';

import 'node.dart';

class GraphModel with ChangeNotifier {
  final List<Node> nodes = [];
  final List<Node> draggingNodes = [];
  final List<Edge> edges = [];
  bool connecting = false;
  Node? nodeToBeConnected; // TODO: use Maybe/Option or default object?
  Node tempNode = Node(offset: Offset.zero, payload: TestData());

  void add(Node node) {
    nodes.add(node);
    node.serialNumber = _nextSerialNumber();
    notifyListeners();
  }

  void addEdge(Node node, Node newNode) {
    edges.add(Edge(node, newNode));
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

  void initiateConnecting(Node node) {
    connecting = true;
    nodeToBeConnected = node;
    draggingNodes.add(tempNode);
    addEdge(node, tempNode);
  }
}
