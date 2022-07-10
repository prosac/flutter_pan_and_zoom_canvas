import 'dart:math';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_pan_and_zoom/model/edge.dart';

import 'node.dart';

class GraphModel with ChangeNotifier {
  /// Internal, private state of the model.
  final List<Node> _nodes = [];
  final List<Node> _draggingNodes = [];
  final List<Edge> _edges = [];
  Ticker? ticker;
  double scale = 1.0; // TODO: should come from the outside

  Offset interactiveViewerOffset = Offset.zero;

  List<Node> get nodes => _nodes;
  List<Node> get draggingNodes => _draggingNodes;
  List<Edge> get edges => _edges;

  set edges(edge) {
    _edges.add(edge);
  }

  void add(Node node) {
    _nodes.add(node);
    node.serialNumber = nextSerialNumber();
    notifyListeners();
  }

  // void addFromExistingNode(Node existingNode, Node newNode) {
  //   newNode.serialNumber = nextSerialNumber();
  //   _nodes.add(newNode);
  //   _connections.add(Edgj(existingNode, newNode));
  //   notifyListeners();
  // }

  void remove(node) {
    _nodes.remove(node);
    _edges.removeWhere((edge) => edge.isConnectedTo(node));
    notifyListeners();
  }

  void removeAll() {
    _edges.clear();
    _nodes.clear();
    notifyListeners();
  }

  void drag(node) {
    _nodes.remove(node);
    _draggingNodes.add(node);
    notifyListeners();
  }

  void startTicker(Node node) {
    // TODO: make all this stuff nullsave
    RenderBox box =
        node.presentation?.key.currentContext?.findRenderObject() as RenderBox;

    ticker = Ticker((elapsed) {
      double elacs = pow(scale, -1).toDouble();

      Offset offset = box
          .localToGlobal(Offset.zero)
          .scale(elacs, elacs)
          .translate(-interactiveViewerOffset.dx * elacs,
              -interactiveViewerOffset.dy * elacs);
      node.offset = offset;
      notifyListeners();
    });

    ticker?.start();
  }

  void stopTicker() {
    ticker?.stop();
  }

  int nextSerialNumber() {
    return _nodes.map((node) => node.serialNumber).reduce(max) + 1;
  }

  void leaveDraggingItemAtNewOffset(Offset offset) {
    Node node = _draggingNodes.removeLast();
    node.offset = offset;
    _nodes.add(node);
    notifyListeners();
  }

  void offsetFromMatrix(Matrix4 matrix) {
    interactiveViewerOffset = Offset(matrix.row0[3], matrix.row1[3]);
  }
}
