import 'dart:math';

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_pan_and_zoom/model/edge.dart';
import 'package:flutter_pan_and_zoom/test_data.dart';

import 'node.dart';

class GraphModel with ChangeNotifier {
  /// Internal, private state of the model.
  final List<Node> nodes = [];
  final List<Node> draggingNodes = [];
  final List<Edge> edges = [];
  Ticker ticker = Ticker((_) => {});
  double scale = 1.0;

  Offset interactiveViewerOffset = Offset.zero;

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

  // TODO: needed?
  Node newNode({required Offset offset, required TestData payload}) {
    Node node = Node(offset: offset, payload: payload);
    add(node);
    return node;
  }

  void offsetFromMatrix(Matrix4 matrix) {
    interactiveViewerOffset = Offset(matrix.row0[3], matrix.row1[3]);
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

  void startTicker(Node node) {
    var renderBoxOfNode =
        node.presentation?.key.currentContext?.findRenderObject() as RenderBox;

    var elacs = pow(scale, -1).toDouble();

    ticker = Ticker((_) {
      node.offset = renderBoxOfNode
          .localToGlobal(Offset.zero)
          .scale(elacs, elacs)
          .translate(-interactiveViewerOffset.dx * elacs,
              -interactiveViewerOffset.dy * elacs);

      notifyListeners();
    });

    ticker.start();
  }

  void stopTicker() {
    ticker.stop();
  }

  int _nextSerialNumber() {
    return nodes.map((node) => node.serialNumber).reduce(max) + 1;
  }
}
